import 'package:seasons/features/settings/data/models/info_model.dart';

abstract class InfoStates {}

class InfoInitialState extends InfoStates {}

class GetAllInfoLoadingState extends InfoStates {}

class GetAllInfoSuccessState extends InfoStates {
  List<InfoModel> info = [];
  GetAllInfoSuccessState(this.info);
}

class GetAllInfoErrorState extends InfoStates {
  String error;
  GetAllInfoErrorState(this.error);
}
