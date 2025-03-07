import 'dart:convert';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/network.dart';
import 'package:rive_animation/secure_storage/port.dart';
import 'package:rive_animation/secure_storage/token.dart';

/// Profile State Provider (Fetch and Manage Profile Data)
final profileProvider = StateNotifierProvider<ProfileNotifier, List<Course>>(
  (ref) => ProfileNotifier(),
);

class ProfileNotifier extends StateNotifier<List<Course>> {
  ProfileNotifier() : super([]) {
    fetchProfile();
  }

  /// Fetch Profile from API
  Future<void> fetchProfile() async {
    final token = await Token.getToken();
    final url = Uri.parse('api/users/verify').toString();
    
    try {
      final response = await Network.getRequest(url, token: token);

      // final response = await http.get(url, headers: {
      //   "Content-Type": "application/json",
      //   "Authorization": token ?? "",
      // });

      if (response!.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['user'];

        state = [
          Course(title: "Nama", description: data['name'] ?? "N/A", color: _getConditionalColor(0), id: ''),
          Course(title: "Nomor Telepon", description: data['phone'] ?? "N/A", color: _getConditionalColor(1), id: ''),
          Course(title: "Email", description: data['email'] ?? "N/A", color: _getConditionalColor(2), id: ''),
        ];
      } else {
        print("Failed to fetch profile");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  /// Update Profile Locally (Optimistic UI)
  void updateProfile(String title, String newValue) {
    state = state.map((course) {
      if (course.title == title) {
        return Course(title: title, description: newValue, color: course.color, id: '');
      }
      return course;
    }).toList();
  }

  /// Helper: Assign Colors
  Color _getConditionalColor(int index) {
    return index % 2 == 0 ? const Color(0xFF7553F6) : const Color(0xFF80A4FF);
  }
}
