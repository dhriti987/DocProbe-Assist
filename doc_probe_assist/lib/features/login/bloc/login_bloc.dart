import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/utils/validators.dart';
import 'package:doc_probe_assist/features/login/repository/login_repository.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final loginRepository = sl.get<LoginRepository>();

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoginButtonClickedEvent>(onLoginButtonClickedEvent);
  }

  FutureOr<void> onLoginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<LoginState> emit) async {
    if (!validateStringLength(event.empId, max: 50) ||
        !validateStringLength(event.password, max: 50)) {
      emit(LoginFailed(
          title: "Invalid Username or Password",
          message: 'Username or Password Cannot be Empty'));
      return;
    }
    try {
      await loginRepository.login(event.empId, event.password);
      emit(LoginSuccessfull());
    } on ApiException catch (e) {
      emit(LoginFailed(title: e.error[0], message: e.error[1]));
    }
  }
}
