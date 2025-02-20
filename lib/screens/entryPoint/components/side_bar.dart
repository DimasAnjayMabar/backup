import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rive_animation/secure_storage/port.dart';
import 'package:rive_animation/secure_storage/token.dart';
import 'dart:convert';
import '../../../model/menu.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  final Function(Menu) onMenuSelected;

  const SideBar({super.key, required this.onMenuSelected});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;
  String name = "Loading...";
  String bio = "Fetching data...";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      final token = await Token.getToken();
      
      if (token == null) {
        print("DEBUG: Missing Token in secure storage");
        throw Exception("Missing Token in secure storage");
      }
      
      print("DEBUG: Retrieved Token: $token");

      final response = await _getRequest('api/users/verify', token: token);

      if (response == null) {
        print("DEBUG: API response is null");
        throw Exception("No response from server");
      }

      print("DEBUG: API Response Status Code: ${response.statusCode}");
      print("DEBUG: API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("DEBUG: Parsed Response Data: $data");

        setState(() {
          name = data['user']['username'] ?? "Unknown";
          bio = data['user']['name'] ?? "Unknown";
        });

        print("DEBUG: User Info Updated -> Name: $name, Bio: $bio");
      } else {
        print("DEBUG: Failed to load user info, Status Code: ${response.statusCode}");
        throw Exception("Failed to load user info");
      }
    } catch (e) {
      print("DEBUG: Error fetching user info: $e");
      
      setState(() {
        name = "Error";
        bio = "Could not fetch data";
      });
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
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(name: name, bio: bio),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Menu Utama".toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      widget.onMenuSelected(menu);
                    },
                    icon: Icon(
                      menu.icon,
                      color: selectedSideMenu == menu ? Colors.blueAccent : Colors.white,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Pengaturan".toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus2.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      widget.onMenuSelected(menu);
                    },
                    icon: Icon(
                      menu.icon,
                      color: selectedSideMenu == menu ? Colors.blueAccent : Colors.white,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Profil".toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus3.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      widget.onMenuSelected(menu);
                    },
                    icon: Icon(
                      menu.icon,
                      color: selectedSideMenu == menu ? Colors.blueAccent : Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
