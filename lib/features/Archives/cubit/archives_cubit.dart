

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/core/errors/failures.dart';

import 'archives_state.dart';

class ArchivesCubit extends Cubit<ArchivesState> {
  ArchivesCubit() : super(ArchivesInitial());
  static ArchivesCubit get(context) => BlocProvider.of(context);
  List<String> flights=[];
  List<String> cars=[];
  List<String> programs=[];
  List<String> hotels=[];
  String? id;
  bool? agent;


  int currentIndex=0;
  List<String>? categories;
   void tab(index)
   {
     currentIndex = index;
     if(index==0)
     {
       categories = flights;
     }
     else if(index==1)
     {
       categories = programs;
     }
     else if(index==2)
     {
       categories = hotels;
     }
     else
     {
       categories = cars;
     }
     emit(ArchivesChangeInitial());
   }
  Future getArchives(String id, bool agent)async
  {
    this.id = id;
    this.agent = agent;
    print(id);
    emit(ArchivesLoadingInitial());
    try
    {
      flights = [];
      var response1 = await DioHelper.getDate(url: '/fli-rr', query: {'id': id});
      response1.data.forEach((element) {
        flights.add(element['booking_id']);
      });
      programs = [];
      var response2 = await DioHelper.getDate(url: '/br-rr', query: {'id': id});
      response2.data.forEach((element) {
        programs.add(element['booking_id']);
      });
      hotels = [];
      var response3 = await DioHelper.getDate(
          url: '/hotel--rr', query: {'id': id});
      response3.data.forEach((element) {
        hotels.add(element['code']);
      });
      cars = [];
      var response4 = await DioHelper.getDate(url: '/car-rr', query: {'id': id});
      response4.data.forEach((element) {
        cars.add(element['random_code']);
      });

      categories = flights;
      emit(ArchivesSuccessInitial());
    }
    catch(e)
    {
      print(e.toString());
      if(e is DioError)
        emit(ArchivesErrorInitial(ServerFailure.fromDioError(e).errorMessage));
      else
        emit(ArchivesErrorInitial(ServerFailure(e.toString()).errorMessage));
    }
  }

  // Future getFlights() async
  // {
  //   try {
  //
  //   }catch(e)
  //   {
  //     print(e.toString());
  //   }
  // }
  // Future getPrograms() async
  // {
  //   try {
  //     programs = [];
  //     var response = await DioHelper.getDate(url: 'br-rr', query: {'id': id});
  //     response.data.forEach((element) {
  //       programs.add(element['booking_id']);
  //     });
  //   }catch(e)
  //   {
  //     print(e.toString());
  //   }
  // }
  // Future getHotels() async
  // {
  //   try {
  //     hotels = [];
  //     var response = await DioHelper.getDate(
  //         url: 'hotel--rr', query: {'id': id});
  //     response.data.forEach((element) {
  //       hotels.add(element['code']);
  //     });
  //   }catch(e)
  //   {
  //     print(e.toString());
  //   }
  // }
  // Future getCars() async
  // {
  //   try {
  //     cars = [];
  //     var response = await DioHelper.getDate(url: 'car--rr', query: {'id': id});
  //     response.data.forEach((element) {
  //       cars.add(element['random_code']);
  //     });
  //   }
  //   catch(e)
  //   {
  //     print(e.toString());
  //   }
  // }

}
