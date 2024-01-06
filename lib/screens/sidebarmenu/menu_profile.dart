import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/edit_profile_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  late String name;
  late String dob;
  late String phone;
  late String? photoUrl; // Make photoUrl nullable

  @override
  void initState() {
    super.initState();
    // Initialize the variables with empty values
    user = FirebaseAuth.instance.currentUser!;
    name = '';
    dob = '';
    phone = '';
    photoUrl = null; // Initialize to null

    // Fetch user data when the widget is initialized
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('profiles').doc(user.uid).get();

    setState(() {
      name = userDoc['name'];
      dob = userDoc['dob'];
      phone = userDoc['phone'];
      photoUrl = userDoc['photoUrl']; // Assign without null check
    });
  }

  void _navigateToEditProfile() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProfilePage(
        user: user,
        name: name,
        dob: dob,
        phone: phone,
        photoUrl: photoUrl,
        onUpdate: (String newName, String newDob, String newPhone, String? newPhotoUrl) {
          setState(() {
            name = newName;
            dob = newDob;
            phone = newPhone;
            photoUrl = newPhotoUrl;
          });
        },
      ),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 101, 208),
        title: Text('Profile',
        style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right:10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
              child: Column(
                children:  [
            // Display the user's photo
            CircleAvatar(
              radius: 80,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Name',
                        style: TextStyle(
                          color: Color(0xff86969E),
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        '${name}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,
                        ),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: Color(0xff86969E),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        'Name',
                        style: TextStyle(
                          color: Color(0xff86969E),
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        '${dob}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,
                        ),
                      ),
                      leading: Icon(
                        Icons.calendar_today,
                        color: Color(0xff86969E),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      title: Text(
                        'Name',
                        style: TextStyle(
                          color: Color(0xff86969E),
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        '${phone}',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,
                        ),
                      ),
                      leading: Icon(
                        Icons.phone,
                        color: Color(0xff86969E),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
            ),
            ElevatedButton(
  onPressed: () {
    _navigateToEditProfile();
  },
  child: Text('Edit Profile'),
  style: ElevatedButton.styleFrom(
    primary: const Color.fromARGB(255, 2, 101, 208),
    onPrimary: Colors.white,
  ),
),
          ],
          )
            ),
          );
  }
}

