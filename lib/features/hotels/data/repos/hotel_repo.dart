import 'package:dartz/dartz.dart';
import 'package:seasons/features/hotels/data/models/hotel_operation_response.dart';

import '../../../../core/errors/failures.dart';
import '../models/city_model.dart';
import '../models/hotel_model.dart';

abstract class HotelRepo {
  Future<Either<Failure, GetHotelsModel>> getHotels();

  Future<Either<Failure, List<HotelCityModel>>> getCities();

  Future<Either<Failure, HotelOperationResponse>> bookHotel({
    required HotelModel hotel,
    required String roomType,
    required String childRoomType,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String startDate,
    required String endDate,
    required String numberOdDays,
    required String total,
    required String net,
    required String accountName,
  });
}
