import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';

/// UI-07 Trip schedule (+ "ongoing" state after Start trip).
class TripScheduleScreen extends StatefulWidget {
  const TripScheduleScreen({super.key});

  @override
  State<TripScheduleScreen> createState() => _TripScheduleScreenState();
}

class _TripScheduleScreenState extends State<TripScheduleScreen> {
  final _trips = buildDriverTrips();
  String _filter = 'Upcoming';

  Future<void> _onAction(DriverTrip trip) async {
    if (trip.status == BookingStatus.ongoing) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bgSurface,
          title: Text('End this trip?', style: AppText.title()),
          content: Text(
            'The van is marked as returned and the trip counts toward your salary.',
            style: AppText.body(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel',
                  style: AppText.label(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('End trip',
                  style: AppText.label(color: AppColors.brandPrimary)),
            ),
          ],
        ),
      );
      if (ok == true) {
        setState(() => trip.status = BookingStatus.completed);
        if (mounted) showToast(context, 'Trip ${trip.ref} completed');
      }
    } else {
      setState(() => trip.status = BookingStatus.ongoing);
      showToast(context, 'Trip started – drive safe!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _filter == 'Upcoming';
    final list = _trips
        .where((t) => upcoming
            ? t.status != BookingStatus.completed
            : t.status == BookingStatus.completed)
        .toList();

    return ScreenScroll(
      children: [
        const PageHeader(overline: 'Hi, Ahmad', title: 'My trips'),
        ChipGroup(
          options: const ['Upcoming', 'Completed'],
          selected: _filter,
          onSelected: (v) => setState(() => _filter = v),
        ),
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              upcoming ? 'No upcoming trips.' : 'No completed trips yet.',
              style: AppText.body(color: AppColors.textSecondary),
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < list.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                TripCard(trip: list[i], onAction: () => _onAction(list[i])),
              ],
            ],
          ),
      ],
    );
  }
}
