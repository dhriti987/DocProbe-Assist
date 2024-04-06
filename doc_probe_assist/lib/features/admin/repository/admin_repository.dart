import 'package:dio/dio.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';
import 'package:doc_probe_assist/models/user_model.dart';

class AdminRepository {
  final ApiService apiService;
  final String getUsersUrl = '/auth/users/';
  final String updateUserAccessUrl = '/auth/update-user/';
  final String deleteUserUrl = '/auth/delete-user/';

  AdminRepository({
    required this.apiService,
  });

  Future<List<UserModel>> getUsers() async {
    Dio api = apiService.getApi();
    try {
      var response = await api.get(getUsersUrl);

      return UserModel.listFromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<UserModel> updateUserAccess(
      bool isAdmin, bool isActive, int id) async {
    Dio api = apiService.getApi();
    try {
      var response = await api.patch(updateUserAccessUrl + id.toString(),
          data: FormData.fromMap({'is_staff': isAdmin, 'is_active': isActive}));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }

  Future<void> deleteUser(int id) async {
    Dio api = apiService.getApi();
    try {
      await api.delete(deleteUserUrl + id.toString());
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Please try again later.']);
    }
  }
}
