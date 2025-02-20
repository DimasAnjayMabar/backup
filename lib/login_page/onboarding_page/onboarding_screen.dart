import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;
import 'package:rive_animation/screens/entryPoint/entry_point.dart';
import 'package:rive_animation/secure_storage/token.dart';
import 'package:rive_animation/secure_storage/port.dart';
import 'package:http/http.dart' as http;

import 'onboarding_button.dart';
import '../login_form/login_dialog.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnboardingScreen> {
  late RiveAnimationController _btnAnimationController;
  bool isShowSignInDialog = false;
  bool _isCheckingToken = true;

  @override
  void initState() {
    super.initState();
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await Token.getToken();
    if (token == null || token.isEmpty) {
      setState(() => _isCheckingToken = false);
      return;
    }

    final response = await _getRequest('api/users/verify', token: token);

    if (response?.statusCode == 200) {
      _navigateToEntryPoint();
    } else {
      setState(() => _isCheckingToken = false);
    }
  }

  Future<http.Response?> _getRequest(String endpoint, {String? token}) async {
    try {
      final api = await Port.getPort();
      final url = Uri.parse('$api/$endpoint');
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": token,
      };

      return await http.get(url, headers: headers);
    } catch (e) {
      return null;
    }
  }

  void _navigateToEntryPoint() {
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const EntryPoint()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isCheckingToken
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            body: Stack(
              children: [
                Positioned(
                  width: MediaQuery.of(context).size.width * 1.7,
                  left: 100,
                  bottom: 100,
                  child: Image.asset("assets/Backgrounds/Spline.png"),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: const SizedBox(),
                  ),
                ),
                const RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: const SizedBox(),
                  ),
                ),
                AnimatedPositioned(
                  top: isShowSignInDialog ? -50 : 0,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  duration: const Duration(milliseconds: 260),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          const SizedBox(
                            width: 300,
                            child: Column(
                              children: [
                                Text(
                                  "Selamat Datang di Aplikasi Administrasi Gudang",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Poppins",
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Di sini anda bisa mengatur sebarang hal yang berkaitang dengan pergudangan dan inventaris",
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 2),
                          OnboardingButton(
                            btnAnimationController: _btnAnimationController,
                            press: () {
                              _btnAnimationController.isActive = true;
                              Future.delayed(
                                const Duration(milliseconds: 800),
                                () {
                                  setState(() => isShowSignInDialog = true);
                                  if (!context.mounted) return;
                                  showLoginDialog(context, onValue: (_) {});
                                },
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
