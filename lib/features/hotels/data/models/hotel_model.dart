import 'city_model.dart';

class GetHotelsModel {
  bool? success;
  List<HotelModel>? hotels;
  var date;

  GetHotelsModel({this.success, this.hotels});

  GetHotelsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    date = json['data'];
    // if (json['data'] != null) {
    //   hotels = <HotelModel>[];
    //   json['data'].forEach((v) {
    //     hotels!.add(new HotelModel.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.hotels != null) {
      data['data'] = this.hotels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HotelModel {
  int? id;
  String? city;
  HotelCityModel? cityModel;
  String? hotelType;
  String? rating;
  String? name;
  String? nameEn;
  String? singlePrice;
  String? doublePrice;
  String? triplePrice;
  String? childNoBedPrice;
  String? childWithBedPrice;
  String? tax;
  String? details;
  String? detailsEn;
  String? address;
  String? addressEn;
  String? mainImage;
  String? additionalImage;
  int? status;

  HotelModel(
      {this.id,
        this.city,
        this.hotelType,
        this.rating,
        this.name,
        this.nameEn,
        this.singlePrice,
        this.doublePrice,
        this.triplePrice,
        this.childNoBedPrice,
        this.childWithBedPrice,
        this.tax,
        this.details,
        this.detailsEn,
        this.address,
        this.addressEn,
        this.mainImage,
        this.additionalImage,
        this.cityModel,
        this.status});

  HotelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    hotelType = json['hotel_type'];
    rating = json['rating'];
    name = json['name'];
    nameEn = json['name_en'];
    singlePrice = json['single_price'];
    doublePrice = json['double_price'];
    triplePrice = json['triple_price'];
    childNoBedPrice = json['child_no_bed_price'];
    childWithBedPrice = json['child_with_bed_price'];
    tax = json['tax'];
    details = json['details'];
    detailsEn = json['details_en'];
    address = json['address'];
    addressEn = json['address_en'];
    mainImage = json['main_image'];
    additionalImage = json['additional_image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['hotel_type'] = this.hotelType;
    data['rating'] = this.rating;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['single_price'] = this.singlePrice;
    data['double_price'] = this.doublePrice;
    data['triple_price'] = this.triplePrice;
    data['child_no_bed_price'] = this.childNoBedPrice;
    data['child_with_bed_price'] = this.childWithBedPrice;
    data['tax'] = this.tax;
    data['details'] = this.details;
    data['details_en'] = this.detailsEn;
    data['address'] = this.address;
    data['address_en'] = this.addressEn;
    data['main_image'] = this.mainImage;
    data['additional_image'] = this.additionalImage;
    data['status'] = this.status;
    return data;
  }
}
