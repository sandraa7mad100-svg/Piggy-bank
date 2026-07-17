import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/transaction_provider.dart';
import '../utils/category_ui.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  TransactionCategory _category = TransactionCategory.toys;
  DateTime _date = DateTime.now();
  bool _isNeed = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<TransactionCategory> get _availableCategories =>
      _type.isIncome ? TransactionTypeUi.incomeCategories : TransactionTypeUi.expenseCategories;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(transactionFormControllerProvider.notifier).addTransaction(
          title: _titleController.text.trim(),
          amount: double.parse(_amountController.text.trim()),
          type: _type,
          category: _category,
          date: _date,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          isNeed: _isNeed,
        );
    if (!mounted) return;
    if (ok) {
      HapticFeedback.mediumImpact();
      context.showSnackBar('${_type.isIncome ? 'Income' : 'Purchase'} added!');
      Navigator.of(context).pop();
    } else {
      final error = ref.read(transactionFormControllerProvider).error;
      context.showSnackBar(error ?? 'Could not save. Please try again.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(transactionFormControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add transaction')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(value: TransactionType.expense, label: Text('Spent'), icon: Icon(Icons.arrow_upward_rounded)),
                  ButtonSegment(value: TransactionType.income, label: Text('Received'), icon: Icon(Icons.arrow_downward_rounded)),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() {
                  _type = s.first;
                  _category = _availableCategories.first;
                }),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'What was it for?',
                controller: _titleController,
                validator: Validators.required('Give it a short title'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Amount',
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.attach_money_rounded,
                validator: Validators.amount(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Category', style: context.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final c in _availableCategories)
                    ChoiceChip(
                      avatar: Icon(c.icon, size: 18, color: _category == c ? Colors.white : c.color),
                      label: Text(c.label),
                      selected: _category == c,
                      selectedColor: c.color,
                      labelStyle: TextStyle(color: _category == c ? Colors.white : null),
                      onSelected: (_) => setState(() => _category = c),
                    ),
                ],
              ),
              if (!_type.isIncome) ...[
                const SizedBox(height: AppSpacing.lg),
                Text('Was this a need or a want?', style: context.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Needs keep you safe, healthy, or learning. Wants are just for fun.',
                  style: context.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _NeedWantCard(
                        label: 'Need',
                        color: AppColors.needs,
                        selected: _isNeed,
                        onTap: () => setState(() => _isNeed = true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _NeedWantCard(
                        label: 'Want',
                        color: AppColors.wants,
                        selected: !_isNeed,
                        onTap: () => setState(() => _isNeed = false),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_rounded),
                title: const Text('Date'),
                trailing: Text('${_date.month}/${_date.day}/${_date.year}'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Note (optional)', controller: _noteController),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Save', isLoading: formState.isSubmitting, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeedWantCard extends StatelessWidget {
  const _NeedWantCard({required this.label, required this.color, required this.selected, required this.onTap});

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.15) : Colors.transparent,
          border: Border.all(color: selected ? color : AppColors.borderLight, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: selected ? color : null, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
