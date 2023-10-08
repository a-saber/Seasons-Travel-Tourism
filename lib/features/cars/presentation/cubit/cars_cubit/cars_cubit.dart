import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/features/cars/data/models/car_types.dart';

import '../../../data/models/cars_model.dart';
import '../../../data/repo/car_repo_implementation.dart';
import 'cars_states.dart';

class CarsCubit extends Cubit<CarsStates> {
  CarsCubit(this.carsRepoImplementation) : super(CarsInitialState());
  final CarRepoImplementation carsRepoImplementation;
  static CarsCubit get(context) => BlocProvider.of(context);
  List<CarsModel> cars = [];
  Future<void> getCars(context) async {
    cars = [];
    emit(GetAllCarsLoadingState());
    var response = await carsRepoImplementation.getAllCars(context);
    response.fold((failure) {
      emit(GetAllCarsErrorState(failure.errorMessage));
      showToast(state: ToastState.ERROR, massage: failure.errorMessage);
    }, (result) async{
      cars = result;
      for(int i=0; i<result.length;i++)
      {
        result[i].carTypes= await CarsCubit.get(context).getCarTypeById(result[i].typeId!);
      }
      emit(GetAllCarsSuccessState(result));
      //showToast(state: ToastState.SUCCESS, massage: "Get Cars Successfully");
    });
  }

  getCarTypeModel(String typeId, BuildContext context)
  {
    for (int i = 0; i < carsRepoImplementation.car!.length; i++) {
      if (carsRepoImplementation.car![i].id.toString() == typeId) {
        print(carsRepoImplementation.car![i].name);
        print(carsRepoImplementation.car![i].nameEn);
        return carsRepoImplementation.car![i];
      }
    }
  }

  List<CarsModel>? selectedCars;
  getCarsWithIndex(int index) {
    print(index);
    if (index == 0) {
      selectedCars = cars;
      return selectedCars;
    } else {
      for (int i = 1; i <= carsRepoImplementation.car!.length; i++) {
        selectedCars = [];
        if (i == index) {
          for (int j = 0; j < cars.length; j++) {
            if (carsRepoImplementation.car![i - 1].id.toString() == cars[j].typeId) {
              cars[j].carTypes = carsRepoImplementation.car![i - 1];
              selectedCars!.add(cars[j]);
            }
          }
          return selectedCars;
        }
      }
    }
  }

  Future<CarSearchModel?> getCarById(String id) async
  {
    try
    {
      var data = await DioHelper.postDate(
        endPoint: '/car-view-with-id',
        query: {"id":id}
      );
      final parsed = jsonDecode(data.data.toString()).cast<Map<String, dynamic>>();
      CarSearchModel car =  CarSearchModel.fromJson(parsed[0]);
      car.carType = await getCarTypeById(car.typeId.toString());
      return car;
    }
    catch (e)
    {
      print("car error");
      print(e.toString());
      return null;
    }
  }
  Future<CarTypes?> getCarTypeById(String id) async
  {
    try
    {
      var data = await DioHelper.getDate(
          url: '/get_car_by_id',
          query: {"id":id}
      );
      //final parsed = jsonDecode(data.data.toString()).cast<Map<String, dynamic>>();
      return CarTypes.fromJson(data.data);
    }
    catch (e)
    {
      print("car type error");
      print(e.toString());
      return null;
    }
  }
}
