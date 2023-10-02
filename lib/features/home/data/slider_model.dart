import 'package:seasons/features/airports/data/models/airport_model.dart';
import 'package:seasons/features/cars/data/models/cars_model.dart';
import 'package:seasons/features/flights/data/models/flight_model.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';
import 'package:seasons/features/programs_view/data/models/program_model.dart';

enum SliderTypes {flight, program, car, hotel}

class SliderModel {

  late SliderTypes sliderType;
  FlightModel? flightModel;
  ProgramModel? programModel;
  CarSearchModel? carModel;
  HotelModel? hotelModel;

  String? id;
  String? text;
  String? imagePath;
  String? link;

  SliderModel({
        this.id,
        this.imagePath,
        this.link,
        this.text
  });

  SliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagePath = json['image_path'];
    link = json['link'];
    text = json['text'];
  }
}

