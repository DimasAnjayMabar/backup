import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'rive_model.dart';

class Menu {
  final String title;
  final IconData icon;

  Menu({required this.title, required this.icon});
}

List<Menu> sidebarMenus = [
  Menu(
    title: "Gudang",
    icon: Icons.warehouse
  ),
  Menu(
    title: "Distributor",
    icon: Icons.local_shipping
  ),
  Menu(
    title: "Hutang",
    icon: Icons.money_off
  ),
  Menu(
    title: "Histori Transaksi",
    icon: Icons.history
  ),
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
