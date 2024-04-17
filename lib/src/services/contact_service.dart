import 'package:uuid/uuid.dart';

class ContactService {

  String generateRandomId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
