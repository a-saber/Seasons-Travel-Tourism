import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_cubit/app_cubit.dart';
import '../../../../../core/app_cubit/app_states.dart';

class ShowBottomSheetTourismBody extends StatelessWidget {
  const ShowBottomSheetTourismBody({
    Key? key,
    required this.list,
    this.isRoomType = false,
  }) : super(key: key);
  final List<String> list;
  final bool isRoomType;
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
                      onTap: ()
                      {
                        if (isRoomType)
                        {
                          AppCubit.get(context).changeRoomType(list[index]);
                        }
                        else
                        {
                          AppCubit.get(context).changeKidsReservation(list[index]);
                        }
                        Navigator.pop(context);
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
