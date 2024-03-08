import 'package:dio/dio.dart';

class ApiException implements Exception {
  final DioException exception;
  final List<String> error;

  ApiException({required this.exception, required this.error});
  List<String> call() {
    switch (exception.type) {
      case DioExceptionType.connectionError:
        return [
          "Conectivity Error",
          "Could not Connect to the Server, Please Check Your Internet Connection."
        ];
      default:
        return error;
    }
  }
}
