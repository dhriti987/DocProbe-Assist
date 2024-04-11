import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:doc_probe_assist/core/utils/validators.dart';
import 'package:doc_probe_assist/features/register/repository/register_repository.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final registerRepository = sl.get<RegisterRepository>();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) {});
    on<RegisterButtonClickedEvent>(onRegisterButtonClickedEvent);
  }

  FutureOr<void> onRegisterButtonClickedEvent(
      RegisterButtonClickedEvent event, Emitter<RegisterState> emit) async {
    if (!validateStringLength(event.empID) ||
        !validateStringLength(event.name) ||
        !validateStringLength(event.password)) {
      emit(RegisterLoadingFailedState(
          title: 'Invalid Parameters', message: 'Fields should no be Empty'));
      return;
    } else if (!isEmailValid(event.email)) {
      emit(RegisterLoadingFailedState(
          title: 'Invalid Parameters',
          message: 'Email not Valid. Please enter a valid email.'));
      return;
    }
    try {
      await registerRepository.register(
          event.name, event.empID, event.email, event.password);
      emit(RegisterLoadingSuccessState());
    } on ApiException catch (e) {
      emit(RegisterLoadingFailedState(title: e.error[0], message: e.error[1]));
    }
  }
}
