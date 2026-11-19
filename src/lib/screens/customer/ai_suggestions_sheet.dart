import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';

int _openCount = 0;

/// UI-05 AI suggestions (bottom sheet). Returns the picked place name.
///
/// Prototype behaviour: every second time the sheet opens it shows the
/// "fallback" state (AI failed → popular places + Retry), so both Figma
/// states can be demoed. Swap [_loadIdeas] for a real AI call later.
Future<String?> showAiSuggestionsSheet(BuildContext context) {
  _openCount++;
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x660E1726),
    builder: (_) => _AiSheet(simulateFailure: _openCount.isEven),
  );
}

class _AiSheet extends StatefulWidget {
  const _AiSheet({required this.simulateFailure});
  final bool simulateFailure;

  @override
  State<_AiSheet> createState() => _AiSheetState();
}

class _AiSheetState extends State<_AiSheet> {
  String _tripType = tripTypes.first;
  bool _loading = true;
  late bool _failed = widget.simulateFailure;

  @override
  void initState() {
    super.initState();
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (mounted) setState(() => _loading = false);
  }

  void _retry() {
    setState(() => _failed = false);
    _loadIdeas();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Container(
      constraints: BoxConstraints(maxHeight: height * 0.88),
      decoration: const BoxDecoration(
        color: AppColors.bgScreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Place ideas for your trip', style: AppText.title()),
                        const SizedBox(height: 4),
                        Text('Bako area · 3 days · 8 people',
                            style: AppText.caption()),
                      ],
                    ),
                  ),
                  InkResponse(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded,
                        size: 24, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Trip type', style: AppText.label()),
              const SizedBox(height: 8),
              ChipGroup(
                options: tripTypes,
                selected: _tripType,
                onSelected: (t) {
                  setState(() => _tripType = t);
                  _loadIdeas();
                },
              ),
              const SizedBox(height: 16),
              if (_failed) ...[
                _AiErrorBanner(onRetry: _retry),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  const Icon(Icons.auto_awesome_outlined,
                      size: 18, color: AppColors.brandPrimary),
                  const SizedBox(width: 6),
                  Text(_failed ? 'Popular places' : 'AI suggestions',
                      style: AppText.label(color: AppColors.brandPrimary)),
                ],
              ),
              const SizedBox(height: 16),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.brandPrimary),
                  ),
                )
              else
                for (var i = 0; i < aiPlaceIdeas.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _AiPlaceCard(
                    number: i + 1,
                    idea: aiPlaceIdeas[i],
                    onTap: () => Navigator.pop(context, aiPlaceIdeas[i].name),
                  ),
                ],
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.borderSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI-generated suggestions. Please verify details before travelling.',
                        style: AppText.caption(),
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

/// "AI Place Card" – numbered suggestion (FR-AI-01).
class _AiPlaceCard extends StatelessWidget {
  const _AiPlaceCard({required this.number, required this.idea, required this.onTap});
  final int number;
  final PlaceIdea idea;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.brandAccent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('$number',
                style: AppText.label(color: AppColors.brandPrimary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(idea.name, style: AppText.headline()),
                const SizedBox(height: 4),
                Text(idea.category,
                    style: AppText.caption(color: AppColors.brandPrimary)),
                const SizedBox(height: 4),
                Text(idea.reason,
                    style: AppText.body(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiErrorBanner extends StatelessWidget {
  const _AiErrorBanner({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.pendingBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 18, color: AppColors.pendingText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Couldn't load AI suggestions. Showing popular places instead.",
              style: AppText.caption(color: AppColors.pendingText),
            ),
          ),
          const SizedBox(width: 10),
          PillAction(
            label: 'Retry',
            icon: Icons.refresh_rounded,
            onTap: onRetry,
          ),
        ],
      ),
    );
  }
}
