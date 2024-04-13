import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Test'),
      children: [
        ListTile(
          title: Text('Hello'),
        ),
        ListTile(
          title: Icon(Icons.telegram),
        )
      ],
    );
  }
}
