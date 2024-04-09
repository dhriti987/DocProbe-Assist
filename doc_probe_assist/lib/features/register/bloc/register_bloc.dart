import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_probe_assist/features/register/repository/register_repository.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final registerRepository = sl.get<RegisterRepository>();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<RegisterButtonClickedEvent>(onRegisterButtonClickedEvent);
  }

  FutureOr<void> onRegisterButtonClickedEvent(
      RegisterButtonClickedEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      await registerRepository.register(
          event.name, event.empID, event.email, event.password);
      emit(RegisterLoadingSuccessState());
    } catch (e) {
      emit(RegisterLoadingFailedState());
    }
  }
}
