import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/sample_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'buttons.dart';
import 'layout.dart';

/// White rounded card with the "Card Shadow" effect.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.radius = 20,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: r,
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: r,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Section heading (Headline) with optional caption hint underneath.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.hint});
  final String title;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.headline()),
        if (hint != null) ...[
          const SizedBox(height: 12),
          Text(hint!, style: AppText.caption()),
        ],
      ],
    );
  }
}

/// "Status Badge" – the status is always written out, never colour only.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.bg, required this.fg});

  factory StatusBadge.booking(BookingStatus s) {
    switch (s) {
      case BookingStatus.pending:
      case BookingStatus.cancelled:
        // "Action needed" bookings are still Pending in the design.
        return const StatusBadge(
            label: 'Pending', bg: AppColors.pendingBg, fg: AppColors.pendingText);
      case BookingStatus.confirmed:
        return const StatusBadge(
            label: 'Confirmed',
            bg: AppColors.confirmedBg,
            fg: AppColors.confirmedText);
      case BookingStatus.ongoing:
        return const StatusBadge(
            label: 'Ongoing', bg: AppColors.ongoingBg, fg: AppColors.ongoingText);
      case BookingStatus.completed:
        return const StatusBadge(
            label: 'Completed',
            bg: AppColors.completedBg,
            fg: AppColors.completedText);
    }
  }

  factory StatusBadge.van(VanState s) {
    switch (s) {
      case VanState.available:
        return const StatusBadge(
            label: 'Available',
            bg: AppColors.completedBg,
            fg: AppColors.completedText);
      case VanState.onTrip:
        return const StatusBadge(
            label: 'On trip', bg: AppColors.ongoingBg, fg: AppColors.ongoingText);
      case VanState.maintenance:
        return const StatusBadge(
            label: 'Maintenance',
            bg: AppColors.border,
            fg: AppColors.textSecondary);
      case VanState.booked:
        return const StatusBadge(
            label: 'Booked', bg: AppColors.bgScreen, fg: AppColors.textSecondary);
    }
  }

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: AppText.label(color: fg)),
    );
  }
}

/// "Info Row" – label/value. [total] uses the Headline style.
class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key, this.total = false});
  final String label;
  final String value;
  final bool total;

  @override
  Widget build(BuildContext context) {
    final l = total ? AppText.headline() : AppText.body(color: AppColors.textSecondary);
    final v = total
        ? AppText.headline(color: AppColors.brandPrimary)
        : AppText.body();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: l),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value, style: v, textAlign: TextAlign.right),
        ),
      ],
    );
  }
}

class HDivider extends StatelessWidget {
  const HDivider({super.key});
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.border);
}

/// Card containing a column of rows with 10px gaps (summary/pricing cards).
class RowsCard extends StatelessWidget {
  const RowsCard({super.key, required this.children, this.gap = 10});
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// "Ledger Row" – title/subtitle on the left, amount on the right.
class LedgerRow extends StatelessWidget {
  const LedgerRow(this.entry, {super.key, this.showDivider = true});
  final LedgerEntry entry;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: AppText.body()),
                const SizedBox(height: 2),
                Text(entry.subtitle, style: AppText.caption()),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Text(entry.amount, style: AppText.body()),
        ],
      ),
    );
  }
}

/// White list card holding rows (ledger, fleet, settings) with 16px side padding.
class ListCard extends StatelessWidget {
  const ListCard({super.key, required this.children, this.footer});
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: EdgeInsets.fromLTRB(16, 4, 16, footer == null ? 4 : 12),
      child: Column(
        children: [
          ...children,
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

/// Small icon + caption line used on booking and trip cards.
class IconLine extends StatelessWidget {
  const IconLine(this.icon, this.text, {super.key, this.svg});
  final IconData icon;
  final String text;

  /// Figma SVG icon (assets/icons/...). Used instead of [icon] when set.
  final String? svg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (svg != null)
          SvgPicture.asset(svg!, width: 16, height: 16)
        else
          Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppText.caption())),
      ],
    );
  }
}

/// "Booking Card" – used on My bookings and the admin dashboard.
class BookingCard extends StatelessWidget {
  const BookingCard(this.booking, {super.key, this.onTap});
  final BookingInfo booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color noteBg = AppColors.bgScreen;
    Color noteFg = AppColors.textPrimary;
    if (booking.status == BookingStatus.cancelled) {
      noteBg = AppColors.cancelledBg;
      noteFg = AppColors.cancelledText;
    } else if (booking.status == BookingStatus.confirmed) {
      noteBg = AppColors.confirmedBg;
      noteFg = AppColors.confirmedText;
    }

    return SurfaceCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.title, style: AppText.headline()),
                    const SizedBox(height: 2),
                    Text(booking.ref, style: AppText.caption()),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge.booking(booking.status),
            ],
          ),
          const SizedBox(height: 12),
          IconLine(Icons.calendar_today_outlined, booking.dates,
              svg: 'assets/icons/calendar_small.svg'),
          const SizedBox(height: 12),
          IconLine(Icons.location_on_outlined, booking.destination,
              svg: 'assets/icons/pin.svg'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: noteBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(booking.note, style: AppText.caption(color: noteFg)),
          ),
        ],
      ),
    );
  }
}

/// "Van Card" on the customer home screen.
class VanCard extends StatelessWidget {
  const VanCard(this.van, {super.key, this.onTap});
  final Van van;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final available = van.state == VanState.available;
    final titleColor = available ? AppColors.textPrimary : AppColors.textSecondary;
    return SurfaceCard(
      onTap: available ? onTap : null,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: available ? 1 : 0.4,
            child: VanImage(van.image, height: 160),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(van.model, style: AppText.headline(color: titleColor)),
                    const SizedBox(height: 4),
                    Text(van.details, style: AppText.caption()),
                    const SizedBox(height: 12),
                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: available
                            ? AppColors.completedBg
                            : AppColors.bgScreen,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        available ? 'Available' : 'Booked for these dates',
                        style: AppText.caption(
                          color: available
                              ? AppColors.completedText
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'RM ${van.price.toStringAsFixed(0)}',
                    style: AppText.headline(
                      color: available
                          ? AppColors.brandPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text('per trip', style: AppText.caption()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Stat Card" – small KPI tile on the admin dashboard.
class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.title()),
          const SizedBox(height: 4),
          Text(label, style: AppText.caption()),
        ],
      ),
    );
  }
}

/// "Menu Row" – settings row with value and chevron.
class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.title,
    this.value = '',
    this.showDivider = true,
    this.onTap,
  });
  final String title;
  final String value;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppText.body())),
            if (value.isNotEmpty) ...[
              Text(value, style: AppText.caption()),
              const SizedBox(width: 12),
            ],
            SvgPicture.asset('assets/icons/chevron.svg', width: 18, height: 18),
          ],
        ),
      ),
    );
  }
}

/// "Upload Tile" – empty (dashed) or uploaded state.
class UploadTile extends StatelessWidget {
  const UploadTile({
    super.key,
    required this.title,
    required this.uploaded,
    required this.fileName,
    required this.onTap,
  });

  final String title;
  final bool uploaded;
  final String fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: uploaded ? AppColors.completedBg : AppColors.bgScreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            uploaded ? Icons.check_rounded : Icons.badge_outlined,
            size: 22,
            color: uploaded ? AppColors.completedText : AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.headline()),
              const SizedBox(height: 4),
              Text(
                uploaded
                    ? '$fileName · 1.2 MB · Uploaded'
                    : 'Camera or files · JPG, PNG or PDF, max 5 MB',
                style: AppText.caption(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        uploaded
            ? PillAction(label: 'Replace', outlined: true, onTap: onTap)
            : PillAction(
                label: 'Upload',
                icon: Icons.file_upload_outlined,
                background: AppColors.brandAccent,
                onTap: onTap,
              ),
      ],
    );

    if (uploaded) {
      return SurfaceCard(child: content);
    }
    return DashedBorderBox(
      radius: 20,
      color: AppColors.border,
      child: Material(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(padding: const EdgeInsets.all(16), child: content),
        ),
      ),
    );
  }
}

/// "Doc Review Row" – admin View / Reject / Verify.
class DocReviewRow extends StatelessWidget {
  const DocReviewRow({
    super.key,
    required this.title,
    required this.verified,
    required this.onVerify,
    required this.onReject,
    required this.onView,
  });

  final String title;
  final bool verified;
  final VoidCallback onVerify;
  final VoidCallback onReject;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.bgScreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description_outlined,
                    size: 22, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.headline()),
                    const SizedBox(height: 4),
                    Text('Uploaded 18 Nov, 10:42 PM', style: AppText.caption()),
                  ],
                ),
              ),
              PillAction(
                label: 'View',
                icon: Icons.visibility_outlined,
                outlined: true,
                onTap: onView,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (verified)
            Row(
              children: [
                const Icon(Icons.check_rounded,
                    size: 16, color: AppColors.completedText),
                const SizedBox(width: 6),
                Text('Verified',
                    style: AppText.label(color: AppColors.completedText)),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: PillAction(
                    label: 'Reject',
                    outlined: true,
                    foreground: AppColors.cancelledText,
                    verticalPadding: 10,
                    center: true,
                    onTap: onReject,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PillAction(
                    label: 'Verify',
                    icon: Icons.check_rounded,
                    background: AppColors.brandPrimary,
                    foreground: AppColors.bgSurface,
                    verticalPadding: 10,
                    center: true,
                    onTap: onVerify,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// "Select Row" – radio row for picking a van or driver.
class SelectRow extends StatelessWidget {
  const SelectRow({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final SelectOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = option.enabled;
    return Material(
      color: enabled ? AppColors.bgSurface : AppColors.bgScreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? AppColors.brandPrimary : AppColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: selected ? 15 : 16, vertical: selected ? 13 : 14),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 20,
                color: enabled
                    ? (selected ? AppColors.brandPrimary : AppColors.textSecondary)
                    : AppColors.disabled,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: AppText.body(
                        color:
                            enabled ? AppColors.textPrimary : AppColors.disabled,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.subtitle,
                      style: AppText.caption(
                        color: enabled
                            ? AppColors.textSecondary
                            : AppColors.cancelledText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Trip Card" – driver trip with Start / End trip action.
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onAction});
  final DriverTrip trip;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final ongoing = trip.status == BookingStatus.ongoing;
    final completed = trip.status == BookingStatus.completed;

    String label;
    VoidCallback? action;
    if (completed) {
      label = 'Trip completed';
      action = null;
    } else if (ongoing) {
      label = 'End trip';
      action = onAction;
    } else if (trip.canStart) {
      label = 'Start trip';
      action = onAction;
    } else {
      label = 'Starts on ${trip.startsOn}';
      action = null;
    }

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.title, style: AppText.headline()),
                    const SizedBox(height: 2),
                    Text(trip.ref, style: AppText.caption()),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge.booking(trip.status),
            ],
          ),
          const SizedBox(height: 12),
          IconLine(Icons.calendar_today_outlined, trip.dates,
              svg: 'assets/icons/calendar_small.svg'),
          const SizedBox(height: 8),
          IconLine(Icons.airport_shuttle_outlined, trip.van),
          const SizedBox(height: 8),
          IconLine(Icons.person_outline_rounded, trip.customer),
          const SizedBox(height: 8),
          IconLine(Icons.location_on_outlined, trip.pickup,
              svg: 'assets/icons/pin.svg'),
          const SizedBox(height: 12),
          VanqButton(label: label, onPressed: action),
        ],
      ),
    );
  }
}

/// Profile card with initials avatar and role pill.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.initials,
    required this.name,
    required this.contact,
    required this.role,
  });

  final String initials;
  final String name;
  final String contact;
  final String role;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: [
          InitialsAvatar(initials, size: 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.headline()),
                const SizedBox(height: 4),
                Text(contact, style: AppText.caption()),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.brandAccentSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(role,
                      style: AppText.label(color: AppColors.brandPrimary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.initials, {super.key, this.size = 56, this.onTap});
  final String initials;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.brandPrimary,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              initials,
              style: size > 48
                  ? AppText.headline(color: AppColors.bgSurface)
                  : AppText.label(color: AppColors.bgSurface),
            ),
          ),
        ),
      ),
    );
  }
}
