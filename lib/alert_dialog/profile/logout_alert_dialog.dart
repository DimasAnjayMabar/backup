import 'package:flutter/material.dart';
import 'package:rive_animation/login_page/onboarding_page/onboarding_screen.dart';
import 'package:rive_animation/secure_storage/token.dart';

class LogoutAlertDialog extends StatefulWidget {
  const LogoutAlertDialog({super.key});

  @override
  State<LogoutAlertDialog> createState() => _LogoutState();
}

class _LogoutState extends State<LogoutAlertDialog> {
  Future<void> _logout(BuildContext context) async {
    await Token.deleteToken(); // Delete the token from secure storage
    if (!mounted) return;
    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Konfirmasi Logout"),
      content: const Text("Apakah Anda yakin ingin logout?"),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _logout(context),
          child: const Text("Logout"),
        ),
      ],
    );
  }
}
