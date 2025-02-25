import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rive_animation/secure_storage/port.dart';
import 'package:rive_animation/secure_storage/token.dart';

class EditPhoneDialog extends StatefulWidget {
  final String initialPhone;
  final void Function(String) onUpdated; // Callback to update UI

  const EditPhoneDialog({super.key, required this.initialPhone, required this.onUpdated});

  @override
  State<EditPhoneDialog> createState() => _EditPhoneDialogState();
}

class _EditPhoneDialogState extends State<EditPhoneDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _savePhone() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final response = await _postRequest('/api/users/edit-phone', body: {
      'phone': _phoneController.text,
    });
    
    setState(() => _isLoading = false);
    
    if (response != null && response.statusCode == 200) {
      widget.onUpdated(_phoneController.text); // Notify parent of update
      Navigator.of(context).pop(); // Close the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan nomor telepon, coba lagi.')),
      );
    }
  }

  Future<http.Response?> _postRequest(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final api = await Port.getPort();
      final token = await Token.getToken();
      
      if (token == null) throw Exception("Token is null");

      final url = Uri.parse('$api$endpoint');
      final headers = {
        "Content-Type": "application/json",
        "Authorization": token, // Ensure this is non-null
      };

      return await http.post(url, headers: headers, body: jsonEncode(body));
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Nomor Telepon',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor telepon baru';
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
          onPressed: _isLoading ? null : _savePhone,
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
