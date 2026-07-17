import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
    if (!mounted) return;
    if (!ok) {
      context.showSnackBar(ref.read(authControllerProvider).error ?? 'Could not sign up.', isError: true);
    }
    // On success we don't navigate manually — GoRouter's redirect reacts
    // to the auth state change and takes over (see app_router.dart), the
    // same way Kid Mode and Google sign-in already work.
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('A parent or guardian sets this account up', style: context.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Full name',
                controller: _nameController,
                prefixIcon: Icons.person_outline_rounded,
                validator: Validators.displayName(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: Validators.email(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: true,
                prefixIcon: Icons.lock_outline_rounded,
                validator: Validators.password(),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Confirm password',
                controller: _confirmController,
                obscureText: true,
                prefixIcon: Icons.lock_outline_rounded,
                validator: Validators.confirmPassword(() => _passwordController.text),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'Create account', isLoading: state.isSubmitting, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
