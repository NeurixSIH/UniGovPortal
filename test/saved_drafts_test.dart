import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:citizen_connect/core/models/application_model.dart';
import 'package:citizen_connect/core/models/application_status.dart';
import 'package:citizen_connect/core/state/app_state_provider.dart';
import 'package:citizen_connect/features/citizen/drafts/saved_drafts_screen.dart';

void main() {
  group('Saved Drafts AppStateProvider Tests', () {
    test('draftApplications and draftApplicationsCount return correct values', () {
      final state = AppStateProvider();
      expect(state.draftApplicationsCount, greaterThanOrEqualTo(1));
      final drafts = state.draftApplications;
      expect(drafts.every((d) => d.status == AppStatus.draft), isTrue);
    });

    test('saveDraftApplication adds a new draft to state', () {
      final state = AppStateProvider();
      final initialCount = state.draftApplicationsCount;

      final now = DateTime.now();
      final newDraft = ApplicationModel(
        id: 'APP-DRAFT-TEST-999',
        serviceId: 'srv_income_certificate',
        serviceName: 'Income Certificate',
        departmentId: 'dept_revenue',
        departmentName: 'Revenue & Land Records',
        citizenId: 'MH123456789',
        citizenName: 'Rajesh Kumar Sharma',
        citizenAadhaar: 'XXXX-XXXX-4321',
        citizenPhone: '+91 98765 43210',
        citizenEmail: 'rajesh.sharma@example.gov.in',
        citizenAddress: 'Flat 402, Shanti Heights, Pune, Maharashtra 411001',
        status: AppStatus.draft,
        submissionDate: now,
        lastUpdated: now,
        formData: {'purpose': 'Higher education scholarship application'},
        documents: const [],
        timeline: const [],
      );

      state.saveDraftApplication(newDraft);
      expect(state.draftApplicationsCount, equals(initialCount + 1));
      expect(state.applications.any((a) => a.id == 'APP-DRAFT-TEST-999'), isTrue);
    });

    test('deleteDraftApplication removes draft from state', () {
      final state = AppStateProvider();
      final draft = state.draftApplications.first;
      final initialCount = state.draftApplicationsCount;

      state.deleteDraftApplication(draft.id);
      expect(state.draftApplicationsCount, equals(initialCount - 1));
      expect(state.applications.any((a) => a.id == draft.id), isFalse);
    });
  });

  group('SavedDraftsScreen Widget Tests', () {
    testWidgets('renders draft list with Resume Draft and Delete Draft buttons', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = AppStateProvider();
      String? resumedServiceId;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: state),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SavedDraftsScreen(
                onBack: () {},
                onResumeDraft: (id) => resumedServiceId = id,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header title
      expect(find.text('Saved Drafts'), findsAtLeastNWidgets(1));
      expect(find.text('+ Save New Draft'), findsOneWidget);

      // Check draft item is rendered
      expect(find.text('Resume Draft'), findsAtLeastNWidgets(1));
      expect(find.byTooltip('Delete Draft'), findsAtLeastNWidgets(1));

      // Test tapping Resume Draft
      await tester.tap(find.text('Resume Draft').first);
      await tester.pumpAndSettle();
      expect(resumedServiceId, isNotNull);
    });

    testWidgets('opens save new draft modal on button tap', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final state = AppStateProvider();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: state),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SavedDraftsScreen(
                onBack: () {},
                onResumeDraft: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap + Save New Draft
      await tester.tap(find.text('+ Save New Draft'));
      await tester.pumpAndSettle();

      // Modal dialog appears
      expect(find.text('Save New Draft'), findsOneWidget);
      expect(find.text('Select Service'), findsOneWidget);
      expect(find.text('Save Draft'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Save New Draft'), findsNothing);
    });
  });
}
