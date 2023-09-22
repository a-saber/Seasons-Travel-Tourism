import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/core/errors/failures.dart';
import 'package:seasons/features/airports/data/models/airport_model.dart';

import 'airports_states.dart';

class AirportsCubit extends Cubit<AirportsStates> {
  AirportsCubit() : super(AirportsInitialState());

  static AirportsCubit get(context) => BlocProvider.of(context);
  AirportsResponse? airportsResponse;
  List<AirportModel> airPortsFiltered = [];

  bool fetchedSuccess = false;
  String fetchError = '';
  void getAirports() {
    emit(AirportsGetLoadingState());
    DioHelper.getDate(url: '/viewAirports').then((value) {
      print(value.data.toString());
      airportsResponse = AirportsResponse.fromJson(value.data);
      if (airportsResponse != null) {
        if (airportsResponse!.success!) {
          if (airportsResponse!.data != null) {
            if (airportsResponse!.data!.isNotEmpty) {
              fetchedSuccess = true;
              emit(AirportsGetSuccessState());
            } else {
              fetchError = 'Sorry, there is no data';
              emit(AirportsGetErrorState(fetchError));
            }
          } else {
            fetchError = 'Server error, please try again later';
            emit(AirportsGetErrorState('Server error, please try again later'));
          }
        } else {
          fetchError = 'Server error, please try again later';
          emit(AirportsGetErrorState('Server error, please try again later'));
        }
      } else {
        fetchError = 'Server error, please try again later';
        emit(AirportsGetErrorState('Server error, please try again later'));
      }
    }).catchError((e) {
      print('error get airports');
      print(e.toString());
      late String error;
      if (e is DioError) {
        error = ServerFailure.fromDioError(e).errorMessage;
      } else {
        error = ServerFailure(e).errorMessage;
      }
      fetchError = error;
      emit(AirportsGetErrorState(error));
    });
  }

  void filter({
    required String name,
  }) {
    emit(AirportsFilterLoadingState());
    if (fetchedSuccess) {
      airPortsFiltered = [];
      airportsResponse!.data!.forEach((element) {
        if (name.toLowerCase().contains(element.arabicName!.toLowerCase()) ||
            name.toLowerCase().contains(element.englishName!.toLowerCase()) ||
            element.arabicName!.toLowerCase().contains(name.toLowerCase()) ||
            element.englishName!.toLowerCase().contains(name.toLowerCase())) {
          airPortsFiltered.add(element);
        }
      });
      if (airPortsFiltered.isNotEmpty) {
        emit(AirportsFilterSuccessState());
      } else {
        emit(AirportsFilterErrorState('No result match this word'));
      }
      print(airPortsFiltered.length);
    } else {
      emit(AirportsFilterErrorState(fetchError));
    }
  }
}

// DateTime userStartDate = DateTime.parse(startDate);
// DateTime userDepDate = DateTime.parse(departureDate);
