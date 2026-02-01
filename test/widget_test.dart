import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:writer_profile/main.dart';

void main() {
  testWidgets('App Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SheikhRajPortfolio());

    // Verify that the main title is present on the home screen.
    expect(find.text('শেখ রাজ'), findsOneWidget);

    // Verify that the navigation bar items are present.
    expect(find.text('প্রচ্ছদ'), findsOneWidget);
    expect(find.text('বই'), findsOneWidget);
    expect(find.text('কবিতা'), findsOneWidget);
    expect(find.text('পরিচিতি'), findsOneWidget);
  });
}
