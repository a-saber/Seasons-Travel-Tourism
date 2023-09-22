
abstract class BookInfoStates {}

class GetBookInitialState extends BookInfoStates {}

class GetBookLoadingState extends BookInfoStates {}

class GetBookSuccessState extends BookInfoStates
{
  var data;
  GetBookSuccessState(this.data);
}

class GetBookErrorState extends BookInfoStates {
  String error;

  GetBookErrorState(this.error);
}
