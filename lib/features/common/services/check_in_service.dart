// Dart imports:
import 'dart:developer';
import 'dart:typed_data';

// Package imports:
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/image_to_file_service.dart';
import 'package:qolshatyr_mobile/features/common/services/notification_service.dart';
import 'package:qolshatyr_mobile/features/common/services/twilio_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';
import 'package:qolshatyr_mobile/features/trip/models/trip.dart';

class CheckInService {
  static final CheckInService _instance = CheckInService._internal();
  factory CheckInService() => _instance;

  static Database? _database;

  CheckInService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'check_ins.db');

    return await openDatabase(
      path,
      version: 3, // Увеличиваем версию базы данных
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE check_ins(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            check_in_time INTEGER
          )
        ''');

        await db.execute('''
         CREATE TABLE trips(
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           start_location_lat REAL,
           start_location_lon REAL,
           end_location_lat REAL,
           end_location_lon REAL,
           estimate_duration INTEGER,
           start_time INTEGER,
           end_time INTEGER,
           image_path TEXT  -- Store the image file path
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('''
          ALTER TABLE trips ADD COLUMN image_path TEXT
        ''');
        }
      },
    );
  }

  // Сохранить текущую поездку с изображением
  Future<void> saveTrip(Trip trip, Uint8List? imageBytes) async {
    final db = await database;

    String? imagePath;
    if (imageBytes != null) {
      imagePath = await ImageToFileService().saveImageToFile(
        imageBytes,
        'trip_${trip.startTime.millisecondsSinceEpoch}',
      );
    }

    await db.insert('trips', {
      'start_location_lat': trip.startLocation.latitude,
      'start_location_lon': trip.startLocation.longitude,
      'end_location_lat': trip.endLocation.latitude,
      'end_location_lon': trip.endLocation.longitude,
      'estimate_duration': trip.estimateDuration.inMinutes,
      'start_time': trip.startTime.millisecondsSinceEpoch,
      'end_time': trip.endTime.millisecondsSinceEpoch,
      'image_path': imagePath, // Store the image file path
    });
  }

  // Получить данные о последней поездке
  Future<Trip?> getLastTrip() async {
    final db = await database;
    final result = await db.query(
      'trips',
      orderBy: 'start_time DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      final lastTrip = result.first;
      final imagePath = lastTrip['image_path'] as String?;

      Uint8List? imageBytes;
      if (imagePath != null) {
        final imageFile = await ImageToFileService().getImageFile(imagePath);
        imageBytes = await imageFile.readAsBytes();
      }

      return Trip(
        startLocation: LocationData.fromMap({
          'latitude': lastTrip['start_location_lat'],
          'longitude': lastTrip['start_location_lon'],
        }),
        endLocation: LocationData.fromMap({
          'latitude': lastTrip['end_location_lat'],
          'longitude': lastTrip['end_location_lon'],
        }),
        estimateDuration:
            Duration(minutes: lastTrip['estimate_duration'] as int),
        startTime:
            DateTime.fromMillisecondsSinceEpoch(lastTrip['start_time'] as int),
        endTime:
            DateTime.fromMillisecondsSinceEpoch(lastTrip['end_time'] as int),
        isOngoing: false,
        image: imageBytes, // Load image bytes from the file
      );
    }
    return null;
  }

  // Получить данные о ВСЕХ поездках
  Future<List<Trip>> getAllTrips() async {
    final db = await database;
    final result = await db.query('trips');

    List<Trip> trips = [];

    for (var tripData in result) {
      final imagePath = tripData['image_path'] as String?;

      Uint8List? imageBytes;
      if (imagePath != null) {
        final imageFile = await ImageToFileService().getImageFile(imagePath);
        imageBytes = await imageFile.readAsBytes();
      }

      Trip trip = Trip(
        startLocation: LocationData.fromMap({
          'latitude': tripData['start_location_lat'],
          'longitude': tripData['start_location_lon'],
        }),
        endLocation: LocationData.fromMap({
          'latitude': tripData['end_location_lat'],
          'longitude': tripData['end_location_lon'],
        }),
        estimateDuration:
            Duration(minutes: tripData['estimate_duration'] as int),
        startTime:
            DateTime.fromMillisecondsSinceEpoch(tripData['start_time'] as int),
        endTime:
            DateTime.fromMillisecondsSinceEpoch(tripData['end_time'] as int),
        isOngoing: false,
        image: imageBytes, // Return image bytes for each trip
      );
      trips.add(trip);
    }

    return trips;
  }

  // Удалить все поездки
  Future<void> deleteAllTrips() async {
    final db = await database;
    await db.delete('trips');
  }

  // Удалить поездку по дате
  Future<void> deleteTripByDate(DateTime date) async {
    final db = await database;
    final startOfDay =
        DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59)
        .millisecondsSinceEpoch;

    await db.delete(
      'trips',
      where: 'start_time >= ? AND start_time <= ?',
      whereArgs: [startOfDay, endOfDay],
    );
  }

  // Проверка необходимости активации SOS с учетом поездки
  Future<void> checkForOverdueTrip(Duration tripInterval) async {
    final lastTrip = await getLastTrip();
    if (lastTrip == null) {
      await triggerSos();
      return;
    }

    final now = DateTime.now();
    if (now.difference(lastTrip.startTime) > tripInterval) {
      await triggerSos();
    }
  }

  // Активировать SOS
  Future<void> triggerSos() async {
    List<Contact> contacts = await SharedPreferencesManager.getContacts();
    if (contacts.isNotEmpty) {
      LocationData location =
          await SharedPreferencesManager.getLastLocation() as LocationData;

      for (int i = 0; i < contacts.length; i++) {
        TwilioService.sendMessage(
          contacts[i].phoneNumber.trim(),
          'QOLSHATYR: Help me lat:${location.latitude} long:${location.longitude}\n https://qolshatyr.netlify.app/!',
        );

        // TwilioService.sendWhatsApp(contacts[i].phoneNumber.trim(), 'Qolshatyr');
        // await FlutterPhoneDirectCaller.callNumber(contacts[i].phoneNumber);
        // bool didAnswer = await NotificationService.showCallResultNotification();
        // log('TEST: $didAnswer');
        // if (didAnswer) {
        //   break;
        // }
      }
    }
  }
}
