import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';

/// UI-10 Income & salary.
class IncomeSalaryScreen extends StatefulWidget {
  const IncomeSalaryScreen({super.key});

  @override
  State<IncomeSalaryScreen> createState() => _IncomeSalaryScreenState();
}

class _IncomeSalaryScreenState extends State<IncomeSalaryScreen> {
  String _month = 'Nov 2026';

  @override
  Widget build(BuildContext context) {
    final nov = _month == 'Nov 2026';
    final label = nov ? 'Nov 2026' : 'Oct 2026';
    // October figures are sample values (not in the Figma file).
    final ledger = nov ? incomeLedger : incomeLedger.skip(2).toList();

    return ScreenScroll(
      children: [
        const PageHeader(
            overline: 'Van Sewa Samariang', title: 'Income & salary'),
        ChipGroup(
          options: const ['Nov 2026', 'Oct 2026'],
          selected: _month,
          onSelected: (v) => setState(() => _month = v),
        ),
        RowsCard(
          children: [
            InfoRow('Trip income', nov ? 'RM 2,450.00' : 'RM 1,120.00'),
            InfoRow('Deposits received', nov ? 'RM 400.00' : 'RM 200.00'),
            InfoRow('Driver salaries', nov ? 'RM 600.00' : 'RM 300.00'),
            const HDivider(),
            InfoRow('Net revenue', nov ? 'RM 1,850.00' : 'RM 820.00',
                total: true),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              'Driver salary · $label',
              hint: 'Completed with-driver trips × RM 150.00 per trip.',
            ),
            const SizedBox(height: 12),
            ListCard(
              footer: VanqButton(
                label: 'Save salary records',
                style: VanqButtonStyle.secondary,
                onPressed: () => showToast(context, 'Salary records saved'),
              ),
              children: [
                for (var i = 0; i < driverSalaries.length; i++)
                  LedgerRow(driverSalaries[i],
                      showDivider: i < driverSalaries.length - 1),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Income ledger', style: AppText.headline()),
            const SizedBox(height: 12),
            ListCard(
              children: [
                for (var i = 0; i < ledger.length; i++)
                  LedgerRow(ledger[i], showDivider: i < ledger.length - 1),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
