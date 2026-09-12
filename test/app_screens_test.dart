import 'package:flutter_test/flutter_test.dart';
import 'package:uni_gov_portal/main.dart';
import 'package:uni_gov_portal/data/demo_repository.dart';

void main() {
  testWidgets('UniGovApp boots and renders smartphone frame with Citizen Dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const UniGovApp());
    await tester.pumpAndSettle();

    // Verify status bar 9:41
    expect(find.text('9:41'), findsOneWidget);

    // Verify presentation header
    expect(find.textContaining('SIH26129'), findsOneWidget);

    // Verify Citizen Dashboard components
    expect(find.textContaining('Good Morning, Krisha'), findsOneWidget);
    expect(find.text('ONE LOGIN  ➜  MULTIPLE GOVERNMENT SERVICES'), findsOneWidget);
    expect(find.text('80% Complete'), findsOneWidget);

    // Verify Role Switching to Department Admin
    final repo = DemoRepository();
    repo.setActiveRole('departmentAdmin');
    await tester.pumpWidget(const UniGovApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Revenue Department'), findsWidgets);
    expect(find.textContaining('Sanjay Deshmukh'), findsWidgets);

    // Verify Role Switching to System Admin
    repo.setActiveRole('systemAdmin');
    await tester.pumpWidget(const UniGovApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('System Admin Console'), findsWidgets);
    expect(find.textContaining('State Interoperability Directory'), findsWidgets);

    // Reset back to citizen
    repo.setActiveRole('citizen');
    await tester.pumpWidget(const UniGovApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('Good Morning, Krisha'), findsOneWidget);
  });
}
