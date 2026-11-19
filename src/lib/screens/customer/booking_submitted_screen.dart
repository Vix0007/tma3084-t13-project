import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';
import 'booking_form_screen.dart';
import 'customer_shell.dart';

/// Booking submitted – confirmation with reference number.
class BookingSubmittedScreen extends StatelessWidget {
  const BookingSubmittedScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Figma: icon starts 96px from the top. SafeArea already adds the
          // status bar on a phone; in a browser it adds nothing.
          padding: EdgeInsets.fromLTRB(
              20, (96 - MediaQuery.paddingOf(context).top).clamp(72, 96), 20, 40),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.completedBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    size: 36, color: AppColors.completedText),
              ),
              const SizedBox(height: 24),
              Text('Booking request sent',
                  style: AppText.largeTitle(), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'The owner will check your documents and deposit, then confirm your booking.',
                style: AppText.body(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Booking reference',
                                  style: AppText.caption()),
                              const SizedBox(height: 2),
                              Text('VQ-2026-0012', style: AppText.title()),
                            ],
                          ),
                        ),
                        StatusBadge.booking(BookingStatus.pending),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const HDivider(),
                    const SizedBox(height: 12),
                    InfoRow('Van', draft.van.model),
                    const SizedBox(height: 12),
                    const InfoRow('Dates', '10–12 Dec 2026'),
                    const SizedBox(height: 12),
                    InfoRow('Estimated total', rm(draft.total), total: true),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.pendingBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Pending: awaiting document check and deposit. Bookings not confirmed within 48 hours are cancelled automatically.',
                        style: AppText.caption(color: AppColors.pendingText),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              VanqButton(
                label: 'View my bookings',
                onPressed: () =>
                    goTo(context, const CustomerShell(initialTab: 1)),
              ),
              const SizedBox(height: 8),
              VanqButton(
                label: 'Back to home',
                style: VanqButtonStyle.text,
                onPressed: () => goTo(context, const CustomerShell()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
