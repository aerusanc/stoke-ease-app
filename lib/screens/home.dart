
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/item_list_provider.dart';
import 'package:flutter_application_1/screens/sidebarmenu/menu_input.dart';
import 'package:flutter_application_1/screens/sidebarmenu/sidebar/sidebar.dart';
import 'package:flutter_application_1/widget/announcementCard_widget.dart';
import 'package:flutter_application_1/widget/inputResult_widget.dart';
import 'package:provider/provider.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showNoDataText = true;
  static const Color primaryColor = const Color.fromARGB(255, 2, 101, 208);
  static const Color accentColor = Color.fromARGB(255, 255, 255, 255);
  final ItemListProvider itemListProvider = ItemListProvider();
  @override
  Widget build(BuildContext context) {
    var itemListProvider = Provider.of<ItemListProvider>(context);
    return Scaffold(
      backgroundColor: primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
          color: Colors.white
        ),
          backgroundColor: Colors.transparent,
           elevation: 0,
          title: Text('Stock Ease',
        style: TextStyle(
          color: accentColor,
        ),
        
        
        ),
      ),
      drawer: Sidebar(),
        body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Check if there is data in Firestore
            bool hasData = snapshot.data!.docs.isNotEmpty;

        return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnnouncementCard(
              title: 'Selamat Datang Sir, ',
              content: 'Belum ada pengumuman penting yang dikirim hari ini.',
            ),
            if(hasData)
            InputResultWidget(itemListProvider: itemListProvider,)
            else
            Text('No data in database',
            style: TextStyle(color: accentColor, fontSize: 20),
            ),
          ]
        ),
        );
          }
        }
        ),
        
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputPage(),
              ),
            );

            if (result != null && result is bool && result) {
              setState((){
                showNoDataText = false;
              });
            }
            

            if (result != null) {
              itemListProvider.addItem(result);
            }
          },
          backgroundColor: accentColor,
          child: Icon(Icons.add, color: primaryColor,),
        ),
    );
  }
            
  }


