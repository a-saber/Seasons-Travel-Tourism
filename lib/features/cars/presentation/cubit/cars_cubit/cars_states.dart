import 'package:seasons/features/cars/data/models/cars_model.dart';

abstract class CarsStates {}

class CarsInitialState extends CarsStates {}

class GetAllCarsLoadingState extends CarsStates {}

class GetAllCarsSuccessState extends CarsStates {
  List<CarsModel> cars = [];
  GetAllCarsSuccessState(this.cars);
}

class GetAllCarsErrorState extends CarsStates {
  String? error;
  GetAllCarsErrorState(this.error);
}

class GetTypeSuccessState extends CarsStates {}
