import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';

import '../../core/app_cubit/app_cubit.dart';
import '../book_info/presentaion/views/book_infor_screen.dart';
import '../cars/presentation/views/cars_view.dart';
import '../travel/presentation/views/travel_screen.dart';

class StartView extends StatelessWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.amberAccent,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(

              top: 5.0,
              right: 20.0,
              left: 20.0,
              bottom: 5
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors:
                [
                  Colors.orange,
                  Colors.amberAccent,
                ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Text(
              //   'Seasons Tour',
              //   style: TextStyle(fontSize: 35, color: Color(0xff960202),fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // const Text(
              //   'For Tourism & Travel',
              //   style: TextStyle(fontSize: 20, color:Color(0xff960202)),
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              Image.asset('assets/images/logo.PNG'),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StartButton(
                            text: TranslationKeyManager.onBoardBookInquiryBtn.tr,
                            icon: Icons.search,
                            widgetIndex: -1,
                            transition: Transition.downToUp
                        ),
                        const SizedBox(height: 10,),
                        StartButton(
                            text: TranslationKeyManager.tourismTitle.tr,
                            icon: Icons.travel_explore_outlined,
                            widgetIndex: 2,
                            transition: Transition.downToUp
                        ),
                        const SizedBox(height: 10,),
                        StartButton(
                            text: TranslationKeyManager.hotelBook.tr,
                            icon: Icons.hotel,
                            widgetIndex: 1,
                            transition: Transition.downToUp

                        ),
                        const SizedBox(height: 10,),
                        StartButton(
                            text: TranslationKeyManager.flightTitle.tr,
                            icon: Icons.flight_takeoff,
                            widgetIndex: 0,
                            transition: Transition.downToUp

                        ),
                        const SizedBox(height: 10,),
                        StartButton(
                            text: TranslationKeyManager.carBook.tr,
                            icon: Icons.directions_car_sharp,
                            widgetIndex: -2,
                            transition: Transition.downToUp

                        ),
                        const SizedBox(height: 10,),
                        StartButton(
                            text: TranslationKeyManager.onBoardShowMore.tr,
                            icon: Icons.read_more,
                            widgetIndex: 0,
                            transition: Transition.downToUp

                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.widgetIndex,
    required this.transition,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final int widgetIndex;
  final Transition? transition;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.transparent,
      child: InkWell(
        onTap: ()
        {
          if(widgetIndex ==-1)
          {
            Get.to(
                  () => const BookInfoScreen(),
              transition: Transition.downToUp,
              duration: const Duration(seconds: 1),
            );
          }
          else if(widgetIndex ==-2)
          {
            Get.to(
                  () => const CarsView(),
              transition: Transition.downToUp,
              duration: const Duration(seconds: 1),
            );
          }
          else {
            AppCubit
                .get(context)
                .screenIndex = widgetIndex;
            Get.off(
                  () => const TravelScreen(),
              transition: Transition.downToUp,
              duration: const Duration(seconds: 1),
            );
          }
        },
        child: Row(
          children: [
            Container(
              width: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff960202)
              ),
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Icon(icon, color: Colors.white, size: 30,),
              ),
            ),
            Expanded(
              child: Container(
                //width: double.infinity,
                padding: const EdgeInsets.symmetric( vertical: 12),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(0),
                      topStart: Radius.circular(0),
                      bottomEnd: Radius.circular(10),
                      topEnd: Radius.circular(10),
                    ),
                    // gradient: LinearGradient(
                    //     colors:
                    //     [
                    //       Colors.amberAccent,
                    //       Color(0xff960202),
                    //
                    //     ],
                    //     begin: AlignmentDirectional.centerStart,
                    //     end: AlignmentDirectional.centerEnd
                    // )
                ),
                child: Text(text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 1
                ),
                textAlign: TextAlign.center,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
