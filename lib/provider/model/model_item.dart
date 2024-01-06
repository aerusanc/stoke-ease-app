import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String nama;
  final String kode;
  final int quantity;
  final double harga;
  final String tanggal;
  DocumentReference? documentReference;
  Item({
    required this.nama,
    required this.kode,
    required this.quantity,
    required this.harga,
    required this.tanggal,
    this.documentReference,
  });
  
}