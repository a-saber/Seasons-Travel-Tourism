import 'package:seasons/features/airports/data/models/airport_model.dart';

class FlightModel {
  AirportModel? from;
  AirportModel? to;
  AirlineModel? airlineModel;


  int? id;
  String? flightNumber;
  String? allowedWeight;
  int? flightLine;
  int? fromAirport;
  int? toAirport;
  String? departureDate;
  String? durationHours;
  String? departureTime;
  String? arrivalTime;
  int? numStops;
  String? adultPrice;
  String? infantPrice;
  String? childPrice;
  int? numTickets;
  int? numReturnTickets;
  String? tax;
  int? allowReturn;
  String? returnStartDate;
  String? returnEndDate;
  int? arrivalFromReturn;
  int? departureToReturn;
  String? allowedWeightReturn;
  String? returnFlightNumber;
  String? createdAt;
  String? returnEndDate1;
  String? returnEndDate2;
  String? arrivDate22;

  FlightModel(
      {this.id,
        this.flightNumber,
        this.allowedWeight,
        this.flightLine,
        this.fromAirport,
        this.toAirport,
        this.departureDate,
        this.durationHours,
        this.departureTime,
        this.arrivalTime,
        this.numStops,
        this.adultPrice,
        this.infantPrice,
        this.childPrice,
        this.numTickets,
        this.numReturnTickets,
        this.tax,
        this.allowReturn,
        this.returnStartDate,
        this.returnEndDate,
        this.arrivalFromReturn,
        this.departureToReturn,
        this.allowedWeightReturn,
        this.returnFlightNumber,
        this.createdAt,
        this.returnEndDate1,
        this.returnEndDate2,
        this.arrivDate22});

  FlightModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flightNumber = json['flightNumber'];
    allowedWeight = json['allowedWeight'];
    flightLine = json['flightLine'];
    fromAirport = json['fromAirport'];
    toAirport = json['toAirport'];
    departureDate = json['departureDate'];
    durationHours = json['durationHours'];
    departureTime = json['departureTime'];
    arrivalTime = json['arrivalTime'];
    numStops = json['numStops'];
    adultPrice = json['adultPrice'];
    infantPrice = json['infantPrice'];
    childPrice = json['childPrice'];
    numTickets = json['numTickets'];
    numReturnTickets = json['numReturnTickets'];
    tax = json['tax'];
    allowReturn = json['allowReturn'];
    returnStartDate = json['returnStartDate'];
    returnEndDate = json['returnEndDate'];
    arrivalFromReturn = json['arrivalFromReturn'];
    departureToReturn = json['departureToReturn'];
    allowedWeightReturn = json['allowedWeightReturn'];
    returnFlightNumber = json['returnFlightNumber'];
    createdAt = json['created_at'];
    returnEndDate1 = json['returnEndDate1'];
    returnEndDate2 = json['returnEndDate2'];
    arrivDate22 = json['arrivDate22'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['flightNumber'] = this.flightNumber;
    data['allowedWeight'] = this.allowedWeight;
    data['flightLine'] = this.flightLine;
    data['fromAirport'] = this.fromAirport;
    data['toAirport'] = this.toAirport;
    data['departureDate'] = this.departureDate;
    data['durationHours'] = this.durationHours;
    data['departureTime'] = this.departureTime;
    data['arrivalTime'] = this.arrivalTime;
    data['numStops'] = this.numStops;
    data['adultPrice'] = this.adultPrice;
    data['infantPrice'] = this.infantPrice;
    data['childPrice'] = this.childPrice;
    data['numTickets'] = this.numTickets;
    data['numReturnTickets'] = this.numReturnTickets;
    data['tax'] = this.tax;
    data['allowReturn'] = this.allowReturn;
    data['returnStartDate'] = this.returnStartDate;
    data['returnEndDate'] = this.returnEndDate;
    data['arrivalFromReturn'] = this.arrivalFromReturn;
    data['departureToReturn'] = this.departureToReturn;
    data['allowedWeightReturn'] = this.allowedWeightReturn;
    data['returnFlightNumber'] = this.returnFlightNumber;
    data['created_at'] = this.createdAt;
    data['returnEndDate1'] = this.returnEndDate1;
    data['returnEndDate2'] = this.returnEndDate2;
    data['arrivDate22'] = this.arrivDate22;
    return data;
  }
}

