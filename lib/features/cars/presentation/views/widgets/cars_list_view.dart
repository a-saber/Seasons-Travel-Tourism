import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/features/cars/presentation/cubit/car_types_cubit/car_types_cubit.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_cubit.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_states.dart';
import 'package:seasons/features/cars/presentation/views/car_passenger_data.dart';
import 'package:seasons/features/cars/presentation/views/widgets/cars_list_item.dart';

import '../../../../../core/resources_manager/delay_manager.dart';
import '../car_details_view.dart';

class CarsListView extends StatelessWidget {
  const CarsListView({
    Key? key,
    this.isSmall = false,
    required this.indexTapped,
  }) : super(key: key);
  final bool isSmall;
  final int indexTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 20.0,
        left: 20.0,
        top: 10.0,
      ),
      child: BlocBuilder<CarsCubit, CarsStates>(
        builder: (context, state) {
          var cubit = CarsCubit.get(context);
          return state is GetAllCarsLoadingState
              ? Center(child: CircularProgressIndicator())
              : GridView.count(
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: isSmall ? 1 / 1 : 1 / 1.45,
                  crossAxisCount: 2, //(width/150).round(),
                  children: List.generate(
                    cubit
                        .getCarsWithIndex(CarTypesCubit.get(context).typeIndex)
                        .length,
                    (index) => InkWell(
                        onTap: () {
                          // Get.to(
                          //     () => CarDetailsView(
                          //           cars: cubit.getCarsWithIndex(
                          //               CarTypesCubit.get(context)
                          //                   .typeIndex)[index],
                          //         ),
                          //     transition: DelayManager.transitionToHotelDetails,
                          //     duration:
                          //         DelayManager.durationTransitionToHotelDetails,
                          //     curve: DelayManager.curveToHotelDetails);
                          Get.to(
                              () => CarPassengerData(
                                    car: cubit.getCarsWithIndex(
                                        CarTypesCubit.get(context)
                                            .typeIndex)[index],
                                  ),
                              transition: DelayManager.transitionToHotelDetails,
                              duration:
                                  DelayManager.durationTransitionToHotelDetails,
                              curve: DelayManager.curveToHotelDetails);
                        },
                        child: CarsListItem(
                          car: cubit.getCarsWithIndex(
                              CarTypesCubit.get(context).typeIndex)[index],
                        )),
                  ),
                );
        },
      ),
    );
  }
}
