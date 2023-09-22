import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';

import '../../../../../core/app_cubit/app_cubit.dart';
import '../../../../../core/resources_manager/style_manager.dart';

class LeavingDateBottomSheet extends StatelessWidget {
  const LeavingDateBottomSheet({Key? key, this.fromTour = false}) : super(key: key);

  final bool fromTour;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          InkWell(
            onTap: ()
            {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              ).then((value) {
                if(fromTour)
                {
                  AppCubit.get(context).changeTourDepartureDate(
                      value.toString().substring(0, 10));
                }
                else {
                  AppCubit.get(context).changeFlightDepartureDate(
                      value.toString().substring(0, 10));
                }
                Navigator.pop(context);
              }).catchError((error)
              {
                Navigator.pop(context);
              });
            },
            child: Text(
              TranslationKeyManager.choose.tr,
              style: StyleManager.leavingDateTextStyle,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: ()
            {
              Navigator.pop(context);
            },
            child: Text(
              TranslationKeyManager.close.tr,
              style: StyleManager.leavingDateTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
