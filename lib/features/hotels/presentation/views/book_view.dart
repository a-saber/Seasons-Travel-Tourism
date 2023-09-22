import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';

import '../../../../core/core_widgets/book_upper_part.dart';
import 'widgets/hotel_details/hotel_book_lower_part.dart';

class BookView extends StatelessWidget {
  const BookView({Key? key, required this.hotel}) : super(key: key);
  final HotelModel hotel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
          context: context,
          text: TranslationKeyManager.hotelBook.tr,
          ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          BookUpperPart(
            image: 'https://api.seasonsge.com/${hotel.mainImage!}',
            pageTitle: TranslationKeyManager.hotelBook.tr,
            pageTitlePath: TranslationKeyManager.hotels.tr,
          ),
          const SizedBox(
            height: 20,
          ),
          HotelBookLowerPart(hotel: hotel)
        ],
      )),
    );
  }
}
