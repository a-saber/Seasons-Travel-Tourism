
abstract class AboutStates {}

class AboutInitialState extends AboutStates {}

class GetAboutLoadingState extends AboutStates {}

class GetAboutSuccessState extends AboutStates {}

class GetAboutErrorState extends AboutStates {
  String error;
  GetAboutErrorState(this.error);
}
