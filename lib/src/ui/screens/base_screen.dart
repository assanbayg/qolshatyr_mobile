// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/src/ui/screens/contacts_screen.dart';
import 'package:qolshatyr_mobile/src/ui/screens/map_screen.dart';
import 'package:qolshatyr_mobile/src/ui/screens/trip_status_screen.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/floating_action_buttons.dart';
import 'package:qolshatyr_mobile/src/ui/widgets/my_drawer.dart';

class BaseScreen extends StatefulWidget {
  static const routeName = '/base';

  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final List<Widget> _screens = const [
    MapScreen(),
    TripStatusScreen(),
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
      drawer: const MyDrawer(),
      floatingActionButton: _selectedIndex == 0
          ? const CreateTripFloatingActionButton()
          : _selectedIndex == 2
              ? const ContactFloatingActionButton()
              : null,
    );
  }
}
