import 'dart:typed_data';

import 'package:dio/dio.dart';

class HotelCityModel {
  int? id;
  String? name;
  String? nameEn;
  String? img;
  int? countryId;
  String? countryName;
  String? countryNameEn;
  String? createdAt;
  String? updatedAt;
  Uint8List? imageUpload;

  HotelCityModel(
      {this.id,
      this.name,
      this.nameEn,
      this.img,
      this.countryId,
      this.createdAt,
      this.updatedAt});

  HotelCityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    img = json['img'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['img'] = this.img;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonWithImage() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['img'] = MultipartFile.fromBytes(imageUpload!, filename: 'first.jpg');
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
