import 'package:flutter/material.dart';
import 'package:rive_animation/alert_dialog/distributor/delete_distributor_dialog.dart';
import 'package:rive_animation/alert_dialog/distributor/edit_distributor_dialog.dart';

class DistributorDetailsDialog extends StatelessWidget {
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
    required this.ecommerceLink
  });

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
          onPressed: () {
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return EditDistributorDialog(
                  id: distributorId, 
                  initialName: distributorName, 
                  initialPhone: distributorPhone, 
                  initialEmail: distributorEmail, 
                  ecommerceLink: ecommerceLink);
              }
            );
          },
          child: const Text("Edit"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white), 
          onPressed: () {
            showDialog(
              context: context, 
              builder: (BuildContext context){
                return DeleteDistributorDialog(
                  distributorId: distributorId,
                );
              }
            );
          },
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