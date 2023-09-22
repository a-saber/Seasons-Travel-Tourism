import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/app_cubit/app_cubit.dart';

import '../../../../../core/app_cubit/app_states.dart';
import 'go_back_inkwell.dart';

class GoAndBackContainer extends StatelessWidget {
  const GoAndBackContainer(
      {Key? key,
      required this.firstText,
      required this.secondText,
      required this.firstFunction,
      required this.secondFunction})
      : super(key: key);
  final String firstText;
  final String secondText;
  final Function() firstFunction;
  final Function() secondFunction;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          height: 45,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal, width: 1)),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GoBackInkWell(
                  text: firstText,
                  height: 130,
                  go: AppCubit.get(context).isBack,
                  onTap: firstFunction,
                ),
                const SizedBox(
                  width: 20,
                ),
                GoBackInkWell(
                  text: secondText,
                  height: 130,
                  go: !AppCubit.get(context).isBack,
                  onTap: secondFunction,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
