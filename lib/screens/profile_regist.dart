import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login/login_screen.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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

  Future<void> addUserData(
      String userId, String name, String dob, String phone, String? photoUrl) async {
    try {
      await FirebaseFirestore.instance.collection('profiles').doc(userId).set({
        'name': name,
        'dob': dob,
        'phone': phone,
        'photoUrl': photoUrl,
      });
      print('User data added to Firestore.');
    } catch (e) {
      print('Error adding user data to Firestore: $e');
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
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Registration Page'),
      ),
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
              decoration: InputDecoration(labelText: 'Name',
            
              // Properti untuk warna teks label saat di fokus
              labelStyle: TextStyle(
                color: Colors.black, // Warna teks saat tidak di fokus
              ),
              // Properti untuk warna teks label saat di fokus
              focusColor: Colors.blue, // Warna teks saat di fokus
            ),
            ),
            
            TextField(
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                try {
                  String? photoUrl;

                  if (_image != null) {
                    photoUrl = await uploadImage(_image!.path);
                  }

                  await addUserData(
                    FirebaseAuth.instance.currentUser!.uid,
                    nameController.text,
                    dobController.text,
                    phoneController.text,
                    photoUrl,
                  );

                  // Navigate to the profile page after registration
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                } catch (e) {
                  print('Error during registration: $e');
                }
              },
              child: Text('Register'),
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
