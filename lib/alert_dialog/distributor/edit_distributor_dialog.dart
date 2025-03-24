import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/screens/pages/distributor_page/distributor_provider.dart';

class EditDistributorDialog extends StatefulWidget {
  final String id;
  final String initialName;
  final String initialPhone;
  final String initialEmail;
  final String ecommerceLink;

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

  Future<void> _saveDistributorDetails(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    final hasChanges =
      _nameController.text != widget.initialName ||
      _emailController.text != widget.initialEmail ||
      _phoneController.text != widget.initialPhone ||
      _linkController.text != widget.ecommerceLink;

    if (!hasChanges) {
      // No changes were made
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada perubahan data yang disimpan.')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      return; // Exit the function without making an API call
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(distributorProvider.notifier).updateDistributors(
        widget.id,
        _nameController.text.isNotEmpty ? _nameController.text : widget.initialName,
        _emailController.text.isNotEmpty ? _emailController.text : widget.initialEmail,
        _phoneController.text.isNotEmpty ? _phoneController.text : widget.initialPhone,
        _linkController.text.isNotEmpty ? _linkController.text : widget.ecommerceLink,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menyimpan data distributor')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data distributor: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
        Consumer(
          builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      await _saveDistributorDetails(ref);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Simpan'),
            );
          },
        ),
      ],
    );
  }
}