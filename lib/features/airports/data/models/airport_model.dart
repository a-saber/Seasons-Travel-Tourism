class AirportsResponse {
  bool? success;
  List<AirportModel>? data;

  AirportsResponse({this.success, this.data});

  AirportsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <AirportModel>[];
      json['data'].forEach((v) {
        data!.add(new AirportModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AirportModel {
  int? id;
  String? arabicName;
  String? englishName;

  AirportModel({this.id, this.arabicName, this.englishName});

  AirportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    arabicName = json['arabic_name'];
    englishName = json['english_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['arabic_name'] = this.arabicName;
    data['english_name'] = this.englishName;
    return data;
  }
}
class AirlineModel {
  int? id;
  String? nameAr;
  String? nameEn;
  String? image;

  AirlineModel({this.id, this.nameAr, this.nameEn});

  AirlineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_ar'] = this.nameAr;
    data['name_en'] = this.nameEn;
    data['image'] = this.image;
    return data;
  }
}
