import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/app_cubit/app_cubit.dart';
import 'package:seasons/core/app_cubit/app_states.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';

import '../../../../../core/resources_manager/colors_manager.dart';

class GoBackInkWell extends StatelessWidget {
  const GoBackInkWell({
    Key? key,
    required this.text,
    required this.height,
    required this.onTap,
    required this.go,
  }) : super(key: key);
  final String text;
  final double height;
  final Function() onTap;
  final bool go;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: onTap,
          child: Container(
            height: 33,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            width: height,
            decoration: BoxDecoration(
                color: go ? Colors.white : ColorsManager.yellow,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text(
              text,
              style: StyleManager.checkTextStyle,
            )),
          ),
        );
      },
    );
  }
}
