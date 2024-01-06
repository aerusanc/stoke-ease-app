import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/provider/item_list_provider.dart';
import 'package:flutter_application_1/provider/model/model_item.dart';
import 'package:flutter_application_1/widget/edit_item_widget.dart';
import 'package:intl/intl.dart';

class InputResultWidget extends StatelessWidget {
  final ItemListProvider itemListProvider;

  InputResultWidget({required this.itemListProvider});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('items').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Widget untuk menampilkan hasil inputan
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var document = documents[index];
                    var data = document.data() as Map<String, dynamic>;

                    var item = Item(
                      nama: data['nama'],
                      kode: data['kode'],
                      quantity: data['quantity'],
                      harga: data['harga'],
                      tanggal: data['tanggal'],
                      documentReference: document.reference, // Referensi ke dokumen Firestore
                    );

                    return Card(
                      elevation: 4.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama: ${item.nama}'),
                            Text('Kode: ${item.kode}'),
                            Text('Quantity: ${item.quantity}'),
                            Text('Harga: ${formatCurrency(item.harga)}'),
                            Text('Tanggal: ${item.tanggal}'),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editItem(context, item);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteItem(context, item, itemListProvider);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(amount);
  }

  void _editItem(BuildContext context, Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(editItem: item),
      ),
    );
  }

  void _deleteItem(
      BuildContext context, Item item, ItemListProvider itemListProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Anda yakin ingin menghapus item ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteItemFromFirestore(item);
                itemListProvider.deleteItem(item);
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItemFromFirestore(Item item) async {
    try {
      await item.documentReference!.delete();
      print('Item deleted from Firestore');
    } catch (e) {
      print('Error deleting item from Firestore: $e');
    }
  }
}
