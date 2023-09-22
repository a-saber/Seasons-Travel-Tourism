import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/features/hotels/presentation/views/hotels_view.dart';
import 'package:seasons/features/settings/presentation/views/settings_view.dart';

import '../../features/more/more_screen.dart';
import '../../features/tourism/presentation/views/tourism_screen.dart';
import '../../features/travel/presentation/views/widgets/tavel_view_body.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  String? flightDepartureDate;
  String? tourDepartureDate;
  String? roomType;
  String? kidsReservation;
  changeFlightDepartureDate(String date)
  {
    flightDepartureDate = date;
    emit(AppChooseDateState());
  }
  changeRoomType(String date)
  {
    roomType = date;
    emit(AppChooseDateState());
  }
  changeKidsReservation(String date)
  {
    kidsReservation = date;
    emit(AppChooseDateState());
  }
  changeTourDepartureDate(String date)
  {
    tourDepartureDate = date;
    emit(AppChooseDateState());
  }
  String? chooseTextR;
  String? chooseTextL;
  String? tourismChooseTextR;
  String? tourismChooseTextL;
  List<String> townList = ['من فضلك اختر مدينة اولا'];
  List<String> list = [
    'عمان مطار الملكة علياء(AMM)',
    'مطار باتومي الدولي(TZX)',
    'مطار طرابزون',
    'تبليسي Novo Alexeyevka (TBS)',
  ];
  List<String> countryList = ['جورجيا', 'تركيا', 'جورجيا + تركيا'];
  List<String> georgiaList = ['باتومي', 'باتومي + تبليسي', 'تبليسي'];
  List<String> turkeyList = ['طرابزوان'];
  List<String> georgiaTurkeyList = [
    'باتومي + طرابزوان',
    'طرابزوان + اوزونجول + طرابزوان'
  ];
  bool isRight = false;
  bool tourismIsRight = false;

  bottomSheetItemTapped(int index, bool right, bool left) {
    if (right) {
      chooseTextR = list[index];
    } else if (left) {
      chooseTextL = list[index];
    }
    emit(ShowBottomSheetItemTappedSuccessState());
  }

  tourismBottomSheetItemTapped(int index, bool right, bool left) {
    if (tourismIsRight) {
      tourismChooseTextR = countryList[index];

      if (index == 0) {
        townList = georgiaList;
      } else if (index == 1) {
        townList = turkeyList;
      } else if (index == 2) {
        townList = georgiaTurkeyList;
      }
    } else if (left) {
      tourismChooseTextL = townList[index];
    }
    emit(ShowBottomSheetItemTappedSuccessState());
  }

  bool isBack = false;
  goBackTapped() {
    isBack = !isBack;
    emit(GoBackTappedSuccessState());
  }

  int screenIndex = 0;
  List<Widget> pages =
  [
    const TravelViewBody(),
    const HotelView(),
    const TourismScreen(),
    const SettingsView(),
  ];
  void changeIndex(int index) {
    screenIndex = index;
    print(screenIndex);
    emit(AppChangeBottomNavBarState());
  }
}
