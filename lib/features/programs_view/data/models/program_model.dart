import 'package:seasons/features/airports/data/models/airport_model.dart';

class ProgramModel {

  AirportModel? departureAirportModel;
  AirportModel? arrivalAirportModel;
  AirportModel? returnFromAirportModel;
  AirportModel? returnToAirportModel;
  AirlineModel? departureAirlineModel;
  AirlineModel? returnAirlineModel;

  int? id;
  String? programTitleArabic;
  String? programTitleEnglish;
  int? numOfDays;
  int? numOfNights;
  String? fromDate;
  String? toDate;
  String? carType;
  String? mealType;
  int? includesFlight;
  String? departureAirline;
  String? departureFrom;
  String? arrivalTo;
  String? departureTime;
  String? arrivalTime;
  String? flightNumber;
  int? allowedWeightKg;
  String? returnAirline;
  String? returnFrom;
  String? returnTo;
  String? returnDepartureTime;
  String? returnArrivalTime;
  String? returnFlightNumber;
  int? returnAllowedWeightKg;
  String? pricePerAdultIndividual;
  String? pricePerAdultDouble;
  String? pricePerAdultTriple;
  String? pricePerChildNoBed;
  String? pricePerChildWithBed;
  String? pricePerInfant;
  String? tax;
  String? programDetailsArabic;
  String? programDetailsEnglish;
  String? mainImage;
  String? detailsImage;

  ProgramModel(
      {this.id,
        this.programTitleArabic,
        this.programTitleEnglish,
        this.numOfDays,
        this.numOfNights,
        this.fromDate,
        this.toDate,
        this.carType,
        this.mealType,
        this.includesFlight,
        this.departureAirline,
        this.departureFrom,
        this.arrivalTo,
        this.departureTime,
        this.arrivalTime,
        this.flightNumber,
        this.allowedWeightKg,
        this.returnAirline,
        this.returnFrom,
        this.returnTo,
        this.returnDepartureTime,
        this.returnArrivalTime,
        this.returnFlightNumber,
        this.returnAllowedWeightKg,
        this.pricePerAdultIndividual,
        this.pricePerAdultDouble,
        this.pricePerAdultTriple,
        this.pricePerChildNoBed,
        this.pricePerChildWithBed,
        this.pricePerInfant,
        this.tax,
        this.programDetailsArabic,
        this.programDetailsEnglish,
        this.mainImage,
        this.detailsImage});

  ProgramModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programTitleArabic = json['program_title_arabic'];
    programTitleEnglish = json['program_title_english'];
    numOfDays = json['num_of_days'];
    numOfNights = json['num_of_nights'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    carType = json['car_type'];
    mealType = json['meal_type'];
    includesFlight = json['includes_flight'];
    departureAirline = json['departure_airline'];
    departureFrom = json['departure_from'];
    arrivalTo = json['arrival_to'];
    departureTime = json['departure_time'];
    arrivalTime = json['arrival_time'];
    flightNumber = json['flight_number'];
    allowedWeightKg = json['allowed_weight_kg'];
    returnAirline = json['return_airline'];
    returnFrom = json['return_from'];
    returnTo = json['return_to'];
    returnDepartureTime = json['return_departure_time'];
    returnArrivalTime = json['return_arrival_time'];
    returnFlightNumber = json['return_flight_number'];
    returnAllowedWeightKg = json['return_allowed_weight_kg'];
    pricePerAdultIndividual = json['price_per_adult_individual'];
    pricePerAdultDouble = json['price_per_adult_double'];
    pricePerAdultTriple = json['price_per_adult_triple'];
    pricePerChildNoBed = json['price_per_child_no_bed'];
    pricePerChildWithBed = json['price_per_child_with_bed'];
    pricePerInfant = json['price_per_infant'];
    tax = json['tax'];
    programDetailsArabic = json['program_details_arabic'];
    programDetailsEnglish = json['program_details_english'];
    mainImage = json['main_image'];
    detailsImage = json['details_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['program_title_arabic'] = this.programTitleArabic;
    data['program_title_english'] = this.programTitleEnglish;
    data['num_of_days'] = this.numOfDays;
    data['num_of_nights'] = this.numOfNights;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['car_type'] = this.carType;
    data['meal_type'] = this.mealType;
    data['includes_flight'] = this.includesFlight;
    data['departure_airline'] = this.departureAirline;
    data['departure_from'] = this.departureFrom;
    data['arrival_to'] = this.arrivalTo;
    data['departure_time'] = this.departureTime;
    data['arrival_time'] = this.arrivalTime;
    data['flight_number'] = this.flightNumber;
    data['allowed_weight_kg'] = this.allowedWeightKg;
    data['return_airline'] = this.returnAirline;
    data['return_from'] = this.returnFrom;
    data['return_to'] = this.returnTo;
    data['return_departure_time'] = this.returnDepartureTime;
    data['return_arrival_time'] = this.returnArrivalTime;
    data['return_flight_number'] = this.returnFlightNumber;
    data['return_allowed_weight_kg'] = this.returnAllowedWeightKg;
    data['price_per_adult_individual'] = this.pricePerAdultIndividual;
    data['price_per_adult_double'] = this.pricePerAdultDouble;
    data['price_per_adult_triple'] = this.pricePerAdultTriple;
    data['price_per_child_no_bed'] = this.pricePerChildNoBed;
    data['price_per_child_with_bed'] = this.pricePerChildWithBed;
    data['price_per_infant'] = this.pricePerInfant;
    data['tax'] = this.tax;
    data['program_details_arabic'] = this.programDetailsArabic;
    data['program_details_english'] = this.programDetailsEnglish;
    data['main_image'] = this.mainImage;
    data['details_image'] = this.detailsImage;
    return data;
  }
}
