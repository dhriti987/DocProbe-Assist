import 'package:doc_probe_assist/core/router/router.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';
import 'package:doc_probe_assist/features/about_us/bloc/about_bloc.dart';
import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/features/admin/repository/admin_repository.dart';
import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/features/chat/repository/chat_repository.dart';
import 'package:doc_probe_assist/features/home/bloc/home_bloc.dart';
import 'package:doc_probe_assist/features/login/bloc/login_bloc.dart';
import 'package:doc_probe_assist/features/login/repository/login_repository.dart';
import 'package:doc_probe_assist/features/register/bloc/register_bloc.dart';
import 'package:doc_probe_assist/features/register/repository/register_repository.dart';
import 'package:doc_probe_assist/features/settings/bloc/setting_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

void setup() {
  sl.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
  sl.registerSingletonWithDependencies<ApiService>(() => ApiService(pref: sl()),
      dependsOn: [SharedPreferences]);
  sl.registerSingletonWithDependencies<AppRouter>(() => AppRouter(pref: sl()),
      dependsOn: [SharedPreferences]);

  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => ChatBloc());
  sl.registerFactory(() => SettingBloc());
  sl.registerFactory(() => AdminBloc());
  sl.registerFactory(() => LoginBloc());
  sl.registerFactory(() => AboutBloc());
  sl.registerFactory(() => RegisterBloc());

  sl.registerSingletonWithDependencies<LoginRepository>(
      () => LoginRepository(
          apiService: sl(), sharedPreferences: sl(), appRouter: sl()),
      dependsOn: [ApiService, SharedPreferences, AppRouter]);
  sl.registerSingletonWithDependencies<ChatRepository>(
      () => ChatRepository(apiService: sl()),
      dependsOn: [ApiService]);
  sl.registerSingletonWithDependencies<AdminRepository>(
      () => AdminRepository(apiService: sl()),
      dependsOn: [ApiService]);
  sl.registerSingletonWithDependencies<RegisterRepository>(
      () => RegisterRepository(apiService: sl()),
      dependsOn: [ApiService]);
}
