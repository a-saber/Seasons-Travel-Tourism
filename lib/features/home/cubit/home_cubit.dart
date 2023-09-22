import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/features/book_info/presentaion/views/book_infor_screen.dart';
import 'package:seasons/features/settings/presentation/views/settings_view.dart';
import 'package:seasons/features/sign_in/presentaion/views/profile_view.dart';

import '../../sign_in/presentaion/views/sign_in_screen.dart';
import '../presentation/views/home_body.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    HomeBody(),
    SignInScreen(),
    BookInfoScreen(),
    SettingsView(),
  ];

  int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
    emit(HomeBottomNavState());
  }
  bool login = false;
  void Login() {
    screens = [
      HomeBody(),
      ProfileView(),
      BookInfoScreen(),
      SettingsView(),
    ];
    login = true;
    emit(HomeLoggedInState());
  }
  void Logout() {
    screens = [
      HomeBody(),
      SignInScreen(),
      BookInfoScreen(),
      SettingsView(),
    ];
    login = false;
    emit(HomeLoggedInState());
  }

}
