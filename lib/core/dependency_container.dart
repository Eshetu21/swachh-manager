import 'package:get_it/get_it.dart';
import 'package:kabadmanager/features/auth/data/auth_repository.dart';
import 'package:kabadmanager/features/auth/logic/auth_bloc.dart';
import 'package:kabadmanager/services/supabase_rpc_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setUpDependencies() async {
  sl.registerLazySingleton<SupabaseRpcService>(() => SupabaseRpcService());
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(sl<SupabaseRpcService>()));
  sl.registerLazySingleton<AuthBloc>(
      () => AuthBloc(authRepository: sl<AuthRepository>()));
}

