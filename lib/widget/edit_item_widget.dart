import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/item_list_provider.dart';
import 'package:flutter_application_1/provider/model/model_item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class EditPage extends StatelessWidget {
  final Item editItem;

  EditPage({required this.editItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: EditItemForm(editItem: editItem),
      ),
    );
  }
}

class EditItemForm extends StatefulWidget {
  final Item editItem;

  EditItemForm({required this.editItem});

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  late TextEditingController namaController;
  late TextEditingController kodeController;
  late TextEditingController quantityController;
  late TextEditingController hargaController;
  late TextEditingController tanggalController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.editItem.nama);
    kodeController = TextEditingController(text: widget.editItem.kode);
    quantityController =
        TextEditingController(text: widget.editItem.quantity.toString());
    hargaController =
        TextEditingController(text: widget.editItem.harga.toString());
    tanggalController = TextEditingController(text: widget.editItem.tanggal);
  }

  String formatCurrency(double amount) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            var newItem = Item(
              nama: namaController.text,
              kode: kodeController.text,
              quantity: int.tryParse(quantityController.text) ?? 0,
              harga: double.tryParse(hargaController.text) ?? 0.0,
              tanggal: tanggalController.text,
              documentReference: widget.editItem.documentReference,
            );

            await updateItemInFirestore(newItem);

            Provider.of<ItemListProvider>(context, listen: false)
                .updateItem(widget.editItem, newItem);

            Navigator.pop(context);
          },
          child: Text('Update'),
          style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 2, 101, 208), // Warna latar belakang tombol
              onPrimary: Colors.white, // Warna teks pada tombol
            ),
        ),
      ],
    ),
    );
  }

  Future<void> updateItemInFirestore(Item newItem) async {
    try {
      await FirebaseFirestore.instance
          .collection('items')
          .doc(newItem.documentReference!.id)
          .update({
        'nama': newItem.nama,
        'kode': newItem.kode,
        'quantity': newItem.quantity,
        'harga': newItem.harga,
        'tanggal': newItem.tanggal,
      });

      print('Item updated in Firestore');
    } catch (e) {
      print('Error updating item in Firestore: $e');
    }
  }
}