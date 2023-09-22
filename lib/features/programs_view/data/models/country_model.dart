import 'city_model.dart';

class CountryModel {
  int? id;
  String? name;
  String? nameEn;
  String? img;
  String? createdAt;
  String? updatedAt;
  List<ProgrammeCityModel> cities = [];

  CountryModel(
      {this.id,
      this.name,
      this.nameEn,
      this.img,
      this.createdAt,
      this.updatedAt});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
