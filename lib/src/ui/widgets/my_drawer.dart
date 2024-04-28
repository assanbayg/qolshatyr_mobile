import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: double.maxFinite,
        width: MediaQuery.of(context).size.width * 2 / 3,
        decoration: const BoxDecoration(),
      ),
    );
  }
}
