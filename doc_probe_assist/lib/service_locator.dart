import 'package:doc_probe_assist/core/router/router.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';
import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/features/chat/bloc/chat_bloc.dart';
import 'package:doc_probe_assist/features/home/bloc/home_bloc.dart';
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
}
