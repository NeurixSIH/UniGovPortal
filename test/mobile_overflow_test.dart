import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:citizen_connect/core/state/app_state_provider.dart';
import 'package:citizen_connect/core/models/application_model.dart';
import 'package:citizen_connect/core/models/service_model.dart';
import 'package:citizen_connect/main.dart';
import 'package:citizen_connect/features/citizen/citizen_dashboard_screen.dart';
import 'package:citizen_connect/features/citizen/application_wizard/application_wizard_screen.dart';
import 'package:citizen_connect/features/citizen/history/application_history_screen.dart';
import 'package:citizen_connect/features/citizen/profile/citizen_profile_screen.dart';
import 'package:citizen_connect/features/citizen/notifications/notifications_screen.dart';
import 'package:citizen_connect/features/citizen/tracking/application_tracking_screen.dart';
import 'package:citizen_connect/features/citizen/tracking/info_required_screen.dart';
import 'package:citizen_connect/features/officer/officer_dashboard_screen.dart';
import 'package:citizen_connect/features/officer/officer_queue_screen.dart';
import 'package:citizen_connect/features/officer/officer_review_screen.dart';
import 'package:citizen_connect/features/admin/admin_dashboard_screen.dart';
import 'package:citizen_connect/features/admin/officer_management_screen.dart';

Widget createTestWidget(Widget child, [AppStateProvider? provider]) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => provider ?? AppStateProvider()),
    ],
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  final provider = AppStateProvider();
  final ServiceModel dummyService = provider.services.first;
  final ApplicationModel dummyApp = provider.applications.first;

  const mobileSizes = [
    Size(360, 780), // Compact Android (e.g. Motorola Edge 50 / standard mobile)
    Size(390, 844), // iPhone 14/15/16 standard
  ];

  for (final size in mobileSizes) {
    group('Mobile layout overflow test at ${size.width.toInt()}x${size.height.toInt()}', () {
      testWidgets('SetuApp root renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) => caughtDetails = details;

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AppStateProvider()),
            ],
            child: const SetuApp(),
          ),
        );
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('EXACT ERROR IN SETU APP ROOT:\n${caughtDetails?.summary}');
          debugPrint('LINE:\n${caughtDetails.toString()}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('CitizenDashboardScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) {
          caughtDetails = details;
        };

        await tester.pumpWidget(createTestWidget(CitizenDashboardScreen(
          onOpenApplication: (_) {},
          onApplyService: (_) {},
          onBrowseAllServices: () {},
          onViewAllApplications: () {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('EXACT ERROR IN CITIZEN DASHBOARD:\n${caughtDetails?.summary}');
          debugPrint('LINE: ${caughtDetails?.toString()}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('ApplicationWizardScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(createTestWidget(ApplicationWizardScreen(
          service: dummyService,
          onCancel: () {},
          onSubmittedSuccess: (_) {},
        )));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('OfficerDashboardScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) {
          caughtDetails = details;
        };

        await tester.pumpWidget(createTestWidget(OfficerDashboardScreen(
          onOpenQueue: () {},
          onReviewApplication: (_) {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('EXACT ERROR IN OFFICER DASHBOARD:\n${caughtDetails?.summary}');
          debugPrint('LINE: ${caughtDetails?.toString()}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('OfficerQueueScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) {
          caughtDetails = details;
        };

        await tester.pumpWidget(createTestWidget(OfficerQueueScreen(
          onReviewApplication: (_) {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('EXACT ERROR IN OFFICER QUEUE:\n${caughtDetails?.summary}');
          debugPrint('LINE: ${caughtDetails?.toString()}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('OfficerReviewScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) {
          caughtDetails = details;
        };

        await tester.pumpWidget(createTestWidget(OfficerReviewScreen(
          application: dummyApp,
          onBack: () {},
          onActionCompleted: () {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('EXACT ERROR SUMMARY:\n${caughtDetails?.summary}');
          debugPrint('EXACT EXCEPTION:\n${caughtDetails?.exception.toString().split("\n").take(5).join("\n")}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('AdminDashboardScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) {
          caughtDetails = details;
        };

        await tester.pumpWidget(createTestWidget(AdminDashboardScreen(
          onManageOfficers: () {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('FULL DETAILED ERROR IN ADMIN DASHBOARD:\n${caughtDetails.toString()}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('OfficerManagementScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(createTestWidget(const OfficerManagementScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('InfoRequiredScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) {
          caughtDetails = details;
        };

        await tester.pumpWidget(createTestWidget(InfoRequiredScreen(
          application: dummyApp,
          onBack: () {},
          onResolved: () {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('FULL DETAILED ERROR:\n${caughtDetails.toString()}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('ApplicationHistoryScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) => caughtDetails = details;

        await tester.pumpWidget(createTestWidget(ApplicationHistoryScreen(
          onSelectApplication: (_) {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('ERROR IN APPLICATION HISTORY:\n${caughtDetails?.summary}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('CitizenProfileScreen renders without overflow across tabs', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) => caughtDetails = details;

        await tester.pumpWidget(createTestWidget(CitizenProfileScreen(
          onLogout: () {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('ERROR IN CITIZEN PROFILE:\n${caughtDetails?.summary}');
        }
        expect(caughtDetails, isNull);

        // Tap Language Tab
        final languageTab = find.text(size.width < 600 ? 'Language' : 'Language (ભાષા / भाषा)');
        if (languageTab.evaluate().isNotEmpty) {
          await tester.tap(languageTab, warnIfMissed: false);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        // Tap Consent Tab
        final consentTab = find.text(size.width < 600 ? 'Consent' : 'Consent & Privacy');
        if (consentTab.evaluate().isNotEmpty) {
          await tester.tap(consentTab, warnIfMissed: false);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      });

      testWidgets('NotificationsScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) => caughtDetails = details;

        await tester.pumpWidget(createTestWidget(NotificationsScreen(
          onOpenApplication: (_) {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('ERROR IN NOTIFICATIONS:\n${caughtDetails?.summary}');
        }
        expect(caughtDetails, isNull);
      });

      testWidgets('ApplicationTrackingScreen renders without overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        FlutterErrorDetails? caughtDetails;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) => caughtDetails = details;

        await tester.pumpWidget(createTestWidget(ApplicationTrackingScreen(
          application: dummyApp,
          onResolveRequired: () {},
          onViewCertificate: () {},
          onViewRejection: () {},
          onBack: () {},
        )));
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        if (caughtDetails != null) {
          debugPrint('ERROR IN APPLICATION TRACKING:\n${caughtDetails?.summary}');
        }
        expect(caughtDetails, isNull);
      });
    });
  }
}
