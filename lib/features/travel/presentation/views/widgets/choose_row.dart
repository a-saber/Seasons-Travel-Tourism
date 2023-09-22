import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/app_cubit/app_cubit.dart';
import 'package:seasons/core/app_cubit/app_states.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';

import 'show_bottom_sheet.dart';

class ChooseRow extends StatefulWidget {
  const ChooseRow({
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseRow> createState() => _ChooseRowState();
}

class _ChooseRowState extends State<ChooseRow> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      AppCubit.get(context).isRight = true;
                      print(AppCubit.get(context).isRight);
                    });
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => ShowBottomSheetBody(
                              right: AppCubit.get(context).isRight,
                              left: !AppCubit.get(context).isRight,
                            ));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppCubit.get(context).chooseTextR == null
                              ? TranslationKeyManager.choose.tr
                              : AppCubit.get(context).chooseTextR!,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                      // Spacer(),
                      // SizedBox(
                      //   width:
                      //       AppCubit.get(context).chooseTextR != null ? 10 : 10,
                      // ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              // const SizedBox(
              //   width: 20,
              // ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppCubit.get(context).isRight = false;
                    print(AppCubit.get(context).isRight);
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => ShowBottomSheetBody(
                              right: AppCubit.get(context).isRight,
                              left: !AppCubit.get(context).isRight,
                            ));
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppCubit.get(context).chooseTextL == null
                              ?TranslationKeyManager.choose.tr
                              : AppCubit.get(context).chooseTextL!,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                      //Spacer(),

                      // SizedBox(
                      //   width:
                      //       AppCubit.get(context).chooseTextL != null ? 10 : 90,
                      // ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
