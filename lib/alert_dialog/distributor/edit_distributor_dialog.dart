import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rive_animation/network.dart';
import 'package:rive_animation/secure_storage/token.dart';

class EditDistributorDialog extends StatefulWidget {
  final String id;
  final String initialName;
  final String initialPhone;
  final String initialEmail;
  final String ecommerceLink;
  // final void Function(String) onUpdated; // Callback to update UI

  const EditDistributorDialog({
    super.key, 
    required this.id,
    required this.initialName, 
    required this.initialPhone, 
    required this.initialEmail, 
    required this.ecommerceLink,
  });

  @override
  State<EditDistributorDialog> createState() => _EditDistributorDialogState();
}

class _EditDistributorDialogState extends State<EditDistributorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nameController;
  late TextEditingController _linkController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _nameController = TextEditingController(text: widget.initialName);
    _linkController = TextEditingController(text: widget.ecommerceLink);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _saveDistributorDetails() async {
    if (!_formKey.currentState!.validate()) return;
    
    final token = await Token.getToken();
    
    setState(() => _isLoading = true);
    
    final response = await Network.putRequest('api/distributor/edit-distributor/${widget.id.toString()}', 
    body: {
      'distributorEmail': _emailController.text,
      'distributorPhone': _phoneController.text,
      'distributorName' : _nameController.text, 
      'distributorEcommerceLink': _linkController.text
    }, 
    token: token);
    
    setState(() => _isLoading = false);
    
    if (response != null && response.statusCode == 200) {
      const SnackBar(content: Text('Berhasil menyimpan data distributor'));
      Navigator.of(context).pop(); // Close the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data distributor, coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Distributor',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama baru';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor baru';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email baru';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan link baru';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Kembali'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveDistributorDetails,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
