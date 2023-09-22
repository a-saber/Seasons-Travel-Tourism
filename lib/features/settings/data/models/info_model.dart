import 'package:flutter/cupertino.dart';

class InfoModel {
  int? id;
  String? facebook;
  String? twitter;
  String? whatsapp;
  String? instagram;
  String? snapchat;
  String? tiktok;
  String? messenger;
  String? telegram;
  String? youtube;
  String? arabicTitle;
  String? englishTitle;
  String? copyright;
  String? email;
  String? mobileNumber;
  String? logo;
  String? favicon;
  String? googlePlayLink;
  String? appStoreLink;
  String? latitude;
  String? longitude;

  InfoModel({
    this.id,
    this.facebook,
    this.twitter,
    this.whatsapp,
    this.instagram,
    this.snapchat,
    this.tiktok,
    this.messenger,
    this.telegram,
    this.youtube,
    this.arabicTitle,
    this.englishTitle,
    this.copyright,
    this.email,
    this.mobileNumber,
    this.logo,
    this.favicon,
    this.googlePlayLink,
    this.appStoreLink,
    this.latitude,
    this.longitude,
  });

  InfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    whatsapp = json['whatsapp'];
    instagram = json['instagram'];
    snapchat = json['snapchat'];
    tiktok = json['tiktok'];
    messenger = json['messenger'];
    telegram = json['telegram'];
    youtube = json['youtube'];
    arabicTitle = json['arabic_title'];
    englishTitle = json['english_title'];
    copyright = json['copyright'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    logo = json['logo'];
    favicon = json['favicon'];
    googlePlayLink = json['google_play_link'];
    appStoreLink = json['app_store_link'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['whatsapp'] = whatsapp;
    data['instagram'] = instagram;
    data['snapchat'] = snapchat;
    data['tiktok'] = tiktok;
    data['messenger'] = messenger;
    data['telegram'] = telegram;
    data['youtube'] = youtube;
    data['arabic_title'] = arabicTitle;
    data['english_title'] = englishTitle;
    data['copyright'] = copyright;
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['logo'] = logo;
    data['favicon'] = favicon;
    data['google_play_link'] = googlePlayLink;
    data['app_store_link'] = appStoreLink;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }

  Map<String, dynamic> toJsonWithImage(BuildContext context, bool kIsWeb) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['whatsapp'] = whatsapp;
    data['instagram'] = instagram;
    data['snapchat'] = snapchat;
    data['tiktok'] = tiktok;
    data['messenger'] = messenger;
    data['telegram'] = telegram;
    data['youtube'] = youtube;
    data['arabic_title'] = arabicTitle;
    data['english_title'] = englishTitle;
    data['copyright'] = copyright;
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['logo'] = logo;
    data['favicon'] = favicon;
    data['google_play_link'] = googlePlayLink;
    data['app_store_link'] = appStoreLink;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
