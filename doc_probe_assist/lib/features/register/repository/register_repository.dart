import 'package:dio/dio.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';

class RegisterRepository {
  final ApiService apiService;
  final registerURL = "/auth/register/";
  RegisterRepository({required this.apiService});

  Future<void> register(
      String name, String empID, String email, String password) async {
    final api = apiService.getApiWithoutHeader();
    FormData data = FormData.fromMap({
      "name": name,
      "email": email,
      "username": empID,
      "password": password
    });
    try {
      await api.post(registerURL, data: data);
    } on DioException catch (e) {
      print(e.response);
      throw ApiException(exception: e, error: [
        "Unexpected error",
        (e.response?.data as Map<String, dynamic>)
            .values
            .map((e) => e[0])
            .join('\n')
      ]);
      // print(e.response?.data);
    }
  }
}
