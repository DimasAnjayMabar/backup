import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _port = FlutterSecureStorage();
const String defaultPort = "https://notable-explicitly-mayfly.ngrok-free.app";
const String localPort = "http://localhost:3000";

class Port {
  static Future<void> savePort(String port) async {
    await _port.write(key: "serverPort", value: port);
  }

  static Future<String> getPort() async {
    String? port = await _port.read(key: "serverPort");
    return port ?? localPort;  // ✅ Correctly return a valid URL
  }
}
