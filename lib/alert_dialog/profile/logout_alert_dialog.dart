import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rive_animation/login_page/onboarding_page/onboarding_screen.dart';
import 'package:rive_animation/network.dart';
import 'package:rive_animation/secure_storage/token.dart';

class LogoutAlertDialog extends StatefulWidget {
  const LogoutAlertDialog({super.key});

  @override
  State<LogoutAlertDialog> createState() => _LogoutState();
}

class _LogoutState extends State<LogoutAlertDialog> {
  final bool _isLoading = false; // Untuk indikator loading

  Future<void> _logout() async {
    final token = await Token.getToken();

    if (token != null) {
      final response = await Network.postRequest('api/users/logout', body: null, token: token);

      if (response != null) {
        final responseData = jsonDecode(response.body);
        debugPrint("Logout Response: ${response.body}");

        if (response.statusCode == 200) {
          await Token.deleteToken();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              (Route<dynamic> route) => false,
            );
          }
        } else {
          debugPrint("Logout gagal: ${responseData['data']}");
        }
      } else {
        debugPrint("Logout request gagal: Tidak ada respons dari server");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Konfirmasi Logout"),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Text("Apakah Anda yakin ingin logout?"),
      actions: _isLoading
          ? []
          : [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _logout(),
                child: const Text("Logout"),
              ),
            ],
    );
  }
}
