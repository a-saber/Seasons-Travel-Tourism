import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/features/hotels/data/models/city_model.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';
import 'package:seasons/features/hotels/data/repos/hotel_repo_implementation.dart';
import 'package:seasons/features/programs_view/presentation/views/adult_number_view.dart';

import 'hotel_states.dart';

class HotelsCubit extends Cubit<HotelsStates> {
  HotelsCubit(this.repo) : super(HotelsInitialState());

  List<RoomData> roomsData = [
    RoomData(),
  ];

  List<RoomData> roomsDataSearch = [
    RoomData(),
  ];

  void roomsDataSetter(List<RoomData> roomsData) {
    this.roomsData = roomsData;
    emit(RoomsDataSetterState());
  }

  void roomsDataSearchSetter(List<RoomData> roomsData) {
    this.roomsDataSearch = roomsData;
    emit(RoomsDataSetterState());
  }

  final HotelRepoImplementation repo;

  static HotelsCubit get(context) => BlocProvider.of(context);

  List<List<HotelModel>> hotels = [];

  Future<void> getHotels(context,
      {required String city,
      required DateTime startDate,
      required DateTime endDate,
      required int daysCount}) async {
    hotels = [];
    emit(ViewHotelsLoadingState());
    var response = await repo.getHotels();
    response.fold((failure) {
      emit(ViewHotelsErrorState(failure.errorMessage));
      callMySnackBar(context: context, text: failure.errorMessage);
    }, (result) {
      if (result.success!) {
        if (result.date != null) {
          hotels = [];
          allHotels = [];
          hotels.add([]);
          cities.forEach((element) {
            hotels.add([]);
          });
          print('--------------');
          print(hotels.length);
          print(cities.length);
          result.date.forEach((h) {
            HotelModel hotel = HotelModel.fromJson(h);
            hotels[0].add(hotel);
            allHotels.add(hotel);
            for (int i = 0; i < cities.length; i++) {
              if (hotel.city == cities[i].id.toString()) {
                hotels[i + 1].add(hotel);
                break;
              }
            }
          });
        }

        for (int i = 0; i < hotels.length; i++) {
          if (i != 0) {
            print(cities[i - 1].name);
          } else {
            print('ALL');
          }
          print('*********');
          hotels[i].forEach((element) {
            print(element.name);
            print(element.city);
          });
        }
        emit(ViewHotelsSuccessState());
        filter(city: city,
            startDate: startDate,
            endDate: endDate,
            daysCount: daysCount);
      } else {
        print("eeeeeeeeeeeeeerrrrrrrrror");
        emit(ViewHotelsErrorState('Error happened'));
        callMySnackBar(context: context, text: 'Error happened');
      }
    });
  }

  Future<HotelModel?> getHotelByID(String id) async
  {
    try {
      var data = await DioHelper.postDate(
        endPoint: '/single-hotel',query: {"id":id}
      );
      final parsed = jsonDecode(data.data.toString());
      HotelModel hotelModel = HotelModel.fromJson(parsed['data']);
      hotelModel.cityModel = await getCityByID(hotelModel.city!);
      return hotelModel;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<HotelCityModel?> getCityByID(String id) async
  {
    try {
      var data = await DioHelper.getDate(
          url: '/get_city',query: {"id":id}
      );
      //final parsed = jsonDecode(data.data.toString());
      HotelCityModel city = HotelCityModel.fromJson(data.data);
      return city;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  List<HotelCityModel> cities = [];
  List<HotelModel> allHotels = [];
  List<HotelModel> filteredHotels = [];

  late DateTime startDate;
  late DateTime endDate;

  Future<void> getCities(context,
      {required String city,
      required DateTime startDate,
      required DateTime endDate,
      required int daysCount}) async {
    this.startDate = startDate;
    this.endDate = endDate;
    cities = [];
    emit(ViewCitiesLoadingState());
    var response = await repo.getCities();

    response.fold((failure) {
      emit(ViewCitiesErrorState(failure.errorMessage));
    }, (result) async {
      cities = result;
      emit(ViewCitiesSuccessState(result));
      await getHotels(context,
          city: city,
          startDate: startDate,
          endDate: endDate,
          daysCount: daysCount);
    });
  }

  int currentIndex = 0;

  void itemBarOnTap(int index) {
    currentIndex = index;
    emit(ChangeIndexState());
  }

  Future<void> bookHotel({
    required context,
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
    emit(ViewBookHotelsLoadingState());
    var response = await repo.bookHotel(
        hotel: hotel,
        roomType: roomType,
        childRoomType: childRoomType,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        startDate: startDate,
        endDate: endDate,
        numberOdDays: numberOdDays,
        total: total,
        net: net,
      accountName: accountName,
    );
    response.fold((failure) {
      emit(ViewBookHotelsErrorState(failure.errorMessage));
      //showToast(massage: failure.errorMessage, state: ToastState.ERROR);
    }, (result) {
      if (result.success!) {
      //  showToast(massage: result.message!, state: ToastState.SUCCESS);
        //callMySnackBar(context: context, text: result.message!);
        emit(ViewBookHotelsSuccessState(result.message!));
      } else {
        emit(ViewBookHotelsErrorState('Error happened'));
       // showToast(massage: result.message!, state: ToastState.ERROR);
      }
    });
  }

  void filter({
    required String city,
    required DateTime startDate,
    required DateTime endDate,
    required int daysCount,
  }) {
    print(allHotels.length);
    if (allHotels.isNotEmpty) {
      emit(HotelsFilterLoadingState());
      filteredHotels = [];
      allHotels.forEach((element) {
        if (city == element.city) {
          filteredHotels.add(element);
        }
      });
      if (filteredHotels.isNotEmpty) {
        emit(HotelsFilterSuccessState());
      } else {
        emit(HotelsFilterErrorState('No result match this data'));
      }
      print('filteredHotels length');
      print(filteredHotels.length);
    }
  }
}
