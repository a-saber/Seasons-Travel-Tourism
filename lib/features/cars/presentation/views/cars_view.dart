import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_cubit.dart';
import 'package:seasons/features/cars/presentation/views/widgets/cars_view_body.dart';

import '../../../../core/localization/translation_key_manager.dart';
import '../cubit/car_types_cubit/car_types_cubit.dart';

class CarsView extends StatefulWidget {
  const CarsView({Key? key}) : super(key: key);

  @override
  State<CarsView> createState() => _CarsViewState();
}

class _CarsViewState extends State<CarsView> {
  @override
  void initState() {
    CarTypesCubit.get(context).getCarTypes(context);
    CarsCubit.get(context).getCars(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarsViewBody();
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: defaultAppBar(
    //       context: context,
    //       text: TranslationKeyManager.cars.tr,),
    //   body: const CarsViewBody(),
    // );
  }
}
