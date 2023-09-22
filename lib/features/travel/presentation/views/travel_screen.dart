import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/app_cubit/app_cubit.dart';
import 'package:seasons/core/app_cubit/app_states.dart';
import 'package:seasons/features/travel/presentation/views/widgets/tavel_view_body.dart';

class TravelScreen extends StatelessWidget {
  const TravelScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   title: Text(
          //     AppCubit.get(context)
          //         .pagesTitles[AppCubit.get(context).screenIndex],
          //     style: StyleManager.appBarTextStyle,
          //   ),
          //   backgroundColor: Colors.white,
          //   elevation: 0.0,
          //   centerTitle: true,
          // ),
          body: TravelViewBody(),
          //AppCubit.get(context).pages[AppCubit.get(context).screenIndex],
          // floatingActionButton: const BuildFloatingActionButton(),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.miniCenterDocked,
          // bottomNavigationBar: const FloatingBottom(),
        );
      },
    );
  }
}
