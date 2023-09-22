import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/core/dio_helper/end_points.dart';
import 'package:seasons/features/hotels/data/models/hotel_operation_response.dart';

import '../../../../core/errors/failures.dart';
import '../models/city_model.dart';
import '../models/hotel_model.dart';
import 'hotel_repo.dart';

class HotelRepoImplementation extends HotelRepo {
  @override
  Future<Either<Failure, GetHotelsModel>> getHotels() async {
    try {
      var data = await DioHelper.getDate(
        url: EndPoints.viewHotels,
      );
      print(data.data.toString());
      return right(GetHotelsModel.fromJson(data.data));
    } catch (e) {
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HotelCityModel>>> getCities() async {
    try {
      var data = await DioHelper.getDate(
        url: EndPoints.viewCities,
      );
      print(data.data.toString());
      List<HotelCityModel> cities = [];
      data.data.forEach((element) {
        cities.add(HotelCityModel.fromJson(element));
      });
      return right(cities);
    } catch (e) {
      print("object");
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      var data =
          await DioHelper.postDate(endPoint: EndPoints.addHotelBook, query: {
        'hotel_name': hotel.name,
        'hotel_id': hotel.id,
        'rating': hotel.rating,
        'hotel_type': hotel.hotelType,
        'room_type': roomType,
        'child_room_type': childRoomType,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'start_date': startDate,
        'end_date': endDate,
        'number_of_days': numberOdDays,
        'total': total,
        'tax': hotel.tax,
        'net_total': net,
        'account_name': accountName,
      });
      print(data.data.toString());
      return right(HotelOperationResponse.fromJson(data.data));
    } catch (e) {
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
