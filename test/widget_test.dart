import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:citizen_connect/core/state/app_state_provider.dart';
import 'package:citizen_connect/main.dart';

void main() {
  testWidgets('CitizenConnect app smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ],
        child: const SetuApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify app renders with Setu branding
    expect(find.textContaining('SETU'), findsWidgets);
  });
}
