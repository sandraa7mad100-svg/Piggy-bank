// End-to-end smoke test. Boots the real app the same way `main.dart` does
// (Hive, dotenv, Firebase bootstrap, DI, EasyLocalization) and checks that
// the very first screen the user sees renders.
//
// Requires a connected device or emulator:
//   flutter test integration_test/app_test.dart -d <device-id>
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:piggy_bank/app.dart';
import 'package:piggy_bank/core/di/injection.dart';
import 'package:piggy_bank/core/services/firebase_bootstrap.dart';
import 'package:piggy_bank/core/storage/hive_service.dart';

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots to the splash screen and then onboarding/login', (tester) async {
    await EasyLocalization.ensureInitialized();
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // .env is optional — see EnvConfig.
    }
    await HiveService.init();
    await FirebaseBootstrap.init();
    await configureDependencies();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const ProviderScope(child: PiggyBankApp()),
      ),
    );

    // Splash screen shows immediately.
    expect(find.text('Piggy Bank'), findsOneWidget);

    // Wait out the splash's minimum duration + redirect.
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // We should have moved off the splash screen to either onboarding or
    // the login screen (first run has no seen-onboarding flag yet).
    expect(find.text('Piggy Bank'), findsNothing);
  });
}
