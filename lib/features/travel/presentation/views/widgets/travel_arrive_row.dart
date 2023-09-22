import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';

import '../../../../../core/app_cubit/app_cubit.dart';
import '../../../../tourism/presentation/views/widgets/tourism_choose_row.dart';

class TravelArriveRow extends StatelessWidget {
  const TravelArriveRow(
      {Key? key,
      required this.firstText,
      required this.secondText,
      required this.isTravel,
      required this.width})
      : super(key: key);
  final String firstText;
  final String secondText;
  final bool isTravel;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              firstText,
              style: isTravel
                  ? StyleManager.travelTextStyle
                  : StyleManager.travelTextStyle.copyWith(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              secondText,
              style: isTravel
                  ? StyleManager.travelTextStyle
                  : StyleManager.travelTextStyle.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
