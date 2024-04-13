import 'package:flutter/material.dart';
import 'package:qolshatyr_mobile/src/models/contact.dart';

class ContactCard extends StatefulWidget {
  final Contact contact;

  const ContactCard({super.key, required this.contact});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(widget.contact.name),
        subtitle: Text(widget.contact.phoneNumber),
        onExpansionChanged: (expanded) {
          setState(() {
            _expanded = expanded;
          });
        },
        initiallyExpanded: _expanded,
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Email"),
                SizedBox(height: 8.0),
                Text("Address"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
