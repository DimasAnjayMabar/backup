import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/network.dart';
import 'package:rive_animation/secure_storage/token.dart';

final distributorProvider = StateNotifierProvider<DistributorNotifier, List<Course>>((ref) => DistributorNotifier(ref));
final loadingProvider = StateProvider<bool>((ref) => false);

class DistributorNotifier extends StateNotifier<List<Course>> {
  final Ref ref;
  DistributorNotifier(this.ref) : super([]) {
    fetchDistributors();
  }

  void updateDistributors(List<Course> newDistributors) {
    state = newDistributors;
  }

  Future<void> fetchDistributors() async {
    final token = await Token.getToken();
    final response = await Network.getRequest('api/distributor/get-all-distributor', token: token);

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
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  Future<Map<String, dynamic>?> fetchDistributorById(String distributorId) async {
    final token = await Token.getToken();
    final response = await Network.getRequest('api/distributor/get-distributor-details/$distributorId', token: token);

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