import 'package:flutter/material.dart';
import 'package:qolshatyr_mobile/src/presentation/screens/contacts.dart';
import 'package:qolshatyr_mobile/src/presentation/screens/map.dart';
import 'package:qolshatyr_mobile/src/presentation/widgets/contact_floating_action_button.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = '/';

  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Widget> _screens = const [
    MapScreen(),
    Placeholder(),
    ContactsScreen(),
  ];

  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.location_on_rounded),
      label: 'Location',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sos_rounded),
      label: 'SOS',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.call_rounded),
      label: 'Emergy Contacts',
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
      floatingActionButton:
          _selectedIndex == 2 ? const ContactFloatingActionButton() : null,
    );
  }
}
