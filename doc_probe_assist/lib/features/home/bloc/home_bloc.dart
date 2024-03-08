import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doc_probe_assist/core/exceptions/api_exceptions.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<LoginToContinueButtonClickedEvent>(onLoginToContinueButtonClickedEvent);
  }

  FutureOr<void> onLoginToContinueButtonClickedEvent(
      LoginToContinueButtonClickedEvent event, Emitter<HomeState> emit) {}
}
