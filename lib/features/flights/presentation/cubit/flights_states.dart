abstract class FlightsStates {}

class FlightsInitialState extends FlightsStates {}

class FlightsGetLoadingState extends FlightsStates {}
class FlightsGetSuccessState extends FlightsStates {}
class FlightsGetErrorState extends FlightsStates
{
  String error;

  FlightsGetErrorState(this.error);
}

class FlightsFilterLoadingState extends FlightsStates {}
class FlightsFilterSuccessState extends FlightsStates {}
class FlightsFilterSuccessWithNoDataState extends FlightsStates {}
class FlightsFilterErrorState extends FlightsStates
{
  String error;

  FlightsFilterErrorState(this.error);
}

class FlightsPassengersSetterState extends FlightsStates {}




class FlightsBookLoadingState extends FlightsStates {}
class FlightsBookSuccessState extends FlightsStates
{
  String message;

  FlightsBookSuccessState(this.message);
}
class FlightsBookErrorState extends FlightsStates
{
  String error;

  FlightsBookErrorState(this.error);
}