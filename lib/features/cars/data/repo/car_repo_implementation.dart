import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:seasons/core/dio_helper/end_points.dart';
import 'package:seasons/features/cars/data/models/book_model.dart';
import 'package:seasons/features/cars/data/models/cars_model.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_cubit.dart';

import '../../../../core/dio_helper/dio_helper.dart';
import '../../../../core/errors/failures.dart';
import '../models/car_types.dart';
import 'car_repo.dart';

class CarRepoImplementation extends CarRepo {
  List<CarTypes>? car;
  CarRepoImplementation();
  @override
  Future<Either<Failure, List<CarTypes>>> getAllCarTypes() async {
    try {
      var data = await DioHelper.getDate(
        url: EndPoints.CARTYPES,
      );
      print("all car typppppppppppppppppes");
      print(data.data.toString());
      List<CarTypes> carTypes = [];
      data.data.forEach((element) {
        carTypes.add(CarTypes.fromJson(element));
      });
      car = carTypes;
      return right(carTypes);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrrooor");
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CarsModel>>> getAllCars(context) async {
    try {
      var data = await DioHelper.getDate(
        url: EndPoints.ALLCARS,
      );
      print("all carsssssssssssssssssssssss");
      print(data.data.toString());
      List<CarsModel> cars = [];
      await data.data.forEach((element) async{
        CarsModel car = CarsModel.fromJson(element);
        cars.add(car);
      });
      return right(cars);
    } catch (e) {
      print("cars eeeerrrrorrs");
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookModel>> BookCar({
    required String typedId,
    required String driver,
    required String fName,
    required String lName,
    required String phone,
    required String startDate,
    required String endDate,
    required String email,
    required String totalDays,
    required String totalAmount,
    required String tax,
    required String net,
    required String notes,
  }) async {
    try {
      var data = await DioHelper.postDate(endPoint: EndPoints.BOOKCAR, query: {
        'type_id': typedId,
        'width_driver': driver,
        'first_name': fName,
        'last_name': lName,
        'phone_number': phone,
        'start_date': startDate,
        'email': email,
        'end_date': endDate,
        'total_days': totalDays,
        'total_amount': totalAmount,
        'tax': tax,
        'net_amount': net,
        'notes': notes,
        'account_owner': "",
      });
      print(data.data.toString());
      print("dddddddddddddddddddddddattttttat");
      print(data.data.toString());
      return right(BookModel.fromJson(data.data));
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(e.toString());
      if (e is DioError) {
        print(
            "dioooo eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrrrr");
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
