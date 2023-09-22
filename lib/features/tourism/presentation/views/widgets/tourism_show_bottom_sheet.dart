import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/app_cubit/app_cubit.dart';
import 'package:seasons/core/app_cubit/app_states.dart';

class TourismShowBottomSheetBody extends StatelessWidget {
  const TourismShowBottomSheetBody({
    Key? key,
    required this.right,
    required this.left,
    required this.list,
  }) : super(key: key);
  final bool right;
  final bool left;
  final List<String> list;

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
                            .tourismBottomSheetItemTapped(index, right, left);
                        Navigator.pop(context);
                        // isTourism
                        //     ? AppCubit.get(context)
                        //         .tourismBottomSheetItemTapped(
                        //             index, right, left)
                        //     : AppCubit.get(context)
                        //         .bottomSheetItemTapped(index, right, left);
                      },
                      child: Text(
                        list[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                itemCount: list.length));
      },
    );
  }
}
