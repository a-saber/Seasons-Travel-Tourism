class CarTypes {
  var id;
  String? name;
  String? nameEn;

  CarTypes({this.id, this.name, this.nameEn});

  CarTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    return data;
  }
}

class CarTypeSearch {
  String? id;
  String? name;
  String? nameEn;
  String? img;

  CarTypeSearch({this.id, this.name, this.nameEn, this.img});

  CarTypeSearch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['img'] = this.img;
    return data;
  }
}
