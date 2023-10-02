import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/core/errors/failures.dart';
import 'package:seasons/features/airports/data/models/airport_model.dart';
import 'package:seasons/features/flights/presentation/views/flight_passenger_data.dart';
import 'package:seasons/features/hotels/data/models/city_model.dart';
import 'package:seasons/features/programs_view/data/models/city_model.dart';
import 'package:seasons/features/programs_view/data/models/country_model.dart';
import 'package:seasons/features/programs_view/data/models/program_model.dart';
import 'package:seasons/features/programs_view/presentation/views/adult_number_view.dart';

import 'programs_states.dart';

class ProgramsCubit extends Cubit<ProgramsStates>
{
  ProgramsCubit() : super(ProgramsInitialState());

  static ProgramsCubit get(context) => BlocProvider.of(context);
  List<CountryModel> countries = [];
  List<ProgrammeCityModel> cities = [];
  List<ProgramModel> programs =[];
  List<ProgramModel> filteredPrograms =[];
  List<DateTime> specialDates =[];


  List<RoomData> roomsData = [
    RoomData(),
  ];

  void roomsDataSetter(List<RoomData> roomsData) {
    this.roomsData = roomsData;
    emit(RoomsDataSetterState());
  }

  Future getCountries({bool allowGroup = true}) async {
    countries = [];
    emit(CountriesGetLoadingState());
    await DioHelper.getDate(url: '/country-view').then((value) {
      print(value.data.toString());
      value.data.forEach((element) {
        CountryModel countryModel =CountryModel.fromJson(element);
        if(allowGroup){countries.add(countryModel);}
        else {
          if (((!countryModel.nameEn!.contains('&')) &&
              (!countryModel.nameEn!.contains('and'))))
            countries.add(countryModel);
        }
      });
      print(countries.length);
      if (countries.isNotEmpty) {
        emit(CountriesGetSuccessState());
      } else {
        emit(CountriesGetErrorState(
            'Sorry, server error please try again later'));
      }
    }).catchError((e) {
      print('error get countries');
      print(e.toString());
      late String error;
      if (e is DioError) {
        error = ServerFailure.fromDioError(e).errorMessage;
      } else {
        error = ServerFailure(e).errorMessage;
      }
      emit(CountriesGetErrorState(error.toString()));
    });
  }

  Future getCities({bool allowGroup = true}) async {
    cities = [];
    emit(CitiesGetLoadingState());
    await DioHelper.getDate(url: '/cities-view').then((value) {
      print(value.data.toString());
      value.data.forEach((element) {
        ProgrammeCityModel city = ProgrammeCityModel.fromJson(element);
        if(!allowGroup)
        {
          if( (!city.nameEn!.contains('&')) && (!city.nameEn!.contains('and')) )
          {
            cities.add(city);
            countries.forEach((country) {
              if (country.id == city.countryId) {
                country.cities.add(city);
              }
            });
          }
        }
        else
        {
          cities.add(city);
          countries.forEach((country) {
            if (country.id == city.countryId) {
              country.cities.add(city);
            }
          });
        }

      });
      print(cities.length);
      if (cities.isNotEmpty) {
        emit(CitiesGetSuccessState());
      } else {
        emit(CitiesGetErrorState('Sorry, server error please try again later'));
      }
    }).catchError((e) {
      print('error get cities');
      print(e.toString());
      late String error;
      if (e is DioError) {
        error = ServerFailure.fromDioError(e).errorMessage;
      } else {
        error = ServerFailure(e).errorMessage;
      }
      emit(CitiesGetErrorState(error.toString()));
    });
  }


  Future collectData(parsed)async
  {
    emit(ProgramsGetLoadingState());
    programs = [];
    specialDates = [];
    await parsed.forEach((element)  async
    {
      ProgramModel program = ProgramModel.fromJson(element);
      await DioHelper.postDate(endPoint: '/viewAirportById',
          query: {'id': program.departureFrom}).then((value) {
        print(value.toString());
        program.departureAirportModel =value.data['data']==null?null: AirportModel.fromJson(value.data['data']);
      }).catchError((error) {
        print('error');
        print(error.toString());
        //emit(ProgramsGetErrorState(error.toString()));
      });
      await DioHelper.postDate(endPoint: '/viewAirportById',
          query: {'id': program.arrivalTo}).then((value) {
        program.arrivalAirportModel =value.data['data']==null?null:  AirportModel.fromJson(value.data['data']);
      }).catchError((error) {
        print('error');
        print(error.toString());
        // emit(ProgramsGetErrorState(error.toString()));
      });
      await DioHelper.postDate(endPoint: '/viewAirportById',
          query: {'id': program.returnFrom}).then((value) {
        print(value.toString());
        program.returnFromAirportModel =value.data['data']==null?null:  AirportModel.fromJson(value.data['data']);
      }).catchError((error) {
        print('error');
        print(error.toString());
        //emit(ProgramsGetErrorState(error.toString()));
      });
      await DioHelper.postDate(endPoint: '/viewAirportById',
          query: {'id': program.returnTo}).then((value) {
        program.returnToAirportModel =value.data['data']==null?null:  AirportModel.fromJson(value.data['data']);
      }).catchError((error) {
        print('error');
        print(error.toString());
        // emit(ProgramsGetErrorState(error.toString()));
      });
      await DioHelper.postDate(endPoint: '/airline-view-by-id',
          query: {'id': program.departureAirline}).then((value) {
        program.departureAirlineModel =value.data['airline']==null?null:  AirlineModel.fromJson(value.data['airline']);
      }).catchError((error) {
        print('error');
        print(error.toString());
        // emit(ProgramsGetErrorState(error.toString()));
      });
      await DioHelper.postDate(endPoint: '/airline-view-by-id',
          query: {'id': program.returnAirline}).then((value) {
        program.returnAirlineModel =value.data['airline']==null?null: AirlineModel.fromJson(value.data['airline']);
      }).catchError((error) {
        print('error');
        print(error.toString());
        // emit(ProgramsGetErrorState(error.toString()));
      });
      programs.add(program);
      if (program.fromDate != null)
        specialDates.add(DateTime.parse(program.fromDate!));
    });

  }
  Future getPrograms() async
  {
    try {
      await DioHelper.getDate(url: '/all-program').then((value) {
        final parsed = jsonDecode(value.data.toString()).cast<Map<String, dynamic>>();
        collectData(parsed).then((value)
        {
          print('object1');
          print(programs.length);
          if (programs.isNotEmpty)
          {
            emit(ProgramsGetSuccessState());
          } else
          {
            print('12');
            //emit(ProgramsGetErrorState('Sorry, server error please try again later'));
          }
        });

      }).catchError((e) {
        late String error;
        if (e is DioError) {
          error = ServerFailure
              .fromDioError(e)
              .errorMessage;
        } else {
          error = ServerFailure(e.toString()).errorMessage;
        }
        emit(ProgramsGetErrorState(error.toString()));
      });
    }catch(e)
    {
      print('catch error get programs');
      print(e.toString());
      emit(ProgramsGetErrorState(e.toString()));
    }
  }

  void filter({
  required String city,
  required DateTime fromDate,
  required int includeFlight,
  })
  {
    emit(ProgramsFilterGetLoadingState());
    filteredPrograms=[];
    print('dd');
    print(programs.length);
    programs.forEach((element)
    {
      try
      {
        if( element.returnAirline == city &&
            DateTime.parse(element.fromDate!) == fromDate &&
            element.includesFlight! == includeFlight ) {
          filteredPrograms.add(element);
        }
      }catch(e) {
      }
    });
    if(filteredPrograms.isNotEmpty)
    {
      emit(ProgramsFilterGetSuccessState());
    }
    else
    {
      emit(ProgramsFilterSuccessNoDataState());
    }
    print('object');
    print(filteredPrograms.length);
  }


  void programBook({
    required ProgramModel programModel,
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String nationality,
    required String passport_number,
    required List<PersonName> adultsNames,
    required List<PersonName> childrenNames,
    required List<PersonName> infantsNames,
  }) async
  {
   // emit(ProgramsBookLoadingState());
    Map<String, dynamic> query ={
      'flightNumber': programModel.flightNumber,
      'firstName': first_name,
      'lastName': last_name,
      'email': email,
      'phoneNumber': phone,
      'nationality': nationality,
      'passportNumber': passport_number,
      'numberOfAdults': adultsNames.length,
      'numberOfChildren': childrenNames.length,
      'numberOfInfants': infantsNames.length,
    };
    adultsNames.forEach((element) { });

    print(adultsNames.length);
    int j=2;
    for(int i=1; i<adultsNames.length;i++)
    {
      print('object');
      query['person${j}'] = '${adultsNames[i].first.text},${adultsNames[i].last.text}-adult';
      j++;
    }
    for(int i=0; i<childrenNames.length;i++)
    {
      print('object2');
      query['person${j}'] = '${childrenNames[i].first.text},${childrenNames[i].last.text}-child';
      j++;
    }
    for(int i=0; i<infantsNames.length;i++)
    {
      print('object3');
      query['person${j}'] = '${infantsNames[i].first.text},${infantsNames[i].last.text}-infant';
      j++;
    }
    print(query.toString());
    await DioHelper.postDate(endPoint: '/program-booking',
        query: query).then((value) {
          print('object');

          //final parsed = jsonDecode(value.data.toString()).cast<String>();
         // print(value.toString());

          //print(value.data.toString());
      //emit(ProgramsBookSuccessState(value.data['message'] + '\n'+ value.data['bookingId']));
    }).catchError((error) {
      print('error');
      print(error.toString());
      if(error is DioError)
      {
        print('dio error');

        print(error.response!.statusCode);
      }
      if(error.toString() == 'DioError [bad response]: The request returned an invalid status code of 500.')
      emit(ProgramsBookErrorState('Sorry, server error try again later'));
      else
        emit(ProgramsBookErrorState('Sorry, something happened try again later'));
    });
  }

  Future<ProgrammeCityModel?> getCityByID() async {
    // todo
    await DioHelper.postDate(endPoint: '/city-by-id').
    then((value) {
      ProgrammeCityModel cityModel = ProgrammeCityModel.fromJson(value.data);
      return cityModel;
    });
    return null;
  }

  Future<CountryModel?> getCountryByID() async {
    await DioHelper.postDate(endPoint: '/country-by-id').
    then((value) {
      CountryModel countryModel = CountryModel.fromJson(value.data['country']);
      return countryModel;
    });
    return null;
  }
}



