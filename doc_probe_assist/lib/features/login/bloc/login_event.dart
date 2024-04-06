part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonClickedEvent extends LoginEvent {
  final String empId;
  final String password;

  LoginButtonClickedEvent({required this.empId, required this.password});
}
