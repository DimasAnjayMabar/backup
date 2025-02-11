import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive_animation/screens/home/debt_page.dart';
import 'package:rive_animation/screens/home/distributor_page.dart';
import 'package:rive_animation/screens/home/history_page.dart';
import 'package:rive_animation/screens/home/settings_page.dart';
import 'package:rive_animation/screens/home/warehouse_page.dart';

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
    page: WarehousePage()
  ),
  Menu(
    title: "Distributor",
    icon: Icons.local_shipping, 
    page: DistributorPage()
  ),
  Menu(
    title: "Hutang",
    icon: Icons.money_off, 
    page: DebtPage()
  ),
  Menu(
    title: "Histori Transaksi",
    icon: Icons.history, 
    page: HistoryPage()
  ),
  Menu(
    title: "Pengaturan",
    icon: Icons.settings, 
    page: SettingsPage()
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
