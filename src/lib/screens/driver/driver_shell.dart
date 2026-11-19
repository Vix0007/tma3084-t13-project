import 'package:flutter/material.dart';

import '../../widgets/vanq_widgets.dart';
import '../shared/profile_screen.dart';
import 'earnings_screen.dart';
import 'trip_schedule_screen.dart';

/// Driver app: Trips (UI-07), Earnings, Profile.
class DriverShell extends StatefulWidget {
  const DriverShell({super.key});

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;

  static const _items = [
    NavItem('calendar', 'Trips'),
    NavItem('wallet', 'Earnings'),
    NavItem('profile', 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // fit: expand keeps the nav pinned to the bottom even when every tab's
      // content is shorter than the screen.
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            index: _index,
            children: const [
              TripScheduleScreen(),
              EarningsScreen(),
              ProfileScreen(data: driverProfile),
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
