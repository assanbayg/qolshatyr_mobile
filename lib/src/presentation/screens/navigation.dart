import 'package:flutter/material.dart';
import 'package:qolshatyr_mobile/src/presentation/screens/contacts.dart';
import 'package:qolshatyr_mobile/src/presentation/screens/map.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = '/';

  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Widget> _screens = const [
    MapScreen(),
    ContactsScreen(),
    Placeholder(), // ToDo: clarify about SOS Screen
  ];

  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.location_on_rounded),
      label: 'Location',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.call_rounded),
      label: 'Emergy Contacts',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sos_rounded),
      label: 'SOS',
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
      ),
    );
  }
}
