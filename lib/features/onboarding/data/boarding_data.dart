import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';

import 'boarding_model.dart';

class BoardingData {
  static List<boardingModel> boarding = [
    boardingModel(
        image: 'assets/images/p1.jpg',
        title: TranslationKeyManager.onBoardBookInquiry,
        buttonText: TranslationKeyManager.onBoardBookInquiryBtn),
    boardingModel(
        image: 'assets/images/p2.jpg',
        title: TranslationKeyManager.onBoardBookFlightTitle,
        subTitle: TranslationKeyManager.onBoardBookFlight,
        buttonText: TranslationKeyManager.onBoardBookFlightBtn),
    boardingModel(
        image: 'assets/images/p3.jpg',
        title: TranslationKeyManager.onBoardBookTourismTitle,
        subTitle: TranslationKeyManager.onBoardBookTourism,
        buttonText: TranslationKeyManager.onBoardBookTourismBtn),
    boardingModel(
        image: 'assets/images/p4.jpg',
        title:  TranslationKeyManager.onBoardBookHotelsTitle,
        subTitle:  TranslationKeyManager.onBoardBookHotels,
        buttonText:  TranslationKeyManager.onBoardBookHotelsBtn),
    boardingModel(
        image: 'assets/images/p5.jpg',
        title:  TranslationKeyManager.onBoardBookCarsTitle,
        subTitle: TranslationKeyManager.onBoardBookCars,
        buttonText:  TranslationKeyManager.onBoardBookCarsBtn),
    boardingModel(
        image: 'assets/images/logo.PNG',
        title: TranslationKeyManager.onBoardShowMore,
        buttonText: TranslationKeyManager.onBoardSkipBtn),
  ];
}
