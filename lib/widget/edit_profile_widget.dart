import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class EditProfilePage extends StatefulWidget {
  final User user;  // Tambahkan parameter user di sini
  final String name;
  final String dob;
  final String phone;
  final String? photoUrl;
  final Function(String, String, String, String?) onUpdate;

  EditProfilePage({
    required this.user,
    required this.name,
    required this.dob,
    required this.phone,
    required this.photoUrl,
    required this.onUpdate,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  XFile? _image;

  Future<String?> uploadImage(String imagePath) async {
    try {
      File file = File(imagePath);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('user_photos/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.whenComplete(() => null);
      return storageReference.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> updateUserData(String name, String dob, String phone, String? photoUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'name': name,
        'dob': dob,
        'phone': phone,
        'photoUrl': photoUrl,
      });
      print('User data updated in Firestore.');
    } catch (e) {
      print('Error updating user data in Firestore: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image != null
                  ? Image.file(File(_image!.path), height: 100, width: 100)
                  : Container(),
              ElevatedButton(
                onPressed: () => _showImageSourceDialog(),
                child: Text('Upload Photo'),
                style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 2, 101, 208), // Warna latar belakang tombol
              onPrimary: Colors.white, // Warna teks pada tombol
            ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    String? photoUrl;

                    if (_image != null) {
                      photoUrl = await uploadImage(_image!.path);
                    }

                    await updateUserData(
                      nameController.text,
                      dobController.text,
                      phoneController.text,
                      photoUrl,
                    );

                    // Navigate back to the Profile page after updating
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error during profile update: $e');
                  }
                },
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 2, 101, 208), // Warna latar belakang tombol
              onPrimary: Colors.white, // Warna teks pada tombol
            ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
              child: Text('Gallery'),
            ),
          ],
        );
      },
    );
  }
}
