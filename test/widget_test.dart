// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:aqran/main.dart';

void main() {
  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AqranApp());

    // Verify that our welcome screen displays the app name in Arabic
    expect(find.text('أقران'), findsOneWidget);
    
    // Verify that the start button text is present
    expect(find.text(' بدء'), findsOneWidget);
  });
}
