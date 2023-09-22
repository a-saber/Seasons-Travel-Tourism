class AboutModel {
  int? id;
  String? image;
  String? title1Ar;
  String? title1En;
  String? details1Ar;
  String? details1En;
  String? title2Ar;
  String? title2En;
  String? details2Ar;
  String? details2En;
  String? titleSectionAr;
  String? titleSectionEn;
  String? title3Ar;
  String? title3En;
  String? details3En;
  String? details3Ar;

  AboutModel(
      {this.id,
        this.image,
        this.title1Ar,
        this.title1En,
        this.details1Ar,
        this.details1En,
        this.title2Ar,
        this.title2En,
        this.details2Ar,
        this.details2En,
        this.titleSectionAr,
        this.titleSectionEn,
        this.title3Ar,
        this.title3En,
        this.details3En,
        this.details3Ar});

  AboutModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title1Ar = json['title1_ar'];
    title1En = json['title1_en'];
    details1Ar = json['details1_ar'];
    details1En = json['details1_en'];
    title2Ar = json['title2_ar'];
    title2En = json['title2_en'];
    details2Ar = json['details2_ar'];
    details2En = json['details2_en'];
    titleSectionAr = json['title_section_ar'];
    titleSectionEn = json['title_section_en'];
    title3Ar = json['title3_ar'];
    title3En = json['title3_en'];
    details3En = json['details3_en'];
    details3Ar = json['details3_ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['title1_ar'] = this.title1Ar;
    data['title1_en'] = this.title1En;
    data['details1_ar'] = this.details1Ar;
    data['details1_en'] = this.details1En;
    data['title2_ar'] = this.title2Ar;
    data['title2_en'] = this.title2En;
    data['details2_ar'] = this.details2Ar;
    data['details2_en'] = this.details2En;
    data['title_section_ar'] = this.titleSectionAr;
    data['title_section_en'] = this.titleSectionEn;
    data['title3_ar'] = this.title3Ar;
    data['title3_en'] = this.title3En;
    data['details3_en'] = this.details3En;
    data['details3_ar'] = this.details3Ar;
    return data;
  }
}
