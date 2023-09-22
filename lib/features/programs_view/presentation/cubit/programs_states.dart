abstract class ProgramsStates {}

class ProgramsInitialState extends ProgramsStates {}

class CountriesGetLoadingState extends ProgramsStates {}
class CountriesGetSuccessState extends ProgramsStates {}
class CountriesGetErrorState extends ProgramsStates
{
  String error;
  CountriesGetErrorState(this.error);
}


class CitiesGetLoadingState extends ProgramsStates {}
class CitiesGetSuccessState extends ProgramsStates {}
class CitiesGetErrorState extends ProgramsStates
{
  String error;
  CitiesGetErrorState(this.error);
}


class ProgramsGetLoadingState extends ProgramsStates {}
class ProgramsGetSuccessState extends ProgramsStates {}
class ProgramsGetErrorState extends ProgramsStates
{
  String error;
  ProgramsGetErrorState(this.error);
}

class ProgramsBookLoadingState extends ProgramsStates {}
class ProgramsBookSuccessState extends ProgramsStates
{
  String message;
  ProgramsBookSuccessState(this.message);
}
class ProgramsBookErrorState extends ProgramsStates
{
  String error;
  ProgramsBookErrorState(this.error);
}

class ProgramsFilterGetLoadingState extends ProgramsStates {}
class ProgramsFilterGetSuccessState extends ProgramsStates {}
class ProgramsFilterSuccessNoDataState extends ProgramsStates {}

class ProgramsFilterGetErrorState extends ProgramsStates
{
  String error;
  ProgramsFilterGetErrorState(this.error);
}

class RoomsDataSetterState extends ProgramsStates {}

