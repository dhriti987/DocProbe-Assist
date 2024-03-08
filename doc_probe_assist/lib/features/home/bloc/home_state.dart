part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

sealed class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class NavigateToChatPage extends HomeActionState {}

class SwitchToLoginWidget extends HomeState {}

class SwitchToSignUpWidget extends HomeState {}

class LoginFailedState extends HomeActionState {
  final ApiException apiException;

  LoginFailedState({required this.apiException});
}
