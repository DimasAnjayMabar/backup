import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/screens/pages/profile_page/profile_provider.dart';

class InfoCard extends ConsumerStatefulWidget {
  const InfoCard({super.key});

  @override
  ConsumerState<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends ConsumerState<InfoCard> {
  bool selected = false;

  void toggleSelection() {
    setState(() {
      selected = true;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        selected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    final name = profile.isNotEmpty
        ? profile.firstWhere((c) => c.title == "Nama").description
        : "Loading...";
    final phone = profile.isNotEmpty
        ? profile.firstWhere((c) => c.title == "Nomor Telepon").description
        : "Fetching data...";

    return GestureDetector(
      onTap: toggleSelection,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white30,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF6792FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  phone,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
