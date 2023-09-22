import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/default_button.dart';
import 'package:seasons/core/core_widgets/defaultrating.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';
import 'package:seasons/features/hotels/presentation/views/book_view.dart';

import '../../../../core/core_widgets/list_item_image.dart';
import '../../../../core/resources_manager/delay_manager.dart';
import '../../../../core/resources_manager/style_manager.dart';

class HotelDetailsView extends StatelessWidget {
  const HotelDetailsView({Key? key, required this.hotel}) : super(key: key);

  final HotelModel hotel;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: defaultAppBar(
          context: context,
          text: TranslationKeyManager.hotelDetails.tr,
          ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                        top: 5,
                      ),
                      height: height / 3,
                      child: ListItemImage(
                        image: 'https://api.seasonsge.com/${hotel.mainImage!}',
                        isHotelDetails: true,
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8, left: 12),
                    child: Column(
                      children: [
                        Text(
                          CacheData.lang ==
                                  TranslationKeyManager.localeAR.toString()
                              ? hotel.name!
                              : hotel.nameEn!,
                          style: StyleManager.hotelItemTitle
                              .copyWith(fontSize: 22),
                        ),
                        DefaultRating(rate: double.parse(hotel.rating!)),
                        Text(hotel.city!,
                            style: StyleManager.hotelItemTitle.copyWith(
                                fontSize: 22,
                                color: ColorsManager.hotelItemExtraTitle)),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          CacheData.lang ==
                                  TranslationKeyManager.localeAR.toString()
                              ? hotel.details!
                              : hotel.detailsEn!,
                          textAlign: TextAlign.start,
                          style: StyleManager.hotelItemDetailsDesc,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            elevation: 20,
            child: Container(
              width: double.infinity,
              height: 60,
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 120, vertical: 12),
              child: DefaultButton(
                  text: TranslationKeyManager.bookNow.tr,
                  onPressed: () {
                    Get.to(() => BookView(hotel: hotel),
                        transition: DelayManager.transitionToBook,
                        duration: DelayManager.durationTransitionToBook,
                        curve: DelayManager.curveToBook);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
