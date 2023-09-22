import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/app_cubit/app_cubit.dart';
import 'package:seasons/features/cars/presentation/views/cars_view.dart';
import 'package:seasons/features/hotels/presentation/views/hotels_view.dart';

import '../../../../../core/resources_manager/colors_manager.dart';
import '../../../../../core/resources_manager/style_manager.dart';
import '../../../../book_info/presentaion/views/book_infor_screen.dart';
import '../../../../travel/presentation/views/travel_screen.dart';
import '../../../data/boarding_model.dart';

class BoardItem extends StatelessWidget {
  const BoardItem({Key? key, required this.model, required this.index})
      : super(key: key);
  final boardingModel model;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            height: 180,
            child: Image(
              image: AssetImage(
                model.image,
              ),
              width: 200,
            )),
        const SizedBox(
          height: 90,
        ),
        Text(
          model.title.tr,
          style: StyleManager.textStyle4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10,),
        model.subTitle == null
            ? const SizedBox()
            : Text(
                model.subTitle!.tr,
                style: StyleManager.textStyle5,
          textAlign: TextAlign.center,
              ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 75.0),
          child: MaterialButton(
            height: 45,
            color: ColorsManager.redColor,
            onPressed: () {
              if (index == 0) {
                Get.to(
                  () => const BookInfoScreen(),
                  transition: Transition.downToUp,
                  duration: const Duration(seconds: 1),
                );
              } else if (index == 1) {
                Get.off(
                  () => const TravelScreen(),
                  transition: Transition.downToUp,
                  duration: const Duration(seconds: 1),
                );
              } else if (index == 2) {
                AppCubit.get(context).screenIndex = 2;
                Get.off(
                  () => const TravelScreen(),
                  transition: Transition.downToUp,
                  duration: const Duration(seconds: 1),
                );
              } else if (index == 3) {
                AppCubit.get(context).screenIndex = 1;
                Get.off(
                  () => const TravelScreen(),
                  transition: Transition.downToUp,
                  duration: const Duration(seconds: 1),
                );
              } else if (index == 4) {
                Get.to(
                      () => const CarsView(),
                  transition: Transition.downToUp,
                  duration: const Duration(seconds: 1),
                );
              } else if (index == 5) {
                AppCubit.get(context).screenIndex=0;
                Get.off(
                  () => const TravelScreen(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(seconds: 1),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  model.buttonText.tr.toUpperCase(),
                  style: StyleManager.textStyle6,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
