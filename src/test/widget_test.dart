import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vanq/main.dart';

void main() {
  // Tests can't reach the internet, so don't try to download Inter.
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> openApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const VanqApp());
    await tester.pumpAndSettle();
  }

  testWidgets('UI-01 Login shows the welcome text and demo roles', (tester) async {
    await openApp(tester);

    expect(find.text('Welcome to VanQ'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Driver'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
  });

  testWidgets('Customer demo button opens UI-02 Home', (tester) async {
    await openApp(tester);

    await tester.tap(find.text('Customer'));
    await tester.pumpAndSettle();

    expect(find.text('Where to next?'), findsOneWidget);
    expect(find.text('Available vans'), findsOneWidget);
  });

  testWidgets('Driver demo button opens UI-07 Trip schedule', (tester) async {
    await openApp(tester);

    await tester.tap(find.text('Driver'));
    await tester.pumpAndSettle();

    expect(find.text('My trips'), findsOneWidget);
  });

  testWidgets('Admin demo button opens UI-08 Dashboard', (tester) async {
    await openApp(tester);

    await tester.tap(find.text('Admin'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
  });
}
