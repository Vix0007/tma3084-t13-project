import 'package:flutter/material.dart';

import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/vanq_widgets.dart';
import '../admin/admin_shell.dart';
import '../customer/customer_shell.dart';
import '../driver/driver_shell.dart';

/// UI-01 Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    // Prototype: any sign-in goes to the customer app.
    goTo(context, const CustomerShell());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScreen,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Figma: logo starts 96px from the top. SafeArea already adds the
            // status bar on a phone; in a browser it adds nothing.
            final top = (96 - MediaQuery.paddingOf(context).top).clamp(72.0, 96.0);
            return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, top, 20, 40),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: (constraints.maxHeight - top - 40).clamp(0.0, double.infinity)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VanqLogo(),
                      const SizedBox(height: 24),
                      Text('Welcome to VanQ', style: AppText.largeTitle()),
                      const SizedBox(height: 8),
                      Text('Book a van for your Sarawak trip in minutes',
                          style: AppText.body(color: AppColors.textSecondary)),
                      const SizedBox(height: 24),
                      VanqTextField(
                        label: 'Email',
                        hint: 'you@example.com',
                        helper: "We'll send your booking updates here",
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      VanqTextField(
                        label: 'Password',
                        hint: 'Enter your password',
                        helper: 'At least 8 characters',
                        controller: _password,
                        obscure: true,
                      ),
                      const SizedBox(height: 24),
                      VanqButton(label: 'Sign In', onPressed: _signIn),
                      const SizedBox(height: 24),
                      VanqButton(
                        label: 'New here? Create an account',
                        style: VanqButtonStyle.text,
                        onPressed: () =>
                            showToast(context, 'Sign-up is not part of this prototype'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prototype demo – sign in as:',
                          style: AppText.caption()),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: VanqButton(
                              label: 'Customer',
                              style: VanqButtonStyle.secondary,
                              horizontalPadding: 12,
                              onPressed: () =>
                                  goTo(context, const CustomerShell()),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: VanqButton(
                              label: 'Driver',
                              style: VanqButtonStyle.secondary,
                              horizontalPadding: 12,
                              onPressed: () =>
                                  goTo(context, const DriverShell()),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: VanqButton(
                              label: 'Admin',
                              style: VanqButtonStyle.secondary,
                              horizontalPadding: 12,
                              onPressed: () =>
                                  goTo(context, const AdminShell()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          },
        ),
      ),
    );
  }
}
