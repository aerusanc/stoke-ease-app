// sidebar_button.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Widget destination;

  const SidebarButton({required this.icon, required this.destination, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination)
        );
      },
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0),width: 3, ),
          borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
          Icon(
            icon,
          color: const Color.fromARGB(255, 2, 101, 208),
        ),
        SizedBox(width:4),
        Text(
          label,
          style: TextStyle(
            color: const Color.fromARGB(255, 2, 101, 208),
          ),
        )
      ],
      ),
    ),
    );
  }
}

class SidebarHeader extends StatefulWidget {
  
  @override
  State<SidebarHeader> createState() => _SidebarHeaderState();
}

class _SidebarHeaderState extends State<SidebarHeader> {
  late User user;
  late String name;
  late String? photoUrl;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the widget is initialized
    user = FirebaseAuth.instance.currentUser!;
    name = '';
    photoUrl = null;

    fetchUserData();
    
  }

  Future<void> fetchUserData() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('profiles').doc(user.uid).get();

    setState(() {
      name = userDoc['name'];
      photoUrl = userDoc['photoUrl']; // Assign without null check
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 2, 101, 208),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70)
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // margin: EdgeInsets.only(bottom: 10),
                        // height: 70,
                        // width: 70,
                        child: CircleAvatar(
              radius: 50,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            ),
                      ),
                      Text('$name',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
                      ),
                    ],
                  ),
                  
              );
  }
}