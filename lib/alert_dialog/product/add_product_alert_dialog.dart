import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive_animation/screens/pages/distributor_page/distributor_provider.dart';

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

class AddBarang extends ConsumerStatefulWidget {
  const AddBarang({super.key});

  @override
  ConsumerState<AddBarang> createState() => _AddBarangState();
}

class _AddBarangState extends ConsumerState<AddBarang> {
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
    addRow();
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

  @override
  Widget build(BuildContext context) {
    final distributors = ref.watch(distributorProvider);
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, // ✅ Background
                      borderRadius: BorderRadius.circular(8), // ✅ Rounded corners
                    ),
                    // padding: const EdgeInsets.all(8), // ✅ Inner padding
                    margin: const EdgeInsets.only(left: 5),
                    child: IconButton(
                      onPressed: () => selectDate(context),
                      icon: const Icon(Icons.calendar_today, color: Colors.blue),
                    ),
                  )
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
                      items: distributors.map((distributor) => DropdownMenuItem(
                        value: distributor.id.toString(),
                        child: Text(distributor.title),
                      )).toList(),
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
                    onPressed: () {
                      Navigator.pop(context);
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