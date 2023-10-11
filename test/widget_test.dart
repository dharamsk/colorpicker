import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:colorpicker/main.dart'; // Adjust the import path to your app

void main() {
  testWidgets('Tapping a color panel regenerates colors',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Get initial title
    String initialTitle = (tester.widget(find.byType(Text)) as Text).data ?? '';

    // Tap the first color panel
    final firstPanel = find.byType(Container).first;
    await tester.tap(firstPanel);

    // Rebuild the widget after the state change
    await tester.pump();

    // Get the title after tap
    String newTitle = (tester.widget(find.byType(Text)) as Text).data ?? '';

    // Check if the titles are different
    expect(initialTitle, isNot(equals(newTitle)));
  });

  testWidgets('Generates four color panels', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check if four color panels are present
    final panels = find.byType(Container);
    expect(panels, findsNWidgets(4));
  });

  testWidgets('Tapping a color panel regenerates colors',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Get the initial title
    final initialTitle = (tester.widget(find.byType(Text)) as Text).data;

    // Tap the first color panel
    final firstPanel = find.byType(Container).first;
    await tester.tap(firstPanel);

    // Manually advance the clock by the duration of the delay
    await tester.pump(const Duration(milliseconds: 800));

    // Get the new title
    final newTitle = (tester.widget(find.byType(Text)) as Text).data;

    // Check if the titles are different
    expect(initialTitle, isNot(equals(newTitle)));
  });
}
