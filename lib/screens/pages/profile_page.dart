import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rive_animation/alert_dialog/profile/logout_alert_dialog.dart';
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/secure_storage/port.dart';
import 'package:rive_animation/secure_storage/token.dart';
import 'components/secondary_course_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Course> profile = [];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final token = await Token.getToken();
    final response = await _getRequest('api/users/verify', token: token);

    if (response != null && response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['user'];

      setState(() {
        profile = [
          Course(
            title: "Nama",
            description: data['name'] ?? "N/A",
            color: _getConditionalColor(0),
          ),
          Course(
            title: "Nomor Telepon",
            description: data['phone'] ?? "N/A",
            color: _getConditionalColor(1),
          ),
          Course(
            title: "Email",
            description: data['email'] ?? "N/A",
            color: _getConditionalColor(2),
          ),
        ];
      });
    } else {
      debugPrint("Failed to fetch profile data");
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

      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return null;
    }
  }

  /// Function to assign colors based on index parity
  Color _getConditionalColor(int index) {
    return index % 2 == 0 ? const Color(0xFF7553F6) : const Color(0xFF80A4FF);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const LogoutAlertDialog();
            },
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Profil",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              if (profile.isEmpty)
                const Center(child: CircularProgressIndicator()) // Show loading
              else
                ...profile.asMap().entries.map((entry) {
                  int index = entry.key;
                  Course course = entry.value;
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: SecondaryCourseCard(
                      description: course.description,
                      title: course.title,
                      iconsSrc: course.iconSrc,
                      colorl: course.color,
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
