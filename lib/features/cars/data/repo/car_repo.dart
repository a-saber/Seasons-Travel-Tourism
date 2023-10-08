import 'package:dartz/dartz.dart';
import 'package:seasons/features/cars/data/models/book_model.dart';
import 'package:seasons/features/cars/data/models/cars_model.dart';

import '../../../../core/errors/failures.dart';
import '../models/car_types.dart';

abstract class CarRepo {
  Future<Either<Failure, List<CarTypes>>> getAllCarTypes();
  Future<Either<Failure, List<CarsModel>>> getAllCars(context);
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
  });
}
