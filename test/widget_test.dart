// Basic smoke test of the design-token layer (colors/spacing/radii).
// AppTheme.light()/dark() aren't exercised here because building them
// eagerly resolves Google Fonts, which needs real network access the
// first time — that's covered instead by widget tests that pump actual
// screens (see test/widget/), where Flutter's test harness handles font
// loading gracefully. Full end-to-end app boot (Hive, Firebase, dotenv)
// is exercised by integration_test/app_test.dart on a real device/
// emulator — see README > Testing.
import 'package:flutter_test/flutter_test.dart';
import 'package:piggy_bank/core/theme/app_colors.dart';
import 'package:piggy_bank/core/theme/app_spacing.dart';

void main() {
  test('brand primary color is defined and opaque', () {
    expect(AppColors.primary.a, 1.0);
    expect(AppColors.primary, isNot(AppColors.secondary));
  });

  test('category palette has enough distinct colors for the chart legend', () {
    expect(AppColors.categoryPalette.length, greaterThanOrEqualTo(8));
    expect(AppColors.categoryPalette.toSet().length, AppColors.categoryPalette.length);
  });

  test('spacing scale is strictly increasing', () {
    final scale = [AppSpacing.xs, AppSpacing.sm, AppSpacing.md, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxl];
    for (var i = 1; i < scale.length; i++) {
      expect(scale[i], greaterThan(scale[i - 1]));
    }
  });

  test('AppRadii.pill is large enough to fully round a normal button height', () {
    expect(AppRadii.pill, greaterThan(100));
  });
}
