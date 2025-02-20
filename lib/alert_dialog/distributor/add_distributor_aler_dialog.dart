import 'package:flutter/material.dart';

class AddDistributor extends StatefulWidget {
  const AddDistributor({super.key});

  @override
  State<AddDistributor> createState() => _AddDistributorMenu();
}

class _AddDistributorMenu extends State<AddDistributor> {
  //inisialisasi
  final _formKey = GlobalKey<FormState>();

  String? namaDistributor;
  String? noTelpDistributor;
  String? emailDistributor;
  String? linkEcommerce;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  //fungsi untuk submit data produk baru
  // Future<void> _createDistributor() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();

  //     try {
  //       final db = await StorageService.getDatabaseIdentity();
  //       final password = await StorageService.getPassword();

  //       final response = await http.post(
  //         Uri.parse('http://${db['serverIp']}:3000/new-distributor'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: json.encode({
  //           'server_ip': db['serverIp'],
  //           'server_username': db['serverUsername'],
  //           'server_password': password,
  //           'server_database': db['serverDatabase'],
  //           'distributor_name': namaDistributor,
  //           'distributor_phone_number': noTelpDistributor,
  //           'distributor_email': emailDistributor,
  //           'distributor_ecommerce_link': linkEcommerce,
  //         }),
  //       );

  //       if (response.statusCode == 200) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Distributor added successfully!')),
  //         );
  //         Navigator.of(context)
  //             .pop(true); 
  //       } else {
  //         throw Exception('Failed to add distributor: ${response.body}');
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener( () {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose(){
    _focusNode.dispose();
    super.dispose();
  }

//css atau ui
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama distributor';
                  }
                  return null;
                },
                onSaved: (value) => namaDistributor = value,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Telepon', labelStyle: TextStyle(color: Colors.black)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama distributor';
                  }
                  return null;
                },
                onSaved: (value) => namaDistributor = value,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.black, fontWeight: _isFocused ? FontWeight.bold : FontWeight.normal)),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Masukkan email yang valid';
                    }
                  }
                  return null; // Tidak ada error jika kosong
                },
                onSaved: (value) => emailDistributor = value,
              ),
              const SizedBox(height: 20,),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Link Ecommerce', labelStyle: TextStyle(color: Colors.black)),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final urlRegex = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-]*)*\/?$');
                    if (!urlRegex.hasMatch(value)) {
                      return 'Masukkan link yang valid';
                    }
                  }
                  return null; // Tidak ada error jika kosong
                },
                onSaved: (value) => linkEcommerce = value,
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          
          child: const Text('Kembali'),
        ),
        ElevatedButton(
                  onPressed: () {
                    // VerifyDistributorCreate.showExitPopup(
                    //   context,
                    //   () {
                    //     // Panggil fungsi _EditPinForm
                    //     _createDistributor();
                    //   },
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Tambah'),
                ),
      ],
    );
  }
}