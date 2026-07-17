import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final notificationsEnabled = ref.watch(notificationsPrefProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (user != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: Text(user.displayName),
                subtitle: Text(user.isChildMode ? 'Kid Mode account' : user.email),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(RouteNames.profile),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Text('Appearance', style: context.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System default'),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (v) => ref.read(themeModeProvider.notifier).setThemeMode(v!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (v) => ref.read(themeModeProvider.notifier).setThemeMode(v!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (v) => ref.read(themeModeProvider.notifier).setThemeMode(v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Language', style: context.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                for (final locale in context.supportedLocales)
                  RadioListTile<Locale>(
                    title: Text(locale.languageCode == 'ar' ? 'العربية' : 'English'),
                    value: locale,
                    groupValue: context.locale,
                    onChanged: (v) {
                      if (v != null) context.setLocale(v);
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Notifications', style: context.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: SwitchListTile(
              title: const Text('Push notifications'),
              subtitle: const Text('Milestones, reminders, and achievements'),
              value: notificationsEnabled,
              onChanged: (v) => ref.read(notificationsPrefProvider.notifier).toggle(v),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Sign out'),
              onTap: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) context.go(RouteNames.login);
              },
            ),
          ),
        ],
      ),
    );
  }
}
