import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/provider/item_list_provider.dart';
import 'package:flutter_application_1/provider/model/model_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  late DateTime selectedDate;

  String formatCurrency(double amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        tanggalController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: kodeController,
              decoration: InputDecoration(labelText: 'Kode'),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: hargaController,
              decoration: InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: tanggalController,
              decoration: InputDecoration(labelText: 'Tanggal'),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                var newItem = Item(
                  nama: namaController.text,
                  kode: kodeController.text,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  harga: double.tryParse(hargaController.text) ?? 0,
                  tanggal: tanggalController.text,
                );

                await saveToFirestore(newItem);

                Provider.of<ItemListProvider>(context, listen: false)
                    .addItem(newItem);

                Navigator.pop(context);
              },
              child: Text('Simpan'),
              style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 2, 101, 208), // Warna latar belakang tombol
              onPrimary: Colors.white, // Warna teks pada tombol
            ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveToFirestore(Item newItem) async {
    try {
      CollectionReference items =
          FirebaseFirestore.instance.collection('items');

      await items.add({
        'nama': newItem.nama,
        'kode': newItem.kode,
        'quantity': newItem.quantity,
        'harga': newItem.harga,
        'tanggal': newItem.tanggal,
      });

      print('Item added to Firestore');
    } catch (e) {
      print('Error adding item to Firestore: $e');
    }
  }
}
