import 'package:seasons/features/cars/data/models/car_types.dart';

abstract class CarTypesStates {}

class CarTypesInitialState extends CarTypesStates {}

class GetAllCarTypesLoadingState extends CarTypesStates {}

class GetAllCarTypesSuccessState extends CarTypesStates {
  List<CarTypes> carTypes = [];
  GetAllCarTypesSuccessState(this.carTypes);
}

class GetAllCarTypesErrorState extends CarTypesStates {
  String error;

  GetAllCarTypesErrorState(this.error);
}

class ChangeIndexState extends CarTypesStates {}
