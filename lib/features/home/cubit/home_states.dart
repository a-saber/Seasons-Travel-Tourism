abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeBottomNavState extends HomeStates {}
class HomeLoggedInState extends HomeStates {}

abstract class SliderStates {}
class SliderInitialState extends SliderStates {}

class SliderGetLoadingState extends SliderStates {}
class SliderGetSuccessState extends SliderStates {}
class SliderGetErrorState extends SliderStates
{
  String error;
  SliderGetErrorState(this.error);
}

