import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/goals_provider.dart';

const _goalColors = [
  AppColors.primary,
  AppColors.secondary,
  AppColors.accentYellow,
  AppColors.accentPurple,
  AppColors.accentBlue,
];

class AddGoalPage extends ConsumerStatefulWidget {
  const AddGoalPage({super.key});

  @override
  ConsumerState<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends ConsumerState<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  Color _color = AppColors.primary;

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(goalsControllerProvider.notifier).createGoal(
          title: _titleController.text.trim(),
          targetAmount: double.parse(_targetController.text.trim()),
          colorValue: _color.toARGB32(),
        );
    if (!mounted) return;
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(goalsControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('New savings goal')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppTextField(
              label: 'What are you saving for?',
              controller: _titleController,
              validator: Validators.required('Give your goal a name'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Target amount',
              controller: _targetController,
              prefixIcon: Icons.flag_rounded,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: Validators.amount(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Pick a color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final c in _goalColors)
                  InkWell(
                    onTap: () => setState(() => _color = c),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: _color == c ? Border.all(color: Colors.black26, width: 3) : null,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Create goal',
              isLoading: state.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
