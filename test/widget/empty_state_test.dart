import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/core/widgets/empty_state.dart';

void main() {
  testWidgets('renders title, message, and optional action', (tester) async {
    var actionTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            icon: Icons.flag_rounded,
            title: 'No goals yet',
            message: 'Create your first goal.',
            actionLabel: 'Add goal',
            onAction: () => actionTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('No goals yet'), findsOneWidget);
    expect(find.text('Create your first goal.'), findsOneWidget);
    expect(find.text('Add goal'), findsOneWidget);

    await tester.tap(find.text('Add goal'));
    await tester.pump();
    expect(actionTapped, isTrue);
  });

  testWidgets('omits the action button when none is provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(icon: Icons.flag_rounded, title: 'Empty', message: 'Nothing here.'),
        ),
      ),
    );

    expect(find.byType(TextButton), findsNothing);
  });
}
