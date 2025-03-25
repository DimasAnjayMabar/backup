import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/screens/pages/distributor_page/distributor_provider.dart';

class AddDistributor extends ConsumerStatefulWidget {
  const AddDistributor({super.key});

  @override
  ConsumerState<AddDistributor> createState() => _AddDistributorMenu();
}

class _AddDistributorMenu extends ConsumerState<AddDistributor> {
  final _formKey = GlobalKey<FormState>();
  String? namaDistributor;
  String? noTelpDistributor;
  String? emailDistributor;
  String? linkEcommerce;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  /// 🔥 Function to handle adding distributor via Notifier
  Future<void> _addDistributor() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final success = await ref.read(distributorProvider.notifier).addDistributor(
        name: namaDistributor!,
        phone: noTelpDistributor!,
        email: emailDistributor ?? '',
        link: linkEcommerce ?? '',
      );

      if (success != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Distributor added successfully!')),
        );
        Navigator.of(context).pop(success);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add distributor')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Tambah Distributor Baru',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) => value == null || value.isEmpty ? 'Masukkan nama distributor' : null,
                onSaved: (value) => namaDistributor = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                validator: (value) => value == null || value.isEmpty ? 'Masukkan nomor telepon' : null,
                onSaved: (value) => noTelpDistributor = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: _isFocused ? FontWeight.bold : FontWeight.normal)),
                onSaved: (value) => emailDistributor = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Link Ecommerce'),
                onSaved: (value) => linkEcommerce = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: const Text('Kembali'),
        ),
        ElevatedButton(
          onPressed: _addDistributor, // ✅ Call your own function that handles Riverpod logic
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
