import '../../../data/models/user_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LogoutState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  UserModel user;
  LoginSuccessState(this.user);
}

class LoginErrorState extends LoginStates {
  String error;
  LoginErrorState(this.error);
}

class RegisterLoadingState extends LoginStates {}
class RegisterSuccessState extends LoginStates {}
class RegisterErrorState extends LoginStates {
  String error;
  RegisterErrorState(this.error);
}


class GetImageSuccessState extends LoginStates{}
class GetImageErrorState extends LoginStates{}
class UploadLoadingState extends LoginStates{}

class DeleteUserSuccessState extends LoginStates{}
class DeleteUserErrorState extends LoginStates{
  final String error;
  DeleteUserErrorState(this.error);
}
class DeleteUserLoadingState extends LoginStates{
}

class UploadSuccessState extends LoginStates {}

class NotPickedState extends LoginStates {}

class UploadErrorState extends LoginStates{
  final String error;
  UploadErrorState (this.error);
}
