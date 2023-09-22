import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/list_item_image.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/cars/data/models/cars_model.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_cubit.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_states.dart';

import '../../../../../core/local_database/cache_data.dart';
import '../../../../../core/localization/translation_key_manager.dart';
import '../../../../../core/resources_manager/style_manager.dart';

class CarsListItem extends StatelessWidget {
  const CarsListItem({
    Key? key,
    required this.car,
    this.inDetails = false,
  }) : super(key: key);
  final CarsModel car;
  final bool inDetails ;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsStates>(
      builder: (context, state) {
        var cubit = CarsCubit.get(context);
        return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inDetails?
                SizedBox(
                  height: 200,
                  child: ListItemImage(
                    image: "https://api.seasonsge.com/images/${car.imagePath!}",
                  ),
                ):
                Expanded(
                    child: ListItemImage(
                  image: "https://api.seasonsge.com/images/${car.imagePath!}",
                )),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        CacheData.lang == TranslationKeyManager.localeAR.toString()
                            ? '${car.pricePerDay!}السعر في اليوم :  \$':
                             'Price per day : ${car.pricePerDay!} \$',
                        style: StyleManager.hotelItemTitle
                            .copyWith(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 5,),
                    if(inDetails)
                    Expanded(
                      child: Text(
                        CacheData.lang == TranslationKeyManager.localeAR.toString()
                            ? '${car.priceWithDriver!}السعر في اليوم مع سائق:  \$':
                             'Price per day with driver: ${car.priceWithDriver!} \$',
                        textAlign: TextAlign.end,
                        style: StyleManager.hotelItemTitle
                            .copyWith(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                if(!inDetails)
                Text(
                  TranslationKeyManager.bookNow.tr,
                  style: StyleManager.hotelItemExtraTitle.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      color: ColorsManager.primaryColor,
                      height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
