import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/my_tab_bar_view2.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/cars/presentation/cubit/car_types_cubit/car_types_cubit.dart';
import 'package:seasons/features/cars/presentation/cubit/car_types_cubit/car_types_states.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_states.dart';

import '../../../../../core/core_widgets/my_tab_bar_view.dart';
import '../../../../../core/local_database/cache_data.dart';
import '../../../../hotels/presentation/views/widgets/tab_bar_item.dart';
import 'cars_list_view.dart';

class CarsViewBody extends StatefulWidget {
  const CarsViewBody({Key? key}) : super(key: key);

  @override
  State<CarsViewBody> createState() => _CarsViewBodyState();
}

class _CarsViewBodyState extends State<CarsViewBody> {
  @override
  Widget build(BuildContext context) {
    int indexTapped = 0;
    return Scaffold(
        appBar: defaultAppBar(
            context: context,
            text: TranslationKeyManager.cars.tr,
        ),
      body: SafeArea(
          child: BasicView3(
              child: BlocBuilder<CarTypesCubit, CarTypesStates>(
                builder: (context, state) {
                  return state is GetAllCarTypesLoadingState
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      ):
                  state is GetAllCarTypesErrorState
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: Text(state.error)),
                    ],
                  )

                      : Column(
                    children: [

                      Container(
                        width: double.infinity,
                        color: ColorsManager.primaryColor,
                        child: MyTabBarView(
                          isScrollable: true,
                          length: CarTypesCubit.get(context).carTypes.length + 1,
                          onTab: (index) {
                            setState(() {
                              CarTypesCubit.get(context).changeIndex(index);
                              indexTapped = CarTypesCubit.get(context).typeIndex;
                            });
                          },
                          tabs: [
                            //TabBarItem(label: TranslationKeyManager.showAll.tr),
                            for (int i = 0; i < CarTypesCubit.get(context).carTypes.length +1; i++)
                              TabBarItem(
                                  label: i==0?
                                  TranslationKeyManager.showAll.tr:
                                  CacheData.lang ==
                                      TranslationKeyManager.localeAR.toString()
                                      ? CarTypesCubit.get(context).carTypes[i-1].name!
                                      : CarTypesCubit.get(context)
                                      .carTypes[i-1]
                                      .nameEn!),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: CarsListView(
                          isSmall: true,
                          indexTapped: indexTapped,
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  );
                },
              )
          )
      ),
    );
  }
}
