import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/flutter_toast.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;

import '../../cubit/home_cubit.dart';
import '../../cubit/home_states.dart';

class FeatureBuilder {
  Widget icon;
  String title;
  Widget view;

  FeatureBuilder({required this.icon, required this.title, required this.view});
}

class MainHomeView extends StatefulWidget {
  const MainHomeView({Key? key}) : super(key: key);

  @override
  State<MainHomeView> createState() => _MainHomeViewState();
}

class _MainHomeViewState extends State<MainHomeView> {

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void subScribe() async {
    FirebaseMessaging.instance.subscribeToTopic("all");
    FirebaseMessaging.instance.subscribeToTopic("client");
  }

  @override
  void initState() {
    // subScribe();
    // requestPermission();
    // FirebaseMessaging.onMessage.listen((event) {
    //   showToast(
    //       massage: "${event.notification!.body}", state: ToastState.SUCCESS);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   NavigateTo(context, MainHomeView());
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
            body: cubit.screens[cubit.currentIndex],

          bottomNavigationBar:
          Directionality(
          textDirection: TextDirection.ltr,
          child: CurvedNavigationBar(
              animationDuration: const Duration(milliseconds: 300),
              //backgroundColor: Colors.transparent,
               backgroundColor: Color.fromARGB(255, 102, 178, 255),
              //color: Colors.blue.shade700,
              //ColorsManager.primaryColor
              color: ColorsManager.primaryColor,
              height: 50,
              items: [
                Icon(
                          Icons.home,
                  color: Colors.white,
                ),
                Transform.rotate(
                  angle: pi*0.5,
                  child: Icon(
                              Icons.key,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.query_stats_outlined,
                  color: Colors.white,
                ),
                Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ],
              index: cubit.currentIndex,
              onTap: (int index) {
                cubit.changeIndex(index);
              }),
        )
          // BottomNavigationBar(
          //   currentIndex: cubit.currentIndex,
          //   onTap: (index) {
          //     cubit.changeIndex(index);
          //   },
          //   selectedItemColor: Colors.blue.shade800,
          //   unselectedItemColor: Colors.grey,
          //   selectedLabelStyle: const TextStyle(color: Colors.blue),
          //   unselectedLabelStyle: const TextStyle(color: Colors.grey),
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Icon(
          //         Icons.home,
          //       ),
          //       label: "Home",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Transform.rotate(
          //         angle: pi*0.5,
          //         child: Icon(
          //           Icons.key,
          //         ),
          //       ),
          //       label: "Profile",
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(
          //         Icons.query_stats_outlined,
          //       ),
          //       label: "Search",
          //     ),
          //     BottomNavigationBarItem(
          //         icon: Icon(
          //           Icons.settings,
          //         ),
          //         label: "Settings"),
          //   ],
          // ),

            );
      },
    );
  }
}
/*
color: Color(0x66ffffff),
elevation: 5,
borderRadius: BorderRadius.circular(23),
 */
/*
ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
 */
class BottomNavItemBuilder extends StatelessWidget {
  const BottomNavItemBuilder({super.key,
  required this.index,
  required this.icon,
  });
  final int index;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          return IconButton(
              onPressed: ()
              {
                HomeCubit.get(context).changeIndex(index);
              },
              icon: FaIcon(
                  icon,
                  color: HomeCubit.get(context).currentIndex == index?
                  ColorsManager.primaryColor:
                  Colors.grey
              ));
        });
  }
}

/*
bottomNavigationBar: Directionality(
              textDirection: TextDirection.ltr,
              child: CurvedNavigationBar(
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  // backgroundColor: Color.fromARGB(255, 102, 178, 255),
                  //color: Colors.blue.shade700,
                  //ColorsManager.primaryColor
                  color: ColorsManager.primaryColor,
                  height: 50,
                  items: [
                    FaIcon(
                        FontAwesomeIcons.house,
                      color: Colors.white,
                    ),
                    FaIcon(
                        FontAwesomeIcons.rightToBracket,
                      color: Colors.white,
                    ),
                    FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.white,
                    ),
                    FaIcon(
                      FontAwesomeIcons.gear,
                      color: Colors.white,
                    ),
                  ],
                  index: cubit.currentIndex,
                  onTap: (int index) {
                    cubit.changeIndex(index);
                  }),
            )
 */

// RotatedBox(
//   quarterTurns: 1,
//   child: Icon(
//     Icons.key_outlined,
//     color: Colors.white,
//   ),
// ),
// Icon(
//   Icons.query_stats_outlined,
//   color: Colors.white,
// ),
// Icon(
//   Icons.settings_outlined,
//   color: Colors.white,
// ),


/* BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            selectedItemColor: Colors.blue.shade800,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(color: Colors.blue),
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.key_outlined,
                ),
                label: "Login",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu_outlined,
                  ),
                  label: "More"),
            ],
          ),*/


/*
// SafeArea(
            //     child: SizedBox(
            //       height: double.infinity,
            //       child: Stack(
            //         alignment: Alignment.topCenter,
            //         children: [
            //           cubit.screens[cubit.currentIndex],
            //           Align(
            //             alignment: Alignment.bottomCenter,
            //             child: Directionality(
            //               textDirection: TextDirection.ltr,
            //               child: Padding(
            //                 padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
            //                 child: Material(
            //                   color: Color(0x66ffffff),
            //                   elevation: 5,
            //                   borderRadius: BorderRadius.circular(23),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                       color: Color(0xffffffff),
            //                       borderRadius: BorderRadius.circular(15)
            //                     ),
            //                     height: 50,
            //                     width: double.infinity,
            //                     padding: EdgeInsets.symmetric(horizontal: 20),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children:
            //                       [
            //                         BottomNavItemBuilder(index: 0, icon: FontAwesomeIcons.house),
            //                         BottomNavItemBuilder(index: 1, icon: FontAwesomeIcons.rightToBracket),
            //                         BottomNavItemBuilder(index: 2, icon: FontAwesomeIcons.magnifyingGlass),
            //                         BottomNavItemBuilder(index: 3, icon: FontAwesomeIcons.gear),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     )),
 */