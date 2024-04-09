part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

sealed class RegisterActionState extends RegisterState {}

final class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterLoadingSuccessState extends RegisterState {}

class RegisterLoadingFailedState extends RegisterState {}
