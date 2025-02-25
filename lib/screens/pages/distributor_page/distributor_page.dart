import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/alert_dialog/distributor/add_distributor_alert_dialog.dart';
import 'package:rive_animation/alert_dialog/distributor/view_distributor_dialog.dart';
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/screens/pages/components/third_course_card.dart';
import 'package:rive_animation/secure_storage/port.dart';
import 'package:rive_animation/secure_storage/token.dart';
import '../components/secondary_course_card.dart';

final distributorProvider = StateNotifierProvider<DistributorNotifier, List<Course>>((ref) => DistributorNotifier(ref));
final loadingProvider = StateProvider<bool>((ref) => false);

class DistributorNotifier extends StateNotifier<List<Course>> {
  final Ref ref;
  DistributorNotifier(this.ref) : super([]) {
    fetchDistributors();
  }

  Future<http.Response?> _getRequest(String endpoint, {String? token}) async {
    try {
      final api = await Port.getPort();
      final url = Uri.parse('$api/$endpoint');
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": token,
      };

      final response = await http.get(url, headers: headers);
      return response;
    } catch (e) {
      return null;
    }
  }

  void updateDistributors(List<Course> newDistributors) {
    state = newDistributors;
  }

  Future<void> fetchDistributors() async {
    final token = await Token.getToken();
    final response = await _getRequest('api/distributor/get-all-distributor', token: token);

    try {
      ref.read(loadingProvider.notifier).state = true;

      if (response != null && response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('data') && responseBody['data'] is List) {
          List<Course> updatedList = responseBody['data'].map<Course>((item) {
            return Course(
              id: item['distributorId'].toString(),
              title: item['distributorName'] ?? 'Unknown Distributor',
              description: item['distributorEmail'] ?? 'No email provided',
            );
          }).toList();

          state = updatedList;
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        throw Exception('Failed to load distributors');
      }
    } catch (e) {
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  Future<Map<String, dynamic>?> fetchDistributorById(String distributorId) async {
    final token = await Token.getToken();
    final response = await _getRequest('api/distributor/get-distributor-details/$distributorId', token: token);

    if (response != null && response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('data')) {
        print(responseBody);
        return responseBody['data']; // ✅ Return full distributor JSON
      }
    }
    return null; // Return null if request fails
  }

  void addDistributorFunction(Course course) {
    state = [...state, Course(
      id: course.id,
      title: course.title,
      description: course.description.isNotEmpty ? course.description : "No email provided",
    )];
  }
}

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
