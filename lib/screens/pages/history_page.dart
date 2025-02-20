import 'package:flutter/material.dart';
import 'package:rive_animation/model/course.dart';
import 'components/secondary_course_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Padding(
              //   padding: const EdgeInsets.all(20),
              //   child: Text(
              //     "Courses",
              //     style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              //         color: Colors.black, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: courses
              //         .map(
              //           (course) => Padding(
              //             padding: const EdgeInsets.only(left: 20),
              //             child: CourseCard(
              //               title: course.title,
              //               iconSrc: course.iconSrc,
              //               color: course.color,
              //             ),
              //           ),
              //         )
              //         .toList(),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Histori Transaksi",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ...recentCourses.map((course) => Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: SecondaryCourseCard(
                      description: "",
                      title: course.title,
                      iconsSrc: course.iconSrc,
                      colorl: course.color,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
