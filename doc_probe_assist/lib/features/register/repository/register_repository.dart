import 'package:dio/dio.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';

class RegisterRepository {
  final ApiService apiService;
  final registerURL = "/auth/register/";
  RegisterRepository({required this.apiService});

  Future<void> register(
      String name, String empID, String email, String password) async {
    final api = apiService.getApi();
    FormData data = FormData.fromMap({
      "name": name,
      "email": email,
      "username": empID,
      "password": password
    });
    try {
      await api.post(registerURL, data: data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ["Unexpected error", "Please try again later."]);
      // print(e.response?.data);
    }
  }
}
