import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/model/menu.dart';
import 'package:rive_animation/screens/entryPoint/components/info_card.dart';
import 'package:rive_animation/screens/entryPoint/components/side_menu.dart';
import 'package:rive_animation/screens/pages/profile_page/profile_provider.dart';

class SideBar extends ConsumerStatefulWidget {
  final Function(Menu) onMenuSelected;

  const SideBar({super.key, required this.onMenuSelected});

  @override
  ConsumerState<SideBar> createState() => _SideBarState();
}

class _SideBarState extends ConsumerState<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    final name = profile.isNotEmpty
        ? profile.firstWhere((c) => c.title == "Nama").description
        : "Loading...";
    final bio = profile.isNotEmpty
        ? profile.firstWhere((c) => c.title == "Nomor Telepon").description
        : "Fetching data...";

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
              const InfoCard(), // Now InfoCard updates dynamically via Riverpod!
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Menu Utama".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
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
                      color: selectedSideMenu == menu
                          ? Colors.blueAccent
                          : Colors.white,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Pengaturan".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
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
                      color: selectedSideMenu == menu
                          ? Colors.blueAccent
                          : Colors.white,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Profil".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
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
                      color: selectedSideMenu == menu
                          ? Colors.blueAccent
                          : Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
