class PrivacyModel {
  int? id;
  String? privacypolicyAr;
  String? privacypolicyEn;

  PrivacyModel({this.id, this.privacypolicyAr, this.privacypolicyEn});

  PrivacyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    privacypolicyAr = json['privacypolicy_ar'];
    privacypolicyEn = json['privacypolicy_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['privacypolicy_ar'] = privacypolicyAr;
    data['privacypolicy_en'] = privacypolicyEn;
    return data;
  }
}
