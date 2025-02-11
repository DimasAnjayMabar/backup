import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _port = FlutterSecureStorage();
const String defaultPort = "http://localhost:3000";

class Port {
  static Future<void> savePort(String port) async {
    await _port.write(key: "serverPort", value: port);
  }

  static Future<String?> getPort() async {
    String? port = await _port.read(key: "serverPort");
    if (port == null) {
      return defaultPort;
    }
  }
}
