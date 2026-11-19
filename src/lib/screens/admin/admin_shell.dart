import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../main.dart';
import '../../widgets/vanq_widgets.dart';
import 'admin_dashboard_screen.dart';
import 'booking_review_screen.dart';
import 'income_salary_screen.dart';

/// Admin app: Dashboard (UI-08), Bookings, Income (UI-10).
///
/// As in the Figma prototype, the Bookings tab opens UI-11 Booking review
/// (for the first booking waiting for review) instead of a separate list.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0; // 0 = Dashboard, 2 = Income

  static const _items = [
    NavItem('dashboard', 'Dashboard'),
    NavItem('bookings', 'Bookings'),
    NavItem('wallet', 'Income'),
  ];

  void _onTap(int i) {
    if (i == 1) {
      push(context, BookingReviewScreen(booking: adminReviewBookings.first));
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(
            index: _index == 2 ? 1 : 0,
            children: const [
              AdminDashboardScreen(),
              IncomeSalaryScreen(),
            ],
          ),
          GlassBottomNav(items: _items, index: _index, onTap: _onTap),
        ],
      ),
    );
  }
}
