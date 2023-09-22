class TermsModel {
  int? id;
  String? termsAndConditionsAr;
  String? termsAndConditionsEn;

  TermsModel({this.id, this.termsAndConditionsAr, this.termsAndConditionsEn});

  TermsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    termsAndConditionsAr = json['termsAndConditions_ar'];
    termsAndConditionsEn = json['termsAndConditions_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['termsAndConditions_ar'] = termsAndConditionsAr;
    data['termsAndConditions_en'] = termsAndConditionsEn;
    return data;
  }
}
