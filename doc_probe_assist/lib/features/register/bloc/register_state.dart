part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

sealed class RegisterActionState extends RegisterState {}

final class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterLoadingSuccessState extends RegisterActionState {}

class RegisterLoadingFailedState extends RegisterActionState {
  final String title;
  final String message;

  RegisterLoadingFailedState({required this.title, required this.message});
}
