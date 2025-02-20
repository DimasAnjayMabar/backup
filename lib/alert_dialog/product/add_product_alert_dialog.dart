import 'package:flutter/material.dart';

// Helper untuk responsivitas
class ResponsiveHelper {
  static double getFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Mengubah ukuran font berdasarkan lebar layar
    if (screenWidth <= 992) {
      return 14.0; // Font lebih kecil untuk layar kecil
    } else {
      return 18.0; // Font lebih besar untuk layar besar
    }
  }

  static EdgeInsets getPadding(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Mengubah padding berdasarkan lebar layar
    if (screenWidth <= 992) {
      return const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 10.0); // Padding kecil
    } else {
      return const EdgeInsets.symmetric(
          horizontal: 32.0, vertical: 20.0); // Padding lebih besar
    }
  }
}

class TableRowData {
  String name;
  double buyPrice; // Change to double
  double percentProfit; // Change to double
  int stock; // Change to int
  String category;
  TextEditingController subtotalController;
  TextEditingController percentProfitController;

  TableRowData({
    required this.name,
    required this.buyPrice,
    required this.percentProfit,
    required this.stock,
    required this.category,
    required this.subtotalController,
    required this.percentProfitController,
  });
}

class AddBarang extends StatefulWidget {
  const AddBarang({super.key});

  @override
  State<AddBarang> createState() => _AddBarangState();
}

class _AddBarangState extends State<AddBarang> {
  List<String> distributorList = [];
  List<String> categoryList = [];
  String selectedDistributor = '';
  DateTime selectedDate = DateTime.now();
  double fontSize = 16.0;
  List<TableRowData> rowDataList = [];
  double? totalPaid = 0.0;

  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  final TextEditingController _moneyFormatter = TextEditingController();
  final String _rawMoneyValue = "0";
  final TextEditingController _percentFormatter = TextEditingController();
  final String _rawPercentValue = "0";
  String percentProfitConverterInit = "0%";
  final TextEditingController totalPaidController =
      TextEditingController(text: '0');

  @override
  void dispose() {
    totalPaidController.dispose();
    verticalScrollController.dispose();
    horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // fetchDistributorDropdown();
    // fetchCategoryDropdown();
    addRow(); // Tambahkan row default saat pertama kali
  }

  String _formatCurrency(String rawValue) {
    if (rawValue.isEmpty) return "Rp 0";

    // Konversi string ke angka dan buat format manual
    int value = int.parse(rawValue);
    String result = value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => "${match.group(1)}.",
        );
    return "Rp $result";
  }

  String _percentProfitConverter(String rawValue) {
    if (rawValue.isEmpty) return "Rp. 0";

    int value = int.parse(rawValue);
    return "$value%";
  }

  // Future<void> fetchDistributorDropdown() async {
  //   try {
  //     // Ambil data konfigurasi database dan password
  //     final db = await StorageService.getDatabaseIdentity();
  //     final password = await StorageService.getPassword();

  //     // Kirim request POST ke endpoint /distributors
  //     final response = await http.post(
  //       Uri.parse('http://${db['serverIp']}:3000/distributors'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({
  //         'server_ip': db['serverIp'],
  //         'server_username': db['serverUsername'],
  //         'server_password': password,
  //         'server_database': db['serverDatabase'],
  //       }),
  //     );

  //     // Periksa status respons
  //     if (response.statusCode == 200) {
  //       final body = json.decode(response.body); // Decode JSON respons

  //       // Ambil daftar distributor dari JSON
  //       final distributors = body['distributors'] ?? [];
  //       setState(() {
  //         distributorList = List<String>.from(
  //           distributors.map((distributor) => distributor['distributor_name']),
  //         );
  //       });
  //     } else {
  //       throw Exception('Failed to load distributors: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Tangkap dan tampilkan error
  //     print('Error fetching distributors: $e');
  //   }
  // }

  // Future<void> fetchCategoryDropdown() async {
  //   try {
  //     final db = await StorageService.getDatabaseIdentity();
  //     final password = await StorageService.getPassword();

  //     final response = await http.post(
  //       Uri.parse('http://${db['serverIp']}:3000/categories'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({
  //         'server_ip': db['serverIp'],
  //         'server_username': db['serverUsername'],
  //         'server_password': password,
  //         'server_database': db['serverDatabase'],
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final body = json.decode(response.body);
  //       final categories = body['categories'] ?? [];
  //       setState(() {
  //         categoryList = List<String>.from(
  //           categories.map((category) => category['category_name']),
  //         );
  //       });
  //     } else {
  //       throw Exception('Failed to load categories: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching categories: $e');
  //   }
  // }

  void addRow() {
    setState(() {
      rowDataList.add(TableRowData(
        name: '', // Default name
        buyPrice: 0.0, // Default buy price
        percentProfit: 0.0, // Default percent profit
        stock: 0, // Default stock
        category: '', // Default category
        subtotalController: TextEditingController(), // Initialize controller
        percentProfitController:
            TextEditingController(), // Initialize controller
      ));
    });
  }

  void removeRow(int index) {
    setState(() {
      rowDataList.removeAt(index);
    });
  }

  void selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String getFormattedTotalPaid() {
    final rawValue = totalPaidController.text.isNotEmpty
        ? totalPaidController.text.replaceAll(RegExp(r'[^0-9]'), '')
        : '0';
    return rawValue.isEmpty ? '0' : rawValue;
  }

  // Future<void> addProduct() async {
  //   try {
  //     final db = await StorageService.getDatabaseIdentity();
  //     final password = await StorageService.getPassword();
  //     List<TempAddBarang> productsList = await TempAddBarang.getProducts();
  //     final transaction = await TempAddTransaction.getTransaction();

  //     // Data transaksi yang tidak berubah (tidak perlu loop)
  //     final transactionPayload = {
  //       'server_ip': db['serverIp'],
  //       'server_username': db['serverUsername'],
  //       'server_password': password,
  //       'server_database': db['serverDatabase'],
  //       'transaction_date': transaction?.selectedDate ?? '',
  //       'distributor_name': transaction?.selectedDistributor ?? '',
  //       'total_paid': transaction?.totalPaid ?? 0.0,
  //     };

  //     for (TempAddBarang product in productsList) {
  //       // Payload khusus untuk setiap produk
  //       final productPayload = {
  //         'product_name': product.productName,  // Mengakses atribut produk
  //         'subtotal': product.buyPrice,
  //         'product_stock': product.stock,
  //         'percent_profit': product.percentProfit,
  //         'category_name': product.category,
  //       };

  //       // Gabungkan payload transaksi dan produk
  //       final combinedPayload = {
  //         ...transactionPayload,  // Menambahkan data transaksi
  //         ...productPayload,      // Menambahkan data produk
  //       };

  //       // Lakukan request ke API
  //       final response = await http.post(
  //         Uri.parse('http://${db['serverIp']}:3000/new-product'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: json.encode(combinedPayload), // Gabungkan dan kirim payload
  //       );

  //       // Tangani response
  //       if (response.statusCode == 200) {
  //         print('Product added successfully!');
  //       } else {
  //         print('Failed to add product: ${response.body}');
  //       }
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "PRODUK BARU",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "TANGGAL: ${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => selectDate(context),
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "DISTRIBUTOR: ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedDistributor.isEmpty
                          ? null
                          : selectedDistributor,
                      hint: Text(
                        "Pilih Distributor",
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                      dropdownColor: Colors.white,
                      items: distributorList.map((distributor) {
                        return DropdownMenuItem<String>(
                          value: distributor,
                          child: Text(distributor,
                              style: TextStyle(
                                  fontSize: fontSize, color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDistributor = value ?? '';
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Scrollbar(
                  controller: horizontalScrollController,
                  thumbVisibility: true, // Agar scrollbar terlihat
                  child: SingleChildScrollView(
                    controller: horizontalScrollController,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Scrollbar(
                      controller: verticalScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: verticalScrollController,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Table(
                          border: TableBorder.all(color: Colors.black),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: IntrinsicColumnWidth(),
                            2: IntrinsicColumnWidth(),
                            3: IntrinsicColumnWidth(),
                            4: IntrinsicColumnWidth(),
                            5: IntrinsicColumnWidth(),
                          },
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          8.0), // Menambahkan margin horizontal
                                  child: Text(
                                    "Nama Produk",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Subtotal",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Profit Dalam Persen",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Stok",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Kategori",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Hapus",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            ...rowDataList.asMap().entries.map((entry) {
                              int index = entry.key;
                              TableRowData data = entry.value;

                              return TableRow(
                                children: [
                                  TextField(
                                    onChanged: (value) => setState(() {
                                      data.name = value;
                                    }),
                                  ),
                                  TextField(
                                    controller: data.subtotalController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      // Remove all non-digit characters from input
                                      final rawValue = value.replaceAll(
                                          RegExp(r'[^0-9.]'),
                                          ''); // Allow decimal point
                                      if (rawValue.isEmpty) {
                                        setState(() {
                                          data.buyPrice =
                                              0.0; // Set to 0.0 as double
                                          data.subtotalController.text = "";
                                        });
                                        return;
                                      }

                                      setState(() {
                                        data.buyPrice =
                                            double.tryParse(rawValue) ??
                                                0.0; // Parse to double
                                        final formattedValue = _formatCurrency(
                                            rawValue); // Format value
                                        data.subtotalController.value =
                                            TextEditingValue(
                                          text: formattedValue,
                                          selection: TextSelection.collapsed(
                                              offset: formattedValue.length),
                                        );
                                      });
                                    },
                                  ),
                                  TextField(
                                    controller: data.percentProfitController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      final rawValue = value.replaceAll(
                                          RegExp(r'[^0-9]'), '');
                                      if (rawValue.isEmpty) {
                                        setState(() {
                                          data.percentProfit =
                                              0.0; // Set to 0.0 as double
                                          data.percentProfitController.text =
                                              "0%";
                                        });
                                        return;
                                      }

                                      setState(() {
                                        data.percentProfit =
                                            double.tryParse(rawValue) ??
                                                0.0; // Parse to double
                                        final formattedValue =
                                            _percentProfitConverter(
                                                rawValue); // Format value
                                        data.percentProfitController.value =
                                            TextEditingValue(
                                          text: formattedValue,
                                          selection: TextSelection.collapsed(
                                              offset: formattedValue.length),
                                        );
                                      });
                                    },
                                  ),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) => setState(() {
                                      data.stock = int.tryParse(value) ??
                                          0; // Parse to int
                                    }),
                                  ),
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    value: data.category.isEmpty
                                        ? null
                                        : data.category,
                                    hint: const Text("Pilih Kategori"),
                                    items: categoryList.map((category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(() {
                                      data.category = value ?? '';
                                    }),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle,
                                        color: Colors.red),
                                    onPressed: () => setState(() {
                                      removeRow(index);
                                    }),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: addRow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Warna tombol
                      shape:
                          const CircleBorder(), // Membuat tombol berbentuk lingkaran
                    ),
                    child: const Icon(Icons.add,
                        color: Colors.white), // Ikon dan warnanya
                  ),
                ],
              ),
              const SizedBox(
                  height: 10), // Add some space between buttons and grand total
              Row(
                children: [
                  Text(
                    "GRAND TOTAL: Rp. 0",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: totalPaidController,
                onChanged: (value) {
                  setState(() {
                    totalPaid = double.tryParse(value);
                  });
                },
                decoration: const InputDecoration(labelText: 'Uang Yang Dibayarkan'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Kembali menutup alert dialog
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: const Text("Kembali"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // VerifyProductCreate.showExitPopup(context, () async {
                      //   try {
                      //     // Simpan semua data produk ke secure storage
                      //     List<TempAddBarang> products = [];

                      //     for (TableRowData row in rowDataList) {
                      //       TempAddBarang temp = TempAddBarang(
                      //         productName: row.name,
                      //         buyPrice: row.buyPrice,
                      //         stock: row.stock,
                      //         percentProfit: row.percentProfit,
                      //         category: row.category,
                      //       );

                      //       // Tambahkan setiap produk ke dalam list
                      //       products.add(temp);
                      //     }

                      //     // Simpan semua produk yang ada dalam list ke secure storage
                      //     await TempAddBarang.saveProducts(products);

                      //     // Simpan data transaksi ke secure storage
                      //     TempAddTransaction transaction = TempAddTransaction(
                      //       selectedDistributor: selectedDistributor,
                      //       selectedDate: selectedDate.toIso8601String(),
                      //       totalPaid: totalPaid ?? 0.0,
                      //     );

                      //     await TempAddTransaction.saveTransaction(transaction);

                      //     // Panggil addProduct untuk menyimpan data ke server
                      //     await addProduct();

                      //     // Tampilkan pesan berhasil
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(content: Text("Data berhasil disimpan ke server!")),
                      //     );
                      //     // Jika ada error, cetak data dari secure storage ke konsol
                      //     final tempAddBarang = await TempAddBarang.getProducts();
                      //     final tempAddTransaction = await TempAddTransaction.getTransaction();

                      //     print("TempAddBarang: $tempAddBarang");
                      //     print("TempAddTransaction: $tempAddTransaction");
                      //   } catch (e) {
                      //     // Jika ada error, cetak data dari secure storage ke konsol
                      //     final tempAddBarang = await TempAddBarang.getProducts();
                      //     final tempAddTransaction = await TempAddTransaction.getTransaction();

                      //     print("Error: $e");
                      //     print("TempAddBarang: $tempAddBarang");
                      //     print("TempAddTransaction: $tempAddTransaction");

                      //     // Tampilkan pesan error
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text("Error: $e")),
                      //     );
                      //   }
                      // });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Simpan"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}