import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/hive_boxes.dart';

Box get _settingsBox => Hive.box(HiveBoxes.appSettings);

class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(_readInitial());

  static ThemeMode _readInitial() {
    final stored = _settingsBox.get(AppConstants.prefThemeMode) as String?;
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _settingsBox.put(AppConstants.prefThemeMode, mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>((ref) => ThemeModeController());

class NotificationsPrefController extends StateNotifier<bool> {
  NotificationsPrefController() : super(_settingsBox.get('notifications_enabled', defaultValue: true) as bool);

  Future<void> toggle(bool value) async {
    state = value;
    await _settingsBox.put('notifications_enabled', value);
  }
}

final notificationsPrefProvider =
    StateNotifierProvider<NotificationsPrefController, bool>((ref) => NotificationsPrefController());
