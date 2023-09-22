abstract class AirportsStates {}

class AirportsInitialState extends AirportsStates {}

class AirportsGetLoadingState extends AirportsStates {}
class AirportsGetSuccessState extends AirportsStates {}
class AirportsGetErrorState extends AirportsStates
{
  String error;

  AirportsGetErrorState(this.error);
}

class AirportsFilterLoadingState extends AirportsStates {}
class AirportsFilterSuccessState extends AirportsStates {}
class AirportsFilterErrorState extends AirportsStates
{
  String error;

  AirportsFilterErrorState(this.error);
}
