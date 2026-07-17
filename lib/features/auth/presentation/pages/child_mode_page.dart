import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

/// "Kid mode" — anonymous auth with just a first name, no email/password,
/// so a child can start using the app on a shared/parent device without
/// creating a full account. Parent-only screens (export, delete account)
/// are hidden for these sessions — see `UserEntity.isChildMode`.
class ChildModePage extends ConsumerStatefulWidget {
  const ChildModePage({super.key});

  @override
  ConsumerState<ChildModePage> createState() => _ChildModePageState();
}

class _ChildModePageState extends ConsumerState<ChildModePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier).continueAsChild(
          displayName: _nameController.text.trim(),
        );
    if (!mounted) return;
    if (!ok) {
      context.showSnackBar(ref.read(authControllerProvider).error ?? 'Could not start Kid Mode.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kid Mode')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(gradient: AppColors.coinGradient, shape: BoxShape.circle),
                child: const Icon(Icons.child_care_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Hi there!', style: context.textTheme.displayMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "What's your name? No email or password needed — just start saving!",
                style: context.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'Your name',
                controller: _nameController,
                prefixIcon: Icons.badge_outlined,
                validator: Validators.displayName(),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: "Let's go!",
                isLoading: state.isSubmitting,
                color: AppColors.accentYellowDark,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
