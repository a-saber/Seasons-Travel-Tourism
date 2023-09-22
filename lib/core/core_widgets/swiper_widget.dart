import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:seasons/core/utils.dart';


class SwiperWidget extends StatelessWidget {
  const SwiperWidget({Key? key, required this.offerImages}) : super(key: key);
  final List<String> offerImages;
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).screenSize;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: size.height * .2,
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(20)),
      child: Swiper(
        itemBuilder: (context, index) {
          return Image.asset(
            offerImages[index],
            fit: BoxFit.cover,
          );
        },
        //indicatorLayout: PageIndicatorLayout.COLOR,
        autoplay: true,
        itemCount: offerImages.length,
        // pagination: const SwiperPagination(
        //   alignment: Alignment.bottomCenter,
        //   builder: DotSwiperPaginationBuilder(
        //     color: Colors.white,
        //     activeColor: Colors.red,
        //   ),
        // ),
      ),
    );
  }
}
