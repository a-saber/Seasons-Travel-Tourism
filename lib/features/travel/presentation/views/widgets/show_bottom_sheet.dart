import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/app_cubit/app_cubit.dart';
import 'package:seasons/core/app_cubit/app_states.dart';

class ShowBottomSheetBody extends StatelessWidget {
  const ShowBottomSheetBody({
    Key? key,
    required this.right,
    required this.left,
  }) : super(key: key);
  final bool right;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        AppCubit.get(context)
                            .bottomSheetItemTapped(index, right, left);
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppCubit.get(context).list[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                itemCount: AppCubit.get(context).list.length));
      },
    );
  }
}
