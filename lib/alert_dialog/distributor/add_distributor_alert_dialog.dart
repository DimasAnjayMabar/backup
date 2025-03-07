import 'package:flutter/material.dart';
import 'package:rive_animation/model/course.dart';
import 'package:rive_animation/network.dart';
import 'package:rive_animation/secure_storage/token.dart';

class AddDistributor extends StatefulWidget {
  final void Function(Course) onAdd;
  const AddDistributor({super.key, required this.onAdd});

  @override
  State<AddDistributor> createState() => _AddDistributorMenu();
}

class _AddDistributorMenu extends State<AddDistributor> {
  final _formKey = GlobalKey<FormState>();
  String? namaDistributor;
  String? noTelpDistributor;
  String? emailDistributor;
  String? linkEcommerce;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  Future<void> _createDistributor() async {
    final token = await Token.getToken();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final response = await Network.postRequest(
          'api/distributor/add-distributor',
          body: {
            'distributorName': namaDistributor,
            'distributorPhone': noTelpDistributor,
            'distributorEmail': emailDistributor,
            'distributorEcommerceLink': linkEcommerce,
            'distributorProfilePicture': ""
          },
          token : token
        );

        if (response != null && response.statusCode == 200) {
          widget.onAdd(Course(
            title: namaDistributor!,
            description: emailDistributor!,
            id: ''
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Distributor added successfully!')),
          );
          Navigator.of(context).pop(true);
        } else {
          throw Exception('Failed to add distributor');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
                decoration: const InputDecoration(labelText: 'Nama', labelStyle: TextStyle(color: Colors.black)),
                validator: (value) => value == null || value.isEmpty ? 'Masukkan nama distributor' : null,
                onSaved: (value) => namaDistributor = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Telepon', labelStyle: TextStyle(color: Colors.black)),
                validator: (value) => value == null || value.isEmpty ? 'Masukkan nomor telepon' : null,
                onSaved: (value) => noTelpDistributor = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.black, fontWeight: _isFocused ? FontWeight.bold : FontWeight.normal)),
                // validator: (value) {
                //   if (value != null && value.isNotEmpty) {
                //     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$');
                //     if (!emailRegex.hasMatch(value)) {
                //       return 'Masukkan email yang valid';
                //     }
                //   }
                //   return null;
                // },
                onSaved: (value) => emailDistributor = value,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Link Ecommerce', labelStyle: TextStyle(color: Colors.black)),
                // validator: (value) {
                //   if (value != null && value.isNotEmpty) {
                //     final urlRegex = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[^\s]*)?\$');
                //     if (!urlRegex.hasMatch(value)) {
                //       return 'Masukkan link yang valid';
                //     }
                //   }
                //   return null;
                // },
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
          onPressed: _createDistributor,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}