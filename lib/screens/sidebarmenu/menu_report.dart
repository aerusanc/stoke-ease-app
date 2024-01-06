import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedOption = 'Camera';

  Future<void> _uploadImage() async {
    try {
      // Mengambil referensi storage Firebase
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.png');

      // Mengunggah file ke Firebase Storage
      UploadTask uploadTask = storageReference.putFile(_image!);
      await uploadTask.whenComplete(() => null);

      // Mendapatkan URL download dari file yang diunggah
      String downloadURL = await storageReference.getDownloadURL();

      // Mendapatkan user saat ini
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Memperbarui data pengguna di Firestore
        await _firestore.collection('users').doc(currentUser.uid).set({
          'displayName': currentUser.displayName,
          'photoURL': downloadURL,
          // Anda dapat menambahkan data pengguna lainnya di sini
        }, SetOptions(merge: true));

        // Memperbarui foto profil pengguna di Firebase Authentication
        await currentUser.updateProfile(photoURL: downloadURL);

        // Secara opsional, Anda dapat memperbarui tampilan foto profil di aplikasi
        setState(() {
          // Tidak perlu melakukan apapun di sini karena photoURL tidak dapat langsung diubah
        });
      }
    } on FirebaseException catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(
                    _image!,
                    height: 150.0,
                  ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 'Camera',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value as String;
                    });
                  },
                ),
                Text('Camera'),
                Radio(
                  value: 'Gallery',
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value as String;
                    });
                  },
                ),
                Text('Gallery'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_selectedOption == 'Camera') {
                  _getImageFromCamera();
                } else {
                  _getImageFromGallery();
                }
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Upload gambar ke Firebase Storage
                await _uploadImage();
              },
              child: Text('Upload Image to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}
