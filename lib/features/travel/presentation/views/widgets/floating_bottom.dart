import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/app_cubit/app_states.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';

import '../../../../../core/app_cubit/app_cubit.dart';

class FloatingBottom extends StatelessWidget {
  const FloatingBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: BottomAppBar(
            color: Colors.grey[200],
            shape: const CircularNotchedRectangle(),
            notchMargin: 12,
            child: SizedBox(
              height: 55,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            AppCubit.get(context).changeIndex(3);
                          },
                          padding: EdgeInsets.zero,
                          minWidth: 40,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_outlined,
                                color: cubit.screenIndex == 3
                                    ? Colors.blue.shade800
                                    : ColorsManager.iconColor,
                              ),
                              Text(
                                TranslationKeyManager.bottomNavMore.tr,
                                style: StyleManager.bottomNavigationTextStyle
                                    .copyWith(
                                  color: cubit.screenIndex == 3
                                      ? Colors.blue.shade800
                                      : ColorsManager.iconColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        MaterialButton(
                          onPressed: () {
                            cubit.changeIndex(2);
                          },
                          minWidth: 40,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.travel_explore_outlined,
                                color: cubit.screenIndex == 2
                                    ? Colors.blue.shade800
                                    : ColorsManager.iconColor,
                              ),
                              Text(
                                TranslationKeyManager.bottomNavTourism.tr,
                                style: StyleManager.bottomNavigationTextStyle
                                    .copyWith(
                                  color: cubit.screenIndex == 2
                                      ? Colors.blue.shade800
                                      : ColorsManager.iconColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            cubit.changeIndex(1);
                          },
                          minWidth: 40,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bed_outlined,
                                color: cubit.screenIndex == 1
                                    ? Colors.blue.shade800
                                    : ColorsManager.iconColor,
                              ),
                              Text(
                                TranslationKeyManager.bottomNavHotels.tr,
                                style: StyleManager.bottomNavigationTextStyle
                                    .copyWith(
                                  color: cubit.screenIndex == 1
                                      ? Colors.blue.shade800
                                      : ColorsManager.iconColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        MaterialButton(
                          onPressed: () {
                            cubit.changeIndex(0);
                          },
                          minWidth: 40,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.airplanemode_active_outlined,
                                  color: cubit.screenIndex == 0
                                      ? Colors.blue.shade800
                                      : ColorsManager.iconColor,
                                ),
                              ),
                              Text(
                                TranslationKeyManager.bottomNavFlight.tr,
                                style: StyleManager.bottomNavigationTextStyle
                                    .copyWith(
                                  color: cubit.screenIndex == 0
                                      ? Colors.blue.shade800
                                      : ColorsManager.iconColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
