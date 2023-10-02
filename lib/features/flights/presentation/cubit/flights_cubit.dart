import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/core/errors/failures.dart';
import 'package:seasons/features/airports/data/models/airport_model.dart';
import 'package:seasons/features/flights/data/models/flight_model.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_states.dart';
import 'package:seasons/features/flights/presentation/views/flight_passenger_data.dart';

class FlightsCubit extends Cubit<FlightsStates> {
  FlightsCubit() : super(FlightsInitialState());

  static FlightsCubit get(context) => BlocProvider.of(context);
  List<FlightModel> flights = [];
  List<FlightModel> flightsFiltered = [];
  List<FlightModel> flightsNotMatch = [];
  List<DateTime> specialDates =[];
  int adults = 1;
  int infants = 0;
  int kids = 0;
  void passengersSetter(
      {required int adults, required int infants, required int kids}) {
    this.adults = adults;
    this.infants = infants;
    this.kids = kids;
    emit(FlightsPassengersSetterState());
  }

  Future getFlights() async {
    flights = [];
    specialDates = [];
    emit(FlightsGetLoadingState());
    try {
      await DioHelper.getDate(url: '/flights?all').then((value) async {
        final parsed = jsonDecode(value.data.toString()).cast<Map<String, dynamic>>();
        print(parsed.toString());
        print(parsed.length);
          for(int i =0;i<parsed.length;i++) {
            FlightModel flightModel = FlightModel.fromJson(parsed[i]);
            if (DateTime.parse(flightModel.departureDate!).isAfter(
                DateTime.now()) ||
                DateTime.parse(flightModel.departureDate!) == DateTime.now())
            {
              specialDates.add(DateTime.parse(flightModel.departureDate!));
              specialDates.add(DateTime.parse(flightModel.returnStartDate!));
              print('+++++');
              await DioHelper.postDate(endPoint: '/viewAirportById',
                  query: {'id': flightModel.fromAirport.toString()}).then((value) {
                print(value.toString());
                flightModel.from = AirportModel.fromJson(value.data['data']);
              }).catchError((error) {
                print('error');
                print(error.toString());
                emit(FlightsGetErrorState(error.toString()));
              });
              await DioHelper.postDate(endPoint: '/viewAirportById',
                  query: {'id': flightModel.toAirport.toString()}).then((value) {
                flightModel.to = AirportModel.fromJson(value.data['data']);
              }).catchError((error) {
                print('error');
                print(error.toString());
                emit(FlightsGetErrorState(error.toString()));
              });
              await DioHelper.postDate(endPoint: '/airline-view-by-id',
                  query: {'id': flightModel.flightLine.toString()}).then((value) {
                flightModel.airlineModel =
                    AirlineModel.fromJson(value.data['airline']);
              }).catchError((error) {
                print('error');
                print(error.toString());
                emit(FlightsGetErrorState(error.toString()));
              });
              flights.add(flightModel);
          }
        }
          //);
        print(flights.length);
        emit(FlightsGetSuccessState());
      }).catchError((e) {
        print('error get flights');
        print(e.toString());
        late String error;
        if (e is DioError) {
          error = ServerFailure
              .fromDioError(e)
              .errorMessage;
        } else {
          error = ServerFailure(e).errorMessage;
        }
        emit(FlightsGetErrorState(error.toString()));
      });
    }catch(e)
    {
      emit(FlightsGetErrorState(e.toString()));
    }
  }

  Future<FlightModel?> getFlightByID(String id) async {
    try {
      var value = await DioHelper.getDate(url: '/flights', query: {"flight_id":id});
      final parsed = jsonDecode(value.data.toString());

          FlightModel flightModel = FlightModel.fromJson(parsed);
          if (DateTime.parse(flightModel.departureDate!).isAfter(
              DateTime.now()) ||
              DateTime.parse(flightModel.departureDate!) == DateTime.now())
          {
            specialDates.add(DateTime.parse(flightModel.departureDate!));
            specialDates.add(DateTime.parse(flightModel.returnStartDate!));
            var fromAirport =await DioHelper.postDate(endPoint: '/viewAirportById',
                query: {'id': flightModel.fromAirport.toString()});
            flightModel.from = AirportModel.fromJson(fromAirport.data['data']);

            var toAirport =await DioHelper.postDate(endPoint: '/viewAirportById',
                query: {'id': flightModel.toAirport.toString()});
            flightModel.to = AirportModel.fromJson(toAirport.data['data']);
            var airLine =await DioHelper.postDate(endPoint: '/airline-view-by-id',
                query: {'id': flightModel.flightLine.toString()});
            flightModel.airlineModel = AirlineModel.fromJson(airLine.data['airline']);
            return flightModel;
          }
    }catch(e)
    {
      print(e.toString());
      return null;
    }
    return null;
  }

  void filter({
    required int from,
    required int to,
    required DateTime? returnDate,
    required DateTime departureDate,
    required int allowReturn,
    required int ticketsNumber,
  }) {
    try {
      print(flights.length);
      if (flights.isNotEmpty) {
        emit(FlightsGetLoadingState());
        flightsFiltered = [];
        flightsNotMatch = [];
        flights.forEach((element) {
          if ( returnDate ==null &&
          departureDate == DateTime.parse(element.departureDate!) &&
              from == element.fromAirport &&
              to == element.toAirport &&
              allowReturn == element.allowReturn &&
              ticketsNumber <= element.numTickets!
          )
          {
            flightsFiltered.add(element);
          }
          else if (
          departureDate == DateTime.parse(element.departureDate!) &&
              returnDate == DateTime.parse(element.returnStartDate!) &&
              from == element.fromAirport &&
              to == element.toAirport &&
              allowReturn == element.allowReturn &&
              ticketsNumber <= element.numTickets!
          )
          {
            flightsFiltered.add(element);
          }
          if(from == element.fromAirport &&
              to == element.toAirport)
          {
            flightsNotMatch.add(element);
          }
        });
        if (flightsFiltered.isNotEmpty) {
          emit(FlightsFilterSuccessState());
        } else {
          emit(FlightsFilterSuccessWithNoDataState());
        }
        print(flightsFiltered.length);
      }
    }catch(e)
    {
      emit(FlightsFilterErrorState('Sorry, something went wrong'));
    }
  }

  void bookFlight({
    required String flight_number,
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
    emit(FlightsBookLoadingState());
    Map<String, dynamic> query ={
      'flight_number': flight_number,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone': phone,
      'nationality': nationality,
      'passport_number': passport_number,
      'numberOfAdults': adultsNames.length,
      'numberOfChildren': childrenNames.length,
      'numberOfInfants': infantsNames.length,
    };
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
    await DioHelper.postDate(endPoint: '/flight-booking',
        query: query).then((value) {
      print(value.toString());
      emit(FlightsBookSuccessState(value.data['message'] + '\n'+ value.data['bookingId']));
    }).catchError((error) {
      print('error');
      print(error.toString());
      emit(FlightsBookErrorState(error.toString()));
    });
  }
}

// DateTime userStartDate = DateTime.parse(startDate);
// DateTime userDepDate = DateTime.parse(departureDate);
