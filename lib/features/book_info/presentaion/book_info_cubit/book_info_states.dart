
abstract class BookInfoStates {}

class GetBookInitialState extends BookInfoStates {}

class GetBookLoadingState extends BookInfoStates {}

class GetBookSuccessState extends BookInfoStates
{
String url;
GetBookSuccessState(this.url);
}

class GetBookErrorState extends BookInfoStates {
  String error;

  GetBookErrorState(this.error);
}
