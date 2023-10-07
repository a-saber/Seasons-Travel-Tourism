import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/core/errors/failures.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/features/book_info/presentaion/views/book_infor_screen.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_cubit.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_cubit.dart';
import 'package:seasons/features/home/data/slider_model.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_cubit.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_cubit.dart';
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

class SliderCubit extends Cubit<SliderStates> {
  SliderCubit() : super(SliderInitialState());

  static SliderCubit get(context) => BlocProvider.of(context);

  List<SliderModel> sliders =[];
  Future getSlider(context) async {
    sliders = [];
    emit(SliderGetLoadingState());
    try
    {
      var sliderResponse = await DioHelper.getDate(url: '/get-slider');
      await getSliderDate(sliderResponse, context);
      emit(SliderGetSuccessState());
    }
    catch(e)
    {
      print('error get slider');
      print(e.toString());
      late String error;
      if (e is DioError)
      {
        error = ServerFailure.fromDioError(e).errorMessage;
      }
      else
      {
        error = ServerFailure(e.toString()).errorMessage;
      }
      emit(SliderGetErrorState(error.toString()));
    }
  }

  Future getSliderDate(value, context) async
  {
    for(int i =0;i<value.data.length;i++)
    {
      print(value.data[i]);
      SliderModel sliderModel = SliderModel.fromJson(value.data[i]);
      if(sliderModel.link == null) continue;
      try {
        List<String> link = sliderModel.link!.split(",");
        print(link);
        if(link[0] == 'car')
        {
          sliderModel.sliderType = SliderTypes.car;
          var car = await CarsCubit.get(context).getCarById(link[1]);
          if(car != null)
          {
            sliderModel.carModel = car;
            sliders.add(sliderModel);
          }
        }
        else if(link[0] == 'flight')
        {
          sliderModel.sliderType = SliderTypes.flight;
          var flight = await FlightsCubit.get(context).getFlightByID(link[1]);
          if(flight != null)
          {
            sliderModel.flightModel = flight;
            sliders.add(sliderModel);
          }
        }
        else if(link[0] == 'hotel')
        {
          sliderModel.sliderType = SliderTypes.hotel;
          var hotel = await HotelsCubit.get(context).getHotelByID(link[1]);
          if(hotel != null)
          {
            sliderModel.hotelModel = hotel;
            sliders.add(sliderModel);
          }
        }
        else if(link[0] == 'program')
        {
          sliderModel.sliderType = SliderTypes.program;
          var program = await ProgramsCubit.get(context).getProgramById(link[1]);
          if(program != null)
          {
            sliderModel.programModel = program;
            sliders.add(sliderModel);
          }
        }
      }catch(e)
      {
        print('error');
        print(e.toString());
        continue;
      }
    }
  }

}


