import 'package:flutter/material.dart';

class IconWithTextListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;

  IconWithTextListTile({
    required this.iconData,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding here
      leading: Icon(iconData, color: Color.fromARGB(255, 255, 255, 255), size: 25,),
      title: Text(
        title,
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Color(0xffffffff),
          fontSize: 15,
        ),
      ),
    );
  }
}