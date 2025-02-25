import 'package:flutter/material.dart';

class DistributorDetailsDialog extends StatelessWidget {
  final String distributorId;
  final String distributorName;
  final String distributorEmail;
  final String distributorPhone;
  final String ecommerceLink;

  const DistributorDetailsDialog({
    Key? key,
    required this.distributorId,
    required this.distributorName,
    required this.distributorEmail,
    required this.distributorPhone, 
    required this.ecommerceLink
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(distributorName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email: $distributorEmail"),
          Text("Phone: $distributorPhone"),
          Text("Ecommerce: $ecommerceLink")
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white), 
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Edit"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white), 
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Delete"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white), 
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
      ],
    );
  }
}