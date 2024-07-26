// Package imports:
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/services/notification_service.dart';
import 'package:qolshatyr_mobile/features/common/services/twilio_service.dart';
import 'package:qolshatyr_mobile/features/common/utils/shared_preferences.dart';
import 'package:qolshatyr_mobile/features/contacts/call_service.dart';
import 'package:qolshatyr_mobile/features/contacts/contact_model.dart';

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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE check_ins(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            check_in_time INTEGER
          )
        ''');
      },
    );
  }

  // Сохранить текущее время чекина
  Future<void> saveCheckIn() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert('check_ins', {'check_in_time': now});
  }

  // Получить время последнего чекина
  Future<DateTime?> getLastCheckIn() async {
    final db = await database;
    final result = await db.query(
      'check_ins',
      orderBy: 'check_in_time DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      final lastCheckIn = result.first['check_in_time'] as int;
      return DateTime.fromMillisecondsSinceEpoch(lastCheckIn);
    }
    return null;
  }

  // Проверка необходимости активации SOS
  Future<void> checkForOverdueCheckIn(Duration checkInInterval) async {
    final lastCheckIn = await getLastCheckIn();
    if (lastCheckIn == null) {
      await triggerSos();
      return;
    }

    final now = DateTime.now();
    if (now.difference(lastCheckIn) > checkInInterval) {
      await triggerSos();
    }
  }

  // Активировать SOS
  Future<void> triggerSos() async {
    List<Contact> contacts = await SharedPreferencesManager.getContacts();
    LocationData location =
        await SharedPreferencesManager.getLastLocation() as LocationData;
    if (contacts.isNotEmpty) {
      TwilioService.sendMessage(
          contacts.first.phoneNumber, 'HELP: $location (testing an app)');
      CallService.callNumber(contacts.first.phoneNumber);
    }
    NotificationService.showCallResultNotification();
  }
}
