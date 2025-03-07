import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rive_animation/network.dart';
import 'package:rive_animation/secure_storage/token.dart';

class DeleteDistributorDialog extends StatefulWidget {
  final String distributorId;
  const DeleteDistributorDialog({
    super.key, 
    required this.distributorId
  });

  @override
  State<DeleteDistributorDialog> createState() => _DeleteDistributorDialogState();
}

class _DeleteDistributorDialogState extends State<DeleteDistributorDialog> {
  final bool _isLoading = false; // Untuk indikator loading

  Future<void> _deleteDistributor() async {
    final token = await Token.getToken();

    if (token != null) {
      try {
        final response = await Network.patchRequest('api/distributor/delete-distributor/${widget.distributorId}', token: token);

        if (response != null) {
          final responseData = jsonDecode(response.body);
          debugPrint("Delete Distributor Response: ${response.body}");

          if (response.statusCode == 200) {
            const SnackBar(content: Text('Distributor deleted successfully!'));
            Navigator.of(context).pop();
          } else {
            debugPrint("Delete Distributor failed: ${responseData['message']}");
          }
        } else {
          debugPrint("Delete request failed: No response from server");
        }
      } catch (e) {
        debugPrint("Delete request error: $e");
      }
    } else {
      debugPrint("Error: No authentication token found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Konfirmasi Penghapusan"),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Text("Apakah Anda yakin ingin menghapus distributor?"),
      actions: _isLoading
          ? []
          : [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _deleteDistributor(),
                child: const Text("Hapus"),
              ),
            ],
    );
  }
}
