import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../main.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';
import '../shared/profile_screen.dart';
import 'booking_review_screen.dart';

/// UI-08 Admin dashboard.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScroll(
      children: [
        PageHeader(
          overline: 'Van Sewa Samariang',
          title: 'Dashboard',
          trailing: InitialsAvatar(
            'SB',
            size: 44,
            onTap: () => push(
                context, const ProfileScreen(data: adminProfile, showBack: true)),
          ),
        ),
        const IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: StatCard(value: '2', label: 'Pending bookings')),
              SizedBox(width: 12),
              Expanded(child: StatCard(value: '3 / 4', label: 'Vans free today')),
              SizedBox(width: 12),
              Expanded(
                  child: StatCard(value: '2,450', label: 'Income (RM) · Nov')),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              'Needs your review',
              hint:
                  'Confirm within 48 hours, or the booking is cancelled automatically.',
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < adminReviewBookings.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              BookingCard(
                adminReviewBookings[i],
                onTap: () => push(context,
                    BookingReviewScreen(booking: adminReviewBookings[i])),
              ),
            ],
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fleet today', style: AppText.headline()),
            const SizedBox(height: 12),
            ListCard(
              children: [
                for (var i = 0; i < fleetToday.length; i++)
                  _FleetRow(fleetToday[i], showDivider: i < fleetToday.length - 1),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              'Pricing',
              hint:
                  'Only you can change rates. Existing bookings keep their quoted price.',
            ),
            const SizedBox(height: 12),
            RowsCard(
              children: [
                const InfoRow('Per trip · from', 'RM 300.00'),
                const InfoRow('Per km', 'RM 2.50'),
                const InfoRow('Driver add-on · per day', 'RM 150.00'),
                VanqButton(
                  label: 'Edit pricing',
                  style: VanqButtonStyle.secondary,
                  onPressed: () =>
                      showToast(context, 'Pricing editor – coming soon'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _FleetRow extends StatelessWidget {
  const _FleetRow(this.van, {required this.showDivider});
  final FleetVan van;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: Color(0xFFE3E7ED)))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(van.name, style: AppText.body()),
                const SizedBox(height: 2),
                Text(van.detail, style: AppText.caption()),
              ],
            ),
          ),
          StatusBadge.van(van.state),
        ],
      ),
    );
  }
}
