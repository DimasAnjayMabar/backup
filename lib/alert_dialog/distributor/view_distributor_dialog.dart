import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/screens/pages/distributor_page/distributor_provider.dart';

class DistributorDetailsDialog extends ConsumerWidget {
  final String distributorId;
  final String distributorName;
  final String distributorEmail;
  final String distributorPhone;
  final String ecommerceLink;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const DistributorDetailsDialog({
    super.key,
    required this.distributorId,
    required this.distributorName,
    required this.distributorEmail,
    required this.distributorPhone,
    required this.ecommerceLink,
    required this.onEditTap,
    required this.onDeleteTap
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider); // Assuming you have a loadingProvider

    return AlertDialog(
      title: Text(distributorName),
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email: $distributorEmail"),
                Text("Phone: $distributorPhone"),
                Text("Ecommerce: $ecommerceLink"),
              ],
            ),
      actions: isLoading
          ? []
          : [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: onEditTap,
                child: const Text("Edit"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: onDeleteTap,
                child: const Text("Delete"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
            ],
    );
  }
}