import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.bio,
  });

  final String name, bio;

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
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
    return GestureDetector(
      onTap: toggleSelection,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white30, // Border color
            width: 1.0, // Border thickness
          ),
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        margin: const EdgeInsets.all(8.0), // Space around the card
        child: Stack(
          children: [
            Positioned.fill( // Ensures background fills the container
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
              padding: const EdgeInsets.all(8.0), // Padding inside the border
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  widget.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  widget.bio,
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
