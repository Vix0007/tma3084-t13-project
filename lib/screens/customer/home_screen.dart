import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../main.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';
import 'booking_form_screen.dart';

/// UI-02 Home – search card + available vans.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pickup = TextEditingController(text: '10 Dec, 9:00 AM');
  final _return = TextEditingController(text: '12 Dec, 6:00 PM');
  final _group = TextEditingController(text: '8 people');

  @override
  void dispose() {
    _pickup.dispose();
    _return.dispose();
    _group.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final free = vans.where((v) => v.state == VanState.available).length;
    return ScreenScroll(
      children: [
        PageHeader(overline: '$_greeting, Izzat', title: 'Where to next?'),
        SurfaceCard(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VanqTextField(
                      label: 'Pickup',
                      hint: '10 Dec, 9:00 AM',
                      helper: 'At least 24h ahead',
                      controller: _pickup,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VanqTextField(
                      label: 'Return',
                      hint: '12 Dec, 6:00 PM',
                      helper: '1 to 14 days',
                      controller: _return,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              VanqTextField(
                label: 'Group size',
                hint: '8 people',
                helper: 'Our vans seat up to 18',
                controller: _group,
              ),
              const SizedBox(height: 16),
              VanqButton(
                label: 'Check availability',
                onPressed: () => showToast(context, '$free of ${vans.length} vans free for these dates'),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available vans', style: AppText.headline()),
            const SizedBox(height: 4),
            Text('10–12 Dec · 8 people · $free of ${vans.length} vans free',
                style: AppText.caption()),
          ],
        ),
        Column(
          children: [
            for (var i = 0; i < vans.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              VanCard(
                vans[i],
                onTap: () => push(context, BookingFormScreen(van: vans[i])),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
