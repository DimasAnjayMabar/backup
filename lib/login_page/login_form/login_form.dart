import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rive_animation/network.dart';
import 'package:rive_animation/screens/entryPoint/entry_point.dart';
import 'package:rive_animation/secure_storage/port.dart';
import 'package:rive_animation/secure_storage/token.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  String? errorMessage;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
    _checkToken();
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkToken() async {
    setState(() => isShowLoading = true);

    final token = await Token.getToken();
    if (token == null || token.isEmpty) {
      setState(() {
        // errorMessage = "Session timeout. Please login again.";
        isShowLoading = false;
      });
      return;
    }

    final response = await Network.getRequest('api/users/verify', token: token);

    if (response?.statusCode == 200) {
      _navigateToEntryPoint(delay: 2);
    } else {
      setState(() {
        errorMessage = "Invalid or expired session. Please login again.";
        isShowLoading = false;
      });
    }
  }

  Future<void> _login() async {
    setState(() {
      isShowLoading = true;
      errorMessage = null;
    });

    final response = await Network.postRequest(
      'api/users/login',
      body: {
        "username": _usernameController.text,
        "password": _passwordController.text,
      },
    );

    if (response == null) {
      setState(() {
        errorMessage = "Network error. Please try again.";
        isShowLoading = false;
      });
      print("DEBUG: Network error, response is null");
      return;
    }

    final responseData = jsonDecode(response.body);
    print("DEBUG: Response Data: $responseData");

    if (response.statusCode == 200) {
      String token = responseData['data']['token'];
      print("DEBUG: Token received: $token");

      await Token.saveToken(token);
      String? savedToken = await Token.getToken(); // Fetch the token to verify

      if (savedToken == token) {
        print("DEBUG: Token successfully saved!");
      } else {
        print("DEBUG: Token saving failed!");
      }

      _navigateToEntryPoint(delay: 2);
    } else {
      setState(() {
        errorMessage = responseData['errors'] ?? "Invalid username or password";
        isShowLoading = false;
      });
      print("DEBUG: Login failed with error: $errorMessage");
    }
  }

  void _navigateToEntryPoint({int delay = 0}) {
    Future.delayed(Duration(seconds: delay), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const EntryPoint(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ));
    });
  }

  void signIn() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Username", _usernameController, _usernameFocusNode, Icons.person),
              _buildTextField("Password", _passwordController, _passwordFocusNode, Icons.lock, isPassword: true),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (isShowLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: ElevatedButton(
                  onPressed: isShowLoading ? null : signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF77D8E),
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.arrow_right, color: Color(0xFFFE0037)),
                      SizedBox(width: 10),
                      Text("Login"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, FocusNode focusNode, IconData icon, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black54)),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: isPassword,
            validator: (value) => value!.isEmpty ? "This field cannot be empty" : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
