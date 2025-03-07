import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/alert_dialog/distributor/add_distributor_alert_dialog.dart';
import 'package:rive_animation/alert_dialog/distributor/view_distributor_dialog.dart';
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/screens/pages/components/third_course_card.dart';
import 'package:rive_animation/screens/pages/distributor_page/distributor_provider.dart';

class DistributorPage extends ConsumerWidget {
  const DistributorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distributors = ref.watch(distributorProvider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddDistributor(
                onAdd: (Course course) {
                  ref.read(distributorProvider.notifier).addDistributorFunction(course);
                },
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Distributor",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (distributors.isEmpty)
                const Center(child: Text("No distributors found."))
              else
                Column(
                  children: distributors.map((distributor) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: GestureDetector(
                          onTap: () async {
                            final distributorDetails = await ref.read(distributorProvider.notifier).fetchDistributorById(distributor.id.toString());

                            if (distributorDetails != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DistributorDetailsDialog(
                                    distributorId: distributorDetails['distributorId'].toString(),
                                    distributorName: distributorDetails['distributorName'] ?? 'Unknown',
                                    distributorEmail: distributorDetails['distributorEmail'] ?? 'No email provided',
                                    distributorPhone: distributorDetails['distributorPhone'] ?? 'No phone provided',
                                    ecommerceLink: distributorDetails['distributorEcommerceLink'] ?? 'No link provided'
                                  );
                                },
                              );
                            } else {
                              debugPrint("❌ Failed to fetch distributor details");
                            }
                          },
                          child: ThirdCourseCard(
                            title: distributor.title,
                            description: distributor.description,
                            colorl: distributor.color,
                          ),
                        ),
                      )).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
