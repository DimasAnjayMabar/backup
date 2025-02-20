import 'package:flutter/material.dart';
import 'package:rive_animation/alert_dialog/distributor/add_distributor_aler_dialog.dart';
import 'package:rive_animation/model/course.dart';
import 'components/secondary_course_card.dart';

class DistributorPage extends StatelessWidget {
  const DistributorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddDistributor(); // This will show as a dialog instead of a new page
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white)
      ),
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
                  "Distributor",
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
