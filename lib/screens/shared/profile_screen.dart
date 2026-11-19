import 'package:flutter/material.dart';

import '../../main.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';
import '../auth/login_screen.dart';

class ProfileData {
  const ProfileData({
    required this.initials,
    required this.name,
    required this.contact,
    required this.role,
    required this.settings,
  });

  final String initials;
  final String name;
  final String contact;
  final String role;

  /// (title, value) pairs for the Menu Rows.
  final List<(String, String)> settings;
}

const customerProfile = ProfileData(
  initials: 'MI',
  name: 'Muhammad Izzat',
  contact: 'izzat@example.com · 012-345 6789',
  role: 'Tourist',
  settings: [
    ('Personal details', 'Name, phone, IC'),
    ('Notifications', 'On'),
    ('Help & user guide', ''),
    ('Privacy & data', 'PDPA 2010'),
  ],
);

const driverProfile = ProfileData(
  initials: 'AH',
  name: 'Ahmad bin Hassan',
  contact: 'ahmad@vansewa.my · 013-555 2468',
  role: 'Driver',
  settings: [
    ('Personal details', 'Name, phone'),
    ('New trip alerts', 'On'),
    ('Salary records', 'Nov 2026'),
    ('Help & user guide', ''),
  ],
);

const adminProfile = ProfileData(
  initials: 'SB',
  name: 'Saie Bin Kip',
  contact: 'Van Sewa Samariang · 019-876 5432',
  role: 'Owner · Admin',
  settings: [
    ('Business details', 'Van Sewa Samariang'),
    ('Drivers & vans', '2 drivers · 4 vans'),
    ('Pricing rules', '3 rates'),
    ('Notifications', 'On'),
  ],
);

/// Profile – Customer / Driver / Admin.
/// [showBack] is true for Admin (opened from the dashboard avatar).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.data, this.showBack = false});
  final ProfileData data;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final body = ScreenScroll(
      bottomSpace: showBack ? 40 : 120,
      children: [
        if (showBack)
          const TopBar(title: 'Profile')
        else
          Text('Profile', style: AppText.largeTitle()),
        ProfileCard(
          initials: data.initials,
          name: data.name,
          contact: data.contact,
          role: data.role,
        ),
        SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              for (var i = 0; i < data.settings.length; i++)
                MenuRow(
                  title: data.settings[i].$1,
                  value: data.settings[i].$2,
                  showDivider: i < data.settings.length - 1,
                  onTap: () => showToast(context, '${data.settings[i].$1} – coming soon'),
                ),
            ],
          ),
        ),
        VanqButton(
          label: 'Log out',
          style: VanqButtonStyle.secondary,
          onPressed: () => goTo(context, const LoginScreen()),
        ),
        Text('VanQ v1.0.0 · Team MLM (T13)', style: AppText.caption()),
      ],
    );

    return showBack ? Scaffold(body: body) : body;
  }
}
