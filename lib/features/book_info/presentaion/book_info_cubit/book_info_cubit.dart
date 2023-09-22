import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/features/book_info/presentaion/book_info_cubit/book_info_states.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';


class BookInfoCubit extends Cubit<BookInfoStates> {
  BookInfoCubit() : super(GetBookInitialState());

  static BookInfoCubit get(context) => BlocProvider.of(context);

  HotelModel? hotel;
  Future<void> getBookInfo({
    required String code,
  }) async {
    emit(GetBookLoadingState());
    await DioHelper.getDate(
        url: '/boking-search',
        query: {'booking_code':code}
    ).then((value) async
    {
      print('000000000');
      if(value.data['bookings'].isNotEmpty)// car
      {
        emit(GetBookSuccessState(value.data));
      }
      else if(value.data['hotel_reservations'].isNotEmpty)  // hotel
      {
        print('object');
        await DioHelper.postDate(
            endPoint: '/single-hotel',
            query: {'id':value.data['hotel_reservations'][0]['hotel_id']}
        ).then((hotelResponse)
        {

          final parsed = jsonDecode(hotelResponse.data.toString());
          if(parsed['success']==true) {
            hotel = HotelModel.fromJson(parsed['data']);
            emit(GetBookSuccessState(value.data));
          }
          else emit(GetBookErrorState(parsed['message']));
        })
        .catchError((error)
        {
          print(error.toString());
          emit(GetBookErrorState(error.toString()));
        });
      }
    })
    .catchError((error)
    {
      emit(GetBookErrorState(error.toString()));
    });

  }
}
