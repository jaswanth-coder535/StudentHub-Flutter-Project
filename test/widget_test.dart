import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_hub/main.dart';
import 'package:student_hub/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService().init();
  });

  testWidgets('Student Hub app launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentHubApp());
    expect(find.text('Student Hub'), findsWidgets);

    // Settle splash timer
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
