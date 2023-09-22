import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';

import '../../../../core/core_widgets/book_upper_part.dart';
import '../../../../core/core_widgets/default_app_bar.dart';
import '../../data/models/cars_model.dart';
import 'widgets/car_book_lower_part.dart';

class CarDetailsView extends StatelessWidget {
  const CarDetailsView({Key? key, required this.cars}) : super(key: key);
  final CarsModel cars;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
          context: context,
          text: TranslationKeyManager.carBook.tr,
          hasLeading: true),
      body: SingleChildScrollView(
          child: Column(
        children: [
          BookUpperPart(
            image: "https://api.seasonsge.com/images/${cars.imagePath!}",
            pageTitle: TranslationKeyManager.carBook.tr,
            pageTitlePath: TranslationKeyManager.cars.tr,
          ),
          const SizedBox(
            height: 20,
          ),
          CarBookLowerPart(
            bookCar: cars,
          )
        ],
      )),
    );
  }
}
