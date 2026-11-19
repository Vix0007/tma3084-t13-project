import 'package:flutter/material.dart';

import '../../widgets/vanq_widgets.dart';
import '../shared/profile_screen.dart';
import 'home_screen.dart';
import 'my_bookings_screen.dart';

/// Customer app: Home (UI-02), Bookings (UI-06), Profile.
class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  late int _index = widget.initialTab;

  static const _items = [
    NavItem('home', 'Home'),
    NavItem('bookings', 'Bookings'),
    NavItem('profile', 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            index: _index,
            children: const [
              HomeScreen(),
              MyBookingsScreen(),
              ProfileScreen(data: customerProfile),
            ],
          ),
          GlassBottomNav(
            items: _items,
            index: _index,
            onTap: (i) => setState(() => _index = i),
          ),
        ],
      ),
    );
  }
}
