import 'package:seasons/features/hotels/data/models/city_model.dart';

abstract class HotelsStates {}

class HotelsInitialState extends HotelsStates {}

class ViewHotelsLoadingState extends HotelsStates {}

class ViewHotelsSuccessState extends HotelsStates {}

class ViewHotelsErrorState extends HotelsStates {
  String error;
  ViewHotelsErrorState(this.error);
}

class ViewBookHotelsLoadingState extends HotelsStates {}

class ViewBookHotelsSuccessState extends HotelsStates {
  String message;
  ViewBookHotelsSuccessState(this.message);
}

class ViewBookHotelsErrorState extends HotelsStates {
  String error;
  ViewBookHotelsErrorState(this.error);
}

class ViewCitiesLoadingState extends HotelsStates {}

class ViewCitiesSuccessState extends HotelsStates {
  List<HotelCityModel> cities = [];
  ViewCitiesSuccessState(this.cities);
}

class ViewCitiesErrorState extends HotelsStates {
  String error;
  ViewCitiesErrorState(this.error);
}

class ChangeIndexState extends HotelsStates {}
class RoomsDataSetterState extends HotelsStates {}

class HotelsFilterLoadingState extends HotelsStates {}
class HotelsFilterSuccessState extends HotelsStates {}
class HotelsFilterErrorState extends HotelsStates
{
  String error;

  HotelsFilterErrorState(this.error);
}
