import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  static const _token = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _token.write(key: "token", value: token);
  }

  static Future<String?> getToken() async {
    try{
      String? token = await _token.read(key: "token");
      return token;
    }catch(e){
      print('Error retrieving token : $e');
      return null;
    }
  }

  static Future<void> deleteToken() async {
    try{
      await _token.delete(key: "token");
    }catch(e){
      print("error deleting token : $e");
    }
  }
}
