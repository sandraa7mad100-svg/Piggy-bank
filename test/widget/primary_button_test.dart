import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/core/widgets/primary_button.dart';

void main() {
  testWidgets('shows label and calls onPressed when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Save', onPressed: () => tapped = true),
        ),
      ),
    );

    expect(find.text('Save'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('shows a spinner instead of the label while loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Save', isLoading: true, onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Save'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('does not call onPressed while loading', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Save', isLoading: true, onPressed: () => tapped = true),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
    await tester.pump();
    expect(tapped, isFalse);
  });
}
