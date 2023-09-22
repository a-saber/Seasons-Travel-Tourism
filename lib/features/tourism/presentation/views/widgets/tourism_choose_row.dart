import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';

import '../../../../../core/app_cubit/app_cubit.dart';
import '../../../../../core/app_cubit/app_states.dart';
import 'tourism_show_bottom_sheet.dart';

class TourismChooseRow extends StatefulWidget {
  const TourismChooseRow({
    Key? key,
    required this.lList,
    required this.rList,
  }) : super(key: key);
  final List<String> rList;
  final List<String> lList;

  @override
  State<TourismChooseRow> createState() => _TourismChooseRowState();
}
class _TourismChooseRowState extends State<TourismChooseRow> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      AppCubit.get(context).tourismIsRight = true;
                    });
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => TourismShowBottomSheetBody(
                              right: AppCubit.get(context).tourismIsRight,
                              left: !AppCubit.get(context).tourismIsRight,
                              list: widget.rList,
                            ));
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          AppCubit.get(context).tourismChooseTextR == null
                              ? TranslationKeyManager.choose.tr
                              : AppCubit.get(context).tourismChooseTextR!,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        width: AppCubit.get(context).tourismChooseTextR != null
                            ? 10
                            : 90,
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 25,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppCubit.get(context).tourismIsRight = false;
                    print(AppCubit.get(context).tourismIsRight);
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => TourismShowBottomSheetBody(
                          right: AppCubit.get(context).tourismIsRight,
                          left: !AppCubit.get(context).tourismIsRight,
                          list: widget.lList,
                        ));
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          AppCubit.get(context).tourismChooseTextL == null
                              ?TranslationKeyManager.choose.tr
                              : AppCubit.get(context).tourismChooseTextL!,
                          overflow: TextOverflow.ellipsis,
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        width: AppCubit.get(context).tourismChooseTextL != null
                            ? 10
                            : 90,
                      ),
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


