import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';
import 'ai_suggestions_sheet.dart';
import 'upload_summary_screen.dart';

/// Everything the customer picked, carried through the booking flow.
class BookingDraft {
  BookingDraft({
    required this.van,
    required this.withDriver,
    required this.destination,
    required this.pickup,
  });

  final Van van;
  final bool withDriver;
  final String destination;
  final String pickup;

  static const driverFee = 150.0;
  static const dates = '10 Dec, 9:00 AM → 12 Dec, 6:00 PM';
  static const groupSize = '8 people';

  double get fee => withDriver ? driverFee : 0;
  double get total => van.price + fee;
}

/// UI-03 Booking form (default + "ready" state).
class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key, required this.van});
  final Van van;

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  int _mode = 0; // 0 = Self-drive, 1 = With driver
  bool _licence = false;
  String _destination = destinations.first;
  String _pickup = 'Van Sewa Samariang base';

  bool get _withDriver => _mode == 1;
  bool get _ready => _withDriver || _licence;

  BookingDraft get _draft => BookingDraft(
        van: widget.van,
        withDriver: _withDriver,
        destination: _destination,
        pickup: _pickup,
      );

  Future<void> _openAiIdeas() async {
    final picked = await showAiSuggestionsSheet(context);
    if (picked == null || !mounted) return;
    // Map a suggestion back onto a destination chip when it matches.
    final match = destinations.firstWhere(
      (d) => picked.toLowerCase().contains(d.split(' ').first.toLowerCase()),
      orElse: () => _destination,
    );
    setState(() => _destination = match);
  }

  Future<void> _changePickup() async {
    const options = [
      'Van Sewa Samariang base',
      'Kuching International Airport',
      'Kuching Waterfront Hotel',
    ];
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.bgScreen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pickup point', style: AppText.title()),
              const SizedBox(height: 12),
              for (final o in options)
                MenuRow(
                  title: o,
                  showDivider: o != options.last,
                  onTap: () => Navigator.pop(context, o),
                ),
            ],
          ),
        ),
      ),
    );
    if (result != null) setState(() => _pickup = result);
  }

  @override
  Widget build(BuildContext context) {
    final d = _draft;
    return Scaffold(
      body: Stack(
        children: [
          ScreenScroll(
            bottomSpace: 250,
            children: [
              const TopBar(title: 'Book your van'),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.van.model,
                        style: AppText.title(color: Colors.black)),
                    const SizedBox(height: 4),
                    Text('${BookingDraft.dates} · ${BookingDraft.groupSize}',
                        style: AppText.caption()),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rental mode', style: AppText.headline()),
                  const SizedBox(height: 12),
                  SegmentedControl(
                    options: const ['Self-drive', 'With driver'],
                    selectedIndex: _mode,
                    onChanged: (i) => setState(() => _mode = i),
                  ),
                  if (!_withDriver) ...[
                    const SizedBox(height: 12),
                    VanqCheckbox(
                      label: 'I hold a valid driving licence',
                      value: _licence,
                      onChanged: (v) => setState(() => _licence = v),
                    ),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Destination', style: AppText.headline()),
                  const SizedBox(height: 12),
                  ChipGroup(
                    options: destinations,
                    selected: _destination,
                    onSelected: (v) => setState(() => _destination = v),
                  ),
                  const SizedBox(height: 12),
                  VanqButton(
                    label: 'Get AI place ideas',
                    style: VanqButtonStyle.secondary,
                    onPressed: _openAiIdeas,
                  ),
                ],
              ),
              VanqTextField(
                key: ValueKey(_pickup),
                label: 'Pickup point',
                hint: _pickup,
                helper: 'Tap to change',
                readOnly: true,
                onTap: _changePickup,
              ),
            ],
          ),
          FloatingActionBar(
            children: [
              _PriceLine('Van rental · per trip', rm(d.van.price)),
              _PriceLine('Driver fee', rm(d.fee)),
              _PriceLine('Estimated total', rm(d.total), total: true),
              VanqButton(
                label: 'Continue',
                onPressed: _ready
                    ? () => push(context, UploadSummaryScreen(draft: d))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine(this.label, this.value, {this.total = false});
  final String label;
  final String value;
  final bool total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: total
                ? AppText.headline()
                : AppText.body(color: AppColors.textSecondary)),
        Text(value,
            style: total
                ? AppText.headline(color: AppColors.brandPrimary)
                : AppText.body()),
      ],
    );
  }
}
