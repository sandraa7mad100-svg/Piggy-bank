import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

const List<String> kChatSuggestions = [
  "What's the difference between needs and wants?",
  'How much have I saved?',
  'Give me my weekly summary',
  'Should I buy this toy?',
  'How can I save faster?',
];

class SuggestionChips extends StatelessWidget {
  const SuggestionChips({super.key, required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: kChatSuggestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final suggestion = kChatSuggestions[i];
          return ActionChip(
            label: Text(suggestion),
            onPressed: () => onSelected(suggestion),
          );
        },
      ),
    );
  }
}
