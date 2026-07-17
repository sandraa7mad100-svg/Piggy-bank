import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;
    if (!ok) {
      final error = ref.read(authControllerProvider).error;
      context.showSnackBar(error ?? 'Could not sign in.', isError: true);
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      context.showSnackBar('Enter your email above first.', isError: true);
      return;
    }
    final ok = await ref.read(authControllerProvider.notifier).resetPassword(_emailController.text.trim());
    if (!mounted) return;
    context.showSnackBar(
      ok ? 'Password reset email sent.' : (ref.read(authControllerProvider).error ?? 'Could not send email.'),
      isError: !ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                child: const Icon(Icons.savings_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Welcome back!', style: context.textTheme.displayMedium),
              const SizedBox(height: AppSpacing.xs),
              Text('Sign in to keep growing your savings.', style: context.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: Validators.email(),
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: true,
                prefixIcon: Icons.lock_outline_rounded,
                validator: Validators.required('Enter your password'),
                autofillHints: const [AutofillHints.password],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: _forgotPassword, child: const Text('Forgot password?')),
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(label: 'Sign in', isLoading: state.isSubmitting, onPressed: _submit),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm), child: Text('or')),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                label: const Text('Continue with Google'),
                onPressed: state.isSubmitting
                    ? null
                    : () async {
                        final ok = await ref.read(authControllerProvider.notifier).signInWithGoogle();
                        if (!mounted) return;
                        if (!ok) {
                          context.showSnackBar(
                            ref.read(authControllerProvider).error ?? 'Google sign-in failed.',
                            isError: true,
                          );
                        }
                      },
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                icon: const Icon(Icons.child_care_rounded),
                label: const Text('Continue in Kid Mode'),
                onPressed: () => context.push(RouteNames.childMode),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () => context.push(RouteNames.signup),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
