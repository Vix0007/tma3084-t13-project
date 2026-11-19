import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';

/// UI-06 My bookings – Current / Past filter.
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  String _filter = 'Current';

  @override
  Widget build(BuildContext context) {
    final showCurrent = _filter == 'Current';
    return ScreenScroll(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My bookings', style: AppText.largeTitle()),
            const SizedBox(height: 4),
            Text('Status updates live — no need to refresh.',
                style: AppText.body(color: AppColors.textSecondary)),
          ],
        ),
        ChipGroup(
          options: const ['Current', 'Past'],
          selected: _filter,
          onSelected: (v) => setState(() => _filter = v),
        ),
        if (showCurrent) ...[
          _list(customerCurrentBookings),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Past', style: AppText.headline()),
              const SizedBox(height: 12),
              _list(customerPastBookings),
            ],
          ),
        ] else
          _list(customerPastBookings),
      ],
    );
  }

  Widget _list(List<BookingInfo> items) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          BookingCard(
            items[i],
            onTap: items[i].status == BookingStatus.completed
                ? () => showToast(context, 'Thanks! Rating coming soon')
                : null,
          ),
        ],
      ],
    );
  }
}
