import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';

/// UI-09 Assign van & driver. Pops with a short summary string.
class AssignVanDriverScreen extends StatefulWidget {
  const AssignVanDriverScreen({super.key, this.withDriver = true});
  final bool withDriver;

  @override
  State<AssignVanDriverScreen> createState() => _AssignVanDriverScreenState();
}

class _AssignVanDriverScreenState extends State<AssignVanDriverScreen> {
  int _van = 0;
  int _driver = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScreenScroll(
            bottomSpace: 190,
            children: [
              const TopBar(title: 'Assign van & driver'),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VQ-2026-0014 · Lee Wei Ming',
                        style: AppText.headline()),
                    const SizedBox(height: 4),
                    Text('15 Dec, 8:00 AM – 6:00 PM · 10 people · With driver',
                        style: AppText.caption()),
                  ],
                ),
              ),
              _section(
                title: 'Van',
                hint: 'Vans with an overlapping booking can’t be selected.',
                options: assignVanOptions,
                selected: _van,
                onSelect: (i) => setState(() => _van = i),
              ),
              if (widget.withDriver)
                _section(
                  title: 'Driver',
                  hint: 'Only drivers who are free for the whole trip can be picked.',
                  options: assignDriverOptions,
                  selected: _driver,
                  onSelect: (i) => setState(() => _driver = i),
                ),
            ],
          ),
          FloatingActionBar(
            children: [
              Text('The customer and driver are notified when you confirm.',
                  style: AppText.caption()),
              VanqButton(
                label: 'Confirm assignment',
                onPressed: () {
                  final van = assignVanOptions[_van].title;
                  final summary = widget.withDriver
                      ? '$van · Driver ${assignDriverOptions[_driver].title}'
                      : van;
                  Navigator.pop(context, summary);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required String hint,
    required List<SelectOption> options,
    required int selected,
    required ValueChanged<int> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title, hint: hint),
        const SizedBox(height: 12),
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          SelectRow(
            option: options[i],
            selected: i == selected,
            onTap: () => onSelect(i),
          ),
        ],
      ],
    );
  }
}
