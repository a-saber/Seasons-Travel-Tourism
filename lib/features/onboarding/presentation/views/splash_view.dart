import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/resources_manager/assets_manager.dart';
import 'package:seasons/core/resources_manager/delay_manager.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/home/presentation/views/main_home_view.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_cubit.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_states.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    if(CacheData.email!=null&&CacheData.password!=null)
    {
      LoginCubit.get(context).userLogin(context:context,email: CacheData.email!, password: CacheData.password!);
    }
    Future.delayed(Duration(seconds: 1), () {
      Get.off(()=>MainHomeView(),
      transition: DelayManager.fade,
      duration: Duration(seconds: 2));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginStates>(
          builder: (context, state)
          {
            return Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height*0.35,
                  width: MediaQuery.of(context).size.width*0.35,
                  child: Image.asset(AssetsManager.logo)),
            );
          }, listener: (context, state)
      {
        if(state is LoginSuccessState)
          HomeCubit.get(context).Login();
      }),
    );
  }
}
