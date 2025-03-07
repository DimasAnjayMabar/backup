import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rive_animation/secure_storage/port.dart';

class Network {

  static Future<http.Response?> postRequest(String endpoint, {Map<String, dynamic>? body, String? token}) async {
    try {
      final api = await Port.getPort();
      final url = Uri.parse('$api/$endpoint');
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": token,
        "ngrok-skip-browser-warning" : "true"
      };
      final response = await http.post(url, headers: headers, body: body != null ? jsonEncode(body) : null);
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<http.Response?> getRequest(String endpoint, {String? token}) async {
    try {
      final api = await Port.getPort();
      final url = Uri.parse('$api/$endpoint');
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": token,
        "ngrok-skip-browser-warning" : "true"
      };

      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<http.Response?> patchRequest(String endpoint, {String? token})async{
    try{
      final api = await Port.getPort();
      final url = Uri.parse('$api/$endpoint');
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": token,
        "ngrok-skip-browser-warning" : "true"
      };

      final response = await http.patch(url, headers: headers);
      return response;
    }catch (e){
      return null;
    }
  }

  static Future<http.Response?> putRequest(String endpoint, {Map<String, dynamic>? body, String? token}) async {
    try {
      final api = await Port.getPort();
      final url = Uri.parse('$api/$endpoint');
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": token,
        "ngrok-skip-browser-warning" : "true"
      };
      final response = await http.put(url, headers: headers, body: body != null ? jsonEncode(body) : null);
      return response;
    } catch (e) {
      return null;
    }
  }
}

