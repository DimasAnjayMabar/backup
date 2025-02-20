import 'package:flutter/material.dart';

class SecondaryCourseCard extends StatefulWidget {
  const SecondaryCourseCard({
    super.key,
    required this.title,
    this.iconsSrc = "assets/icons/ios.svg",
    this.colorl = const Color(0xFF7553F6), required this.description,
  });

  final String title, iconsSrc, description;
  final Color colorl;

  @override
  State<SecondaryCourseCard> createState() => _SecondaryCourseCardState();
}

class _SecondaryCourseCardState extends State<SecondaryCourseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
          color: widget.colorl,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.description, 
                  style: const TextStyle(
                    color: Colors.white60, 
                    fontSize: 16
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 40,
          //   child: VerticalDivider(
          //     color: Colors.white70,
          //   ),
          // ),
          // const SizedBox(width: 8),
          // SvgPicture.asset(widget.iconsSrc)
        ],
      ),
    );
  }
}
