import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/swiper_widget.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';

import 'travel_body_container.dart';

class TravelViewBody extends StatefulWidget {
  const TravelViewBody({Key? key}) : super(key: key);

  @override
  State<TravelViewBody> createState() => _TravelViewBodyState();
}

List<String> swiperImages = [
  'assets/images/t1.jpg',
  'assets/images/t2.jpg',
  'assets/images/t3.jpg',
  'assets/images/t4.jpg'
];

class _TravelViewBodyState extends State<TravelViewBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, text: TranslationKeyManager.flightTitle.tr),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SwiperWidget(
              offerImages: swiperImages,
            ),
            const SizedBox(
              height: 10,
            ),
            const TravelBodyContainer(),
          ],
        ),
      ),
    );
  }
}
