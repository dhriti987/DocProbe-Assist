part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoginToContinueButtonClickedEvent extends HomeEvent {}

class AboutUsButtonClickedEvent extends HomeEvent {}

class GetInTouchButtonClickedEvent extends HomeEvent {}

class LoginButtonClickedEvent extends HomeEvent {}
