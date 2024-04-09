import 'package:dio/dio.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/services/api_service.dart';
import 'package:doc_probe_assist/models/chat_model.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/models/user_model.dart';

class ChatRepository {
  final ApiService apiService;
  final getDocumentUrl = "/chatbot/doc/?embedded=true";
  final getUserUrl = "/auth/user-info/";
  final chatsURL = '/chatbot/chats/';

  ChatRepository({required this.apiService});

  Future<List<Document>> getDocuments() async {
    Dio api = apiService.getApi();

    try {
      var response = await api.get(getDocumentUrl);
      return Document.listFromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e,
          error: ['Unexpected Error', 'Error fetching documents']);
    }
  }

  Future<UserModel> getUser() async {
    Dio api = apiService.getApi();

    try {
      var response = await api.get(getUserUrl);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException(
          exception: e, error: ['Unexpected Error', 'Error getting User']);
    }
  }

  Future<ChatModel> createChat(int userId, String chatName) async {
    Dio api = apiService.getApi();
    try {
      var response = await api.post(chatsURL,
          data: FormData.fromMap({"user": userId, "name": chatName}));
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      throw ApiException(exception: e, error: ['', '']);
    }
  }

  Future<List<ChatModel>> getAllChats() async {
    Dio api = apiService.getApi();
    try {
      var response = await api.get(chatsURL);
      return ChatModel.listFromJson(response.data);
    } on DioException catch (e) {
      print(e);
      throw ApiException(exception: e, error: ['error', '']);
    }
  }
}
