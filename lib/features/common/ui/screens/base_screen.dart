// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:qolshatyr_mobile/features/common/ui/screens/map_screen.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/my_drawer.dart';
import 'package:qolshatyr_mobile/features/common/ui/widgets/open_drawer_button.dart';
import 'package:qolshatyr_mobile/features/contacts/ui/contacts_screen.dart';
import 'package:qolshatyr_mobile/features/contacts/ui/widgets/contact_floating_action_button.dart';
import 'package:qolshatyr_mobile/features/trip/ui/screens/trip_status_screen.dart';
import 'package:qolshatyr_mobile/features/trip/ui/widgets/create_trip_floating_action_button.dart';
import 'package:qolshatyr_mobile/themes.dart';

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
      label: 'Emergency Contacts',
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(child: _screens[_selectedIndex]),
          const OpenDrawerButton(),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.085,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            items: _items,
            currentIndex: _selectedIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (value) => setState(() {
              _selectedIndex = value;
            }),
          ),
        ),
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
