import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';
import 'assign_van_driver_screen.dart';

class _ReviewDetails {
  const _ReviewDetails({
    required this.name,
    required this.refLine,
    required this.rows,
    required this.total,
    required this.docs,
    required this.withDriver,
  });

  final String name;
  final String refLine;
  final List<(String, String)> rows;
  final String total;
  final Map<String, bool> docs; // title -> already verified
  final bool withDriver;
}

const _lee = _ReviewDetails(
  name: 'Lee Wei Ming',
  refLine: 'VQ-2026-0014 · 016-889 0021',
  rows: [
    ('Van', 'Foton View CS2 2024'),
    ('Date', '15 Dec · 8:00 AM – 6:00 PM'),
    ('Rental mode', 'With driver'),
    ('Destination', 'Kuching City tour'),
    ('Group size', '10 people'),
    ('Van rental · per trip', 'RM 320.00'),
    ('Driver fee', 'RM 150.00'),
  ],
  total: 'RM 470.00',
  docs: {'Passport': true, 'Signed rental form': false},
  withDriver: true,
);

const _izzat = _ReviewDetails(
  name: 'Muhammad Izzat',
  refLine: 'VQ-2026-0012 · 012-345 6789',
  rows: [
    ('Van', 'Toyota Hiace 2023'),
    ('Date', '10 Dec 9:00 AM – 12 Dec 6:00 PM'),
    ('Rental mode', 'Self-drive'),
    ('Destination', 'Bako National Park'),
    ('Group size', '8 people'),
    ('Van rental · per trip', 'RM 350.00'),
    ('Driver fee', 'RM 0.00'),
  ],
  total: 'RM 350.00',
  docs: {'IC / Passport': false, 'Signed rental form': false},
  withDriver: false,
);

/// UI-11 Booking review (default + "ready" state).
class BookingReviewScreen extends StatefulWidget {
  const BookingReviewScreen({super.key, required this.booking});
  final BookingInfo booking;

  @override
  State<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends State<BookingReviewScreen> {
  late final _ReviewDetails _d =
      widget.booking.ref.startsWith('VQ-2026-0012') ? _izzat : _lee;
  late final Map<String, bool> _verified = Map.of(_d.docs);
  bool _deposit = false;
  String? _assignment;

  bool get _ready => _verified.values.every((v) => v) && _deposit;

  Future<void> _reject(String doc) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        title: Text('Reject $doc?', style: AppText.title()),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Reason, e.g. photo is blurry',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: AppText.label(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text('Reject',
                style: AppText.label(color: AppColors.cancelledText)),
          ),
        ],
      ),
    );
    if (reason != null && mounted) {
      showToast(context,
          'Customer asked to re-upload $doc${reason.isEmpty ? '' : ': $reason'}');
    }
  }

  Future<void> _assign() async {
    final result = await push<String>(
      context,
      AssignVanDriverScreen(withDriver: _d.withDriver),
    );
    if (result != null && mounted) setState(() => _assignment = result);
  }

  void _confirm() {
    showToast(context, 'Booking confirmed – customer notified');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScreenScroll(
            bottomSpace: 250,
            children: [
              const TopBar(title: 'Review booking'),
              RowsCard(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_d.name, style: AppText.headline()),
                            const SizedBox(height: 2),
                            Text(_d.refLine, style: AppText.caption()),
                          ],
                        ),
                      ),
                      StatusBadge.booking(_ready
                          ? BookingStatus.confirmed
                          : BookingStatus.pending),
                    ],
                  ),
                  const HDivider(),
                  for (final r in _d.rows) InfoRow(r.$1, r.$2),
                  InfoRow('Total', _d.total, total: true),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    'Documents',
                    hint: 'Opened through a private link. Never shared with drivers.',
                  ),
                  const SizedBox(height: 12),
                  for (final doc in _verified.keys) ...[
                    DocReviewRow(
                      title: doc,
                      verified: _verified[doc]!,
                      onView: () => showToast(context, 'Opening $doc…'),
                      onVerify: () => setState(() => _verified[doc] = true),
                      onReject: () => _reject(doc),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    'Deposit',
                    hint: 'Paid outside the app. Mark it once you have received it.',
                  ),
                  const SizedBox(height: 12),
                  RowsCard(
                    children: [
                      const InfoRow('Deposit · bank transfer', 'RM 100.00'),
                      VanqCheckbox(
                        label: 'Deposit received',
                        value: _deposit,
                        onChanged: (v) => setState(() => _deposit = v),
                      ),
                    ],
                  ),
                ],
              ),
              if (_assignment != null)
                RowsCard(
                  children: [
                    Text('Assigned', style: AppText.label()),
                    Text(_assignment!, style: AppText.body()),
                  ],
                ),
            ],
          ),
          FloatingActionBar(
            children: [
              Text(
                _ready
                    ? 'All checks done. Confirm to notify the customer.'
                    : 'Verify both documents and mark the deposit as received to confirm.',
                style: AppText.caption(),
              ),
              VanqButton(
                label: 'Assign van & driver',
                style: VanqButtonStyle.secondary,
                onPressed: _assign,
              ),
              VanqButton(
                label: 'Confirm booking',
                onPressed: _ready ? _confirm : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
