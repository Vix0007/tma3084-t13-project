import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';

/// UI-07 Earnings – monthly salary for the driver.
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _month = 'Nov 2026';

  @override
  Widget build(BuildContext context) {
    final nov = _month == 'Nov 2026';
    // October numbers are sample values (not in the Figma file).
    final trips = nov ? driverCompletedTrips : driverCompletedTrips.take(2).toList();
    final total = trips.length * 150.0;
    final monthName = nov ? 'November 2026' : 'October 2026';

    return ScreenScroll(
      children: [
        const PageHeader(overline: 'Ahmad · Driver', title: 'Earnings'),
        ChipGroup(
          options: const ['Nov 2026', 'Oct 2026'],
          selected: _month,
          onSelected: (v) => setState(() => _month = v),
        ),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$monthName salary', style: AppText.caption()),
              const SizedBox(height: 4),
              Text(rm(total),
                  style: AppText.largeTitle(color: AppColors.brandPrimary)),
              const SizedBox(height: 4),
              Text(
                  '${trips.length} completed with-driver trips × RM 150.00',
                  style: AppText.caption()),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Completed trips', style: AppText.headline()),
            const SizedBox(height: 12),
            ListCard(
              children: [
                for (var i = 0; i < trips.length; i++)
                  LedgerRow(trips[i], showDivider: i < trips.length - 1),
              ],
            ),
          ],
        ),
        Text(
          'Only completed with-driver trips count toward salary. The owner pays salaries outside the app.',
          style: AppText.caption(),
        ),
      ],
    );
  }
}
