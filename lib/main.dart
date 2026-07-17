import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/services/crashlytics_service.dart';
import 'core/services/firebase_bootstrap.dart';
import 'core/services/messaging_service.dart';
import 'core/storage/hive_service.dart';
import 'core/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // `.env` is optional — a missing file just means every EnvConfig getter
  // returns null and the app runs in local/mock mode (see EnvConfig).
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    appLogger.w('.env not found, continuing without it: $e');
  }

  await HiveService.init();
  await FirebaseBootstrap.init();
  await CrashlyticsService.init();
  await MessagingService.init();
  await configureDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(child: PiggyBankApp()),
    ),
  );
}
