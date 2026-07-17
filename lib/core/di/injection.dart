import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../../features/ai_chat/data/datasources/ai_chat_local_data_source.dart';
import '../../features/ai_chat/data/providers/ai_provider_factory.dart';
import '../../features/ai_chat/data/repositories/ai_repository_impl.dart';
import '../../features/ai_chat/domain/repositories/ai_repository.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/goals/data/datasources/goals_local_data_source.dart';
import '../../features/goals/data/repositories/goals_repository_impl.dart';
import '../../features/goals/domain/repositories/goals_repository.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/notifications_repository.dart';
import '../../features/transactions/data/datasources/transaction_local_data_source.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../services/analytics_service.dart';
import '../services/firebase_bootstrap.dart';
import '../storage/secure_storage_service.dart';

/// Service locator. Registered once in `main.dart` via [configureDependencies]
/// after Hive/Firebase/dotenv have finished bootstrapping. Riverpod
/// providers pull repositories from here (`getIt<AuthRepository>()`) so
/// business logic stays framework-agnostic and easy to unit test by
/// registering fakes in [GetIt] instead.
final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(() => DioClient());
  getIt.registerLazySingleton(() => SecureStorageService());
  getIt.registerLazySingleton(() => AnalyticsService());

  // Auth
  getIt.registerLazySingleton(() => AuthLocalDataSource(getIt()));
  if (FirebaseBootstrap.isAvailable) {
    getIt.registerLazySingleton(() => AuthRemoteDataSource());
  }
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: getIt(),
      remoteDataSource: FirebaseBootstrap.isAvailable ? getIt() : null,
    ),
  );
  getIt.registerLazySingleton(() => SignInWithEmail(getIt()));
  getIt.registerLazySingleton(() => SignUpWithEmail(getIt()));
  getIt.registerLazySingleton(() => SignInWithGoogle(getIt()));
  getIt.registerLazySingleton(() => SignInAsChild(getIt()));
  getIt.registerLazySingleton(() => SignOut(getIt()));
  getIt.registerLazySingleton(() => SendPasswordResetEmail(getIt()));

  // Transactions (spending & income tracker)
  getIt.registerLazySingleton(() => TransactionLocalDataSource());
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(getIt()),
  );

  // Savings goals
  getIt.registerLazySingleton(() => GoalsLocalDataSource());
  getIt.registerLazySingleton<GoalsRepository>(() => GoalsRepositoryImpl(getIt()));

  // Notifications
  getIt.registerLazySingleton<NotificationsRepository>(() => NotificationsRepositoryImpl());

  // AI Assistant
  getIt.registerLazySingleton(() => AiChatLocalDataSource());
  getIt.registerLazySingleton(() => AiProviderFactory.create());
  getIt.registerLazySingleton<AiRepository>(
    () => AiRepositoryImpl(provider: getIt(), localDataSource: getIt()),
  );
}
