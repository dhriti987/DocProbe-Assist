part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

sealed class LohinActionState extends LoginState {}

final class LoginInitial extends LoginState {}

final class LoginFailed extends LohinActionState {}

final class LoginSuccessfull extends LohinActionState {}
