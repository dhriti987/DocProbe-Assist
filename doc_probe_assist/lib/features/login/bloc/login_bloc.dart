import 'dart:async';

import 'package:bloc/bloc.dart';
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
    try {
      await loginRepository.login(event.empId, event.password);
      emit(LoginSuccessfull());
    } catch (e) {
      emit(LoginFailed());
    }
  }
}
