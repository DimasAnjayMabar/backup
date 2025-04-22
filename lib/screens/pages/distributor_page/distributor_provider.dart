import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/network.dart';
import 'package:rive_animation/secure_storage/token.dart';

final distributorProvider = StateNotifierProvider<DistributorNotifier, List<Course>>((ref) => DistributorNotifier(ref));
final loadingProvider = StateProvider<bool>((ref) => false);

class DistributorNotifier extends StateNotifier<List<Course>> {
  final Ref ref;
  DistributorNotifier(this.ref) : super([]) {
    fetchAllDistributors();
  }

  /* 
  ========================================================================================================================
  DISTRIBUTOR
  ========================================================================================================================
  */ 

  /// ✅ Add a new distributor using API and update the state
  Future<Course?> addDistributor({
    required String name,
    required String phone,
    required String email,
    required String link,
  }) async {
    final token = await Token.getToken();
    try {
      final response = await Network.postRequest(
        'api/distributor/add-distributor',
        body: {
          'distributorName': name,
          'distributorPhone': phone,
          'distributorEmail': email,
          'distributorEcommerceLink': link,
          'distributorProfilePicture': ""
        },
        token: token,
      );

      if (response != null && response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final newDistributor = responseBody['data'];

        final distributor = Course(
          id: newDistributor['distributorId'].toString(),
          title: newDistributor['distributorName'],
          description: newDistributor['distributorEmail'],
        );

        state = [...state, distributor];
        return distributor;
      } else {
        throw Exception('Failed to add distributor');
      }
    } catch (e) {
      print("❌ Error adding distributor: $e");
      return null;
    }
  }

  /// ✅ fetch all distributor using API 
  Future<void> fetchAllDistributors() async {
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

  /// ✅ fetch distributor details by id using API
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

  /// ✅ delete distributor by id using API
  Future<void> deleteDistributors(List<String> distributorIds) async {
    final token = await Token.getToken();
    for (var id in distributorIds) {
      try {
        final response = await Network.patchRequest(
          'api/distributor/delete-distributor/$id',
          token: token,
        );
        if (response != null && response.statusCode == 200) {
          state = state.where((dist) => dist.id != id).toList();
        }
      } catch (e) {
        debugPrint("Failed to delete distributor with id $id: $e");
      }
    }
  }


  Future <void> updateDistributors(String id, String name, String email, String phone, String link) async {
    final token = await Token.getToken();
    final response = await Network.putRequest('api/distributor/edit-distributor/$id', 
      body: {
        'distributorName' : name,
        'distributorEmail' : email, 
        'distributorPhone' : phone, 
        'distributorEcommerceLink' : link
      }, 
      token: token
    );

    if(response != null && response.statusCode == 200){
      state = state.map((course){
        return course.id == id ? Course(
          id: id,
          title : name, 
          description: email
        ) : course;
      }).toList();
    } else {
      throw Exception('failed to update distributor');
    }
  }

  
  /* 
  ========================================================================================================================
  WAREHOUSE API CALL
  ========================================================================================================================
  */ 

  //to do : create new product validation ->  service -> controller -> route

  //create

  //fetch all product

  //fetch product by id

  //edit product

  //delete product
}