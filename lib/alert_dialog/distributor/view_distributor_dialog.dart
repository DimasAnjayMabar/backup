import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/alert_dialog/distributor/delete_distributor_dialog.dart';
import 'package:rive_animation/alert_dialog/distributor/edit_distributor_dialog.dart';
import 'package:rive_animation/screens/pages/distributor_page/distributor_provider.dart';

class DistributorDetailsDialog extends ConsumerWidget {
  final String distributorId;
  final String distributorName;
  final String distributorEmail;
  final String distributorPhone;
  final String ecommerceLink;

  const DistributorDetailsDialog({
    super.key,
    required this.distributorId,
    required this.distributorName,
    required this.distributorEmail,
    required this.distributorPhone,
    required this.ecommerceLink,
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
                onPressed: () async {
                  ref.read(loadingProvider.notifier).state = true;
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditDistributorDialog(
                        id: distributorId,
                        initialName: distributorName,
                        initialPhone: distributorPhone,
                        initialEmail: distributorEmail,
                        ecommerceLink: ecommerceLink,
                      );
                    },
                  );
                  ref.read(loadingProvider.notifier).state = false;
                },
                child: const Text("Edit"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  ref.read(loadingProvider.notifier).state = true;
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteDistributorDialog(
                        distributorIds: [distributorId],
                      );
                    },
                  );
                  ref.read(loadingProvider.notifier).state = false;
                },
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