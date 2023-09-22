import 'package:seasons/features/settings/data/models/privacy_model.dart';

abstract class PrivacyStates {}

class PrivacyInitialState extends PrivacyStates {}

class GetAllPrivacyLoadingState extends PrivacyStates {}

class GetAllPrivacySuccessState extends PrivacyStates {
  List<PrivacyModel> privacy = [];
  GetAllPrivacySuccessState(this.privacy);
}

class GetAllPrivacyErrorState extends PrivacyStates {
  String error;
  GetAllPrivacyErrorState(this.error);
}
