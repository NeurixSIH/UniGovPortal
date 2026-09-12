import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:citizen_connect/core/state/app_state_provider.dart';
import 'package:citizen_connect/main.dart';

void main() {
  testWidgets('Mobile back button navigates previous tab and previous subview', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final provider = AppStateProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
        ],
        child: const SetuApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. We are initially on Citizen Dashboard (Tab 0)
    expect(find.text('Citizen Services Dashboard'), findsOneWidget);

    // 2. Switch to 'My Applications' (Tab 2)
    final myAppsTab = find.text('My Applications');
    expect(myAppsTab, findsOneWidget);
    await tester.tap(myAppsTab);
    await tester.pumpAndSettle();
    expect(find.text('My Application History & Records'), findsOneWidget);

    // 3. Header now has a visible back button
    final backBtn = find.byTooltip('Back');
    expect(backBtn, findsOneWidget);

    // 4. Tap the in-app back button or invoke back navigation
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    // 5. We should be back on Citizen Dashboard (Tab 0) instead of exiting!
    expect(find.text('Citizen Services Dashboard'), findsOneWidget);

    // 6. Navigate into a subview: tap 'Browse Public Catalog'
    final browseCatalog = find.text('Browse Public Catalog');
    if (browseCatalog.evaluate().isNotEmpty) {
      await tester.tap(browseCatalog);
      await tester.pumpAndSettle();
      expect(find.text('Public Service Catalog'), findsOneWidget);

      // Tap back button
      final backBtn2 = find.byTooltip('Back');
      expect(backBtn2, findsOneWidget);
      await tester.tap(backBtn2);
      await tester.pumpAndSettle();

      // Should return to Citizen Dashboard
      expect(find.text('Citizen Services Dashboard'), findsOneWidget);
    }
  });
}
