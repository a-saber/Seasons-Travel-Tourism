import 'package:seasons/features/cars/data/models/book_model.dart';

abstract class CarBookStates {}

class CarBookInitialState extends CarBookStates {}

class CarBookCarBookLoadingState extends CarBookStates {}
class CarBookDateLoadingState extends CarBookStates {}

class CarBookCarBookSuccessState extends CarBookStates {
  BookModel? carBook;
  CarBookCarBookSuccessState(this.carBook);
}

class CarBookCarBookErrorState extends CarBookStates {
  String error;

  CarBookCarBookErrorState(this.error);
}
