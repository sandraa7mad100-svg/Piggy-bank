import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/hive_boxes.dart';

Box get _settingsBox => Hive.box(HiveBoxes.appSettings);

bool hasSeenOnboarding() => _settingsBox.get(AppConstants.prefHasSeenOnboarding, defaultValue: false) as bool;

Future<void> markOnboardingSeen() => _settingsBox.put(AppConstants.prefHasSeenOnboarding, true);

/// Exposed as a provider (rather than read directly) so widgets rebuild if
/// it's ever invalidated after being set from the onboarding flow.
final hasSeenOnboardingProvider = Provider<bool>((ref) => hasSeenOnboarding());
