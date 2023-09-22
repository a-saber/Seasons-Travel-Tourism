import '../../../data/models/terms_model.dart';

abstract class TermsStates {}

class TermsInitialState extends TermsStates {}

class GetAllTermsLoadingState extends TermsStates {}

class GetAllTermsSuccessState extends TermsStates {
  List<TermsModel> terms = [];
  GetAllTermsSuccessState(this.terms);
}

class GetAllTermsErrorState extends TermsStates {
  String error;
  GetAllTermsErrorState(this.error);
}
