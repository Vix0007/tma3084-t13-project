import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';
import 'booking_form_screen.dart';
import 'booking_submitted_screen.dart';

/// UI-04 Upload + summary (default + "ready" state).
///
/// Prototype: tapping Upload marks the document as uploaded. To pick real
/// files later, add the `file_picker` or `image_picker` package.
class UploadSummaryScreen extends StatefulWidget {
  const UploadSummaryScreen({super.key, required this.draft});
  final BookingDraft draft;

  @override
  State<UploadSummaryScreen> createState() => _UploadSummaryScreenState();
}

class _UploadSummaryScreenState extends State<UploadSummaryScreen> {
  bool _icUploaded = true; // Figma default state shows IC already uploaded
  bool _formUploaded = false;

  bool get _ready => _icUploaded && _formUploaded;

  @override
  Widget build(BuildContext context) {
    final d = widget.draft;
    return Scaffold(
      body: Stack(
        children: [
          ScreenScroll(
            bottomSpace: 190,
            children: [
              const TopBar(title: 'Documents & summary'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Upload documents', style: AppText.headline()),
                  const SizedBox(height: 12),
                  Text(
                    'Your IC (Malaysian) or passport (foreign tourist) and the signed rental form. JPG, PNG or PDF, max 5 MB each.',
                    style: AppText.caption(),
                  ),
                  const SizedBox(height: 12),
                  UploadTile(
                    title: 'IC / Passport',
                    uploaded: _icUploaded,
                    fileName: 'IC_front.jpg',
                    onTap: () => setState(() => _icUploaded = true),
                  ),
                  const SizedBox(height: 12),
                  UploadTile(
                    title: 'Signed rental form',
                    uploaded: _formUploaded,
                    fileName: 'Rental_form.pdf',
                    onTap: () => setState(() => _formUploaded = true),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () =>
                        showToast(context, 'Blank rental form downloaded'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.download_rounded,
                            size: 16, color: AppColors.brandPrimary),
                        const SizedBox(width: 6),
                        Text('Download blank rental form',
                            style:
                                AppText.label(color: AppColors.brandPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking summary', style: AppText.headline()),
                  const SizedBox(height: 12),
                  RowsCard(
                    children: [
                      InfoRow('Van', d.van.model),
                      const InfoRow('Dates', '10–12 Dec 2026'),
                      InfoRow('Rental mode',
                          d.withDriver ? 'With driver' : 'Self-drive'),
                      InfoRow('Destination', d.destination),
                      InfoRow('Pickup', d.pickup),
                      const InfoRow('Group size', BookingDraft.groupSize),
                      const HDivider(),
                      InfoRow('Estimated total', rm(d.total), total: true),
                      Text(
                        'Deposit and payment are made outside the app (cash or bank transfer).',
                        style: AppText.caption(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          FloatingActionBar(
            children: [
              Text(
                _ready
                    ? 'Your documents are ready. The owner will check them and confirm your booking.'
                    : 'Upload both documents to submit your booking.',
                style: AppText.caption(),
              ),
              VanqButton(
                label: 'Submit booking',
                onPressed: _ready
                    ? () => push(context, BookingSubmittedScreen(draft: d))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
