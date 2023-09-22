class CarsModel {
  String? id;
  String? typeId;
  String? tax;
  String? pricePerDay;
  String? priceWithDriver;
  String? imagePath;
  String? status;

  CarsModel(
      {this.id,
      this.typeId,
      this.tax,
      this.pricePerDay,
      this.priceWithDriver,
      this.imagePath,
      this.status});

  CarsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'];
    tax = json['tax'];
    pricePerDay = json['price_per_day'];
    priceWithDriver = json['price_with_driver'];
    imagePath = json['image_path'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['tax'] = this.tax;
    data['price_per_day'] = this.pricePerDay;
    data['price_with_driver'] = this.priceWithDriver;
    data['image_path'] = this.imagePath;
    data['status'] = this.status;
    return data;
  }
}
