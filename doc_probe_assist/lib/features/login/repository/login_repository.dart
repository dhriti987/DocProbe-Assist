import 'package:dio/dio.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/router/router.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final SharedPreferences sharedPreferences;
  final ApiService apiService;
  final AppRouter appRouter;
  final loginURL = "/auth/login/";

  LoginRepository(
      {required this.sharedPreferences,
      required this.apiService,
      required this.appRouter});

  Future<void> login(String empId, String password) async {
    Dio api = apiService.getApiWithoutHeader();
    try {
      var response = await api.post(loginURL,
          data: FormData.fromMap({'username': empId, 'password': password}));
      await sharedPreferences.setString("token", response.data['token']);
      appRouter.isAuthenticated = true;
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ["Login Failed", e.response?.data['error']]);
    }
  }

  Future<void> logout() async {
    await sharedPreferences.clear();
    appRouter.isAuthenticated = false;
  }
}
