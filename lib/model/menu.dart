import 'package:flutter/material.dart';
import 'package:rive_animation/screens/pages/debt_page.dart';
import 'package:rive_animation/screens/pages/distributor_page.dart';
import 'package:rive_animation/screens/pages/history_page.dart';
import 'package:rive_animation/screens/pages/profile_page.dart';
import 'package:rive_animation/screens/pages/settings_page.dart';
import 'package:rive_animation/screens/pages/warehouse_page.dart';

class Menu {
  final String title;
  final IconData icon;
  final Widget page;

  Menu({required this.title, required this.icon, required this.page});
}

List<Menu> sidebarMenus = [
  Menu(
    title: "Gudang",
    icon: Icons.warehouse,
    page: const WarehousePage()
  ),
  Menu(
    title: "Distributor",
    icon: Icons.local_shipping, 
    page: const DistributorPage()
  ),
  Menu(
    title: "Hutang",
    icon: Icons.money_off, 
    page: const DebtPage()
  ),
  Menu(
    title: "Histori Transaksi",
    icon: Icons.history, 
    page: const HistoryPage()
  ),
];

List<Menu> sidebarMenus2= [
  Menu(
    title: "Pengaturan",
    icon: Icons.settings, 
    page: const SettingsPage()
  ),
];

List<Menu> sidebarMenus3 = [
  Menu(
    title: "Profil", 
    icon: Icons.person, 
    page: const ProfilePage()
  )
];
// List<Menu> sidebarMenus2 = [
//   Menu(
//     title: "History",
//     icon: Icons.history
//   ),
//   Menu(
//     title: "Notifications",
//     icon: Icons.notifications
//   ),
// ];

// List<Menu> bottomNavItems = [
//   Menu(
//     title: "Chat",
//     rive: RiveModel(
//         src: "assets/RiveAssets/icons.riv",
//         artboard: "CHAT",
//         stateMachineName: "CHAT_Interactivity"),
//   ),
//   Menu(
//     title: "Search",
//     rive: RiveModel(
//         src: "assets/RiveAssets/icons.riv",
//         artboard: "SEARCH",
//         stateMachineName: "SEARCH_Interactivity"),
//   ),
//   Menu(
//     title: "Timer",
//     rive: RiveModel(
//         src: "assets/RiveAssets/icons.riv",
//         artboard: "TIMER",
//         stateMachineName: "TIMER_Interactivity"),
//   ),
//   Menu(
//     title: "Notification",
//     rive: RiveModel(
//         src: "assets/RiveAssets/icons.riv",
//         artboard: "BELL",
//         stateMachineName: "BELL_Interactivity"),
//   ),
//   Menu(
//     title: "Profile",
//     rive: RiveModel(
//         src: "assets/RiveAssets/icons.riv",
//         artboard: "USER",
//         stateMachineName: "USER_Interactivity"),
//   ),
// ];
