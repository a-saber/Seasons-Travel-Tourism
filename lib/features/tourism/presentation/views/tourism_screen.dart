import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/features/tourism/presentation/views/widgets/tourism_container_body.dart';

import '../../../../core/core_widgets/swiper_widget.dart';

class TourismScreen extends StatefulWidget {
  const TourismScreen({Key? key}) : super(key: key);

  @override
  State<TourismScreen> createState() => _TourismScreenState();
}

List<String> swiperImages =
[
  'assets/images/t1.jpg',
  'assets/images/t2.jpg',
  'assets/images/t3.jpg',
  'assets/images/t4.jpg'
];

class _TourismScreenState extends State<TourismScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, text: TranslationKeyManager.tourismTitle.tr),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 10.0,
            right: 10.0,
            left: 10.0,
            bottom: 25.0,
        ),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            SwiperWidget(
              offerImages: swiperImages,
            ),
            const SizedBox(
              height: 10,
            ),
            const TourismContainerBody(),
          ],
        ),
      ),
    );
  }
}
