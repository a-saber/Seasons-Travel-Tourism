import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/core/errors/failures.dart';
import 'package:seasons/features/book_info/presentaion/book_info_cubit/book_info_states.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';


class BookInfoCubit extends Cubit<BookInfoStates> {
  BookInfoCubit() : super(GetBookInitialState());

  static BookInfoCubit get(context) => BlocProvider.of(context);

  String? type;
  HotelModel? hotel;
  Future<void> getBookInfo({
    required String code,
  }) async
  {
    emit(GetBookLoadingState());
    type = null;
    try
    {
      var response = await DioHelper.getDate(url: '/boking-search', query: {'booking_code': code});
      if (response.data['bookings'].isNotEmpty) // car
      {
        type = 'cars';
      }
      else if (response.data['hotel_reservations'].isNotEmpty) // hotel
      {
        type = 'hotels';
      }
      else if (response.data['bookingss'].isNotEmpty) // flight
      {
        type = 'flights';
      }
      else if (response.data['reservations'].isNotEmpty) //programs
      {
        type = 'programs';
      }
      if(type == null)
      {
        emit(GetBookErrorState('sorry there is an error, try again later'));
      }
      else
      {
        emit(GetBookSuccessState('${type}-checkout/${code}'));
      }
    }
    catch(e)
    {
      if(e is DioError)
      {
        emit(GetBookErrorState(ServerFailure.fromDioError(e).errorMessage));
      }
      else
      {
        emit(GetBookErrorState(e.toString()));
      }
    }
  }
}
