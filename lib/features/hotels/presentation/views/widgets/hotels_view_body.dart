import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/my_tab_bar_view.dart';
import 'package:seasons/core/core_widgets/my_tab_bar_view2.dart';
import 'package:seasons/core/core_widgets/swiper_widget.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/hotels_list_view.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/tab_bar_item.dart';

import '../../../../../core/local_database/cache_data.dart';
import '../../../../../core/localization/translation_key_manager.dart';
import '../../cubit/hotel_cubit/hotel_cubit.dart';
import '../../cubit/hotel_cubit/hotel_states.dart';

class HotelsViewBody extends StatefulWidget {
  const HotelsViewBody({Key? key}) : super(key: key);

  @override
  State<HotelsViewBody> createState() => _HotelsViewBodyState();
}

class _HotelsViewBodyState extends State<HotelsViewBody> {


  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: defaultAppBar(context: context, text: TranslationKeyManager.hotels.tr,),
          body: SafeArea(
            child: BasicView3(child: Column(
              children: [
                BlocConsumer<HotelsCubit, HotelsStates>(
                  listener: (context, state){},
                  builder: (context, state)
                  {
                    if(HotelsCubit.get(context).filteredHotels.isEmpty)
                      return  Column(
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.infoCircle, color: Colors.grey.withOpacity(0.5),),
                                SizedBox(width: 20,),
                                Expanded(child: Text(TranslationKeyManager.noResult.tr,style: TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w600),)),
                              ],
                            ),
                          ),
                          Text(
                              '${CacheData.lang == CacheHelperKeys.keyEN?'all results':'كل النتائج'}'
                                  .toUpperCase(),
                              style: TextStyle(
                                  height: 1.2,
                                  fontSize: 13,
                                  color: ColorsManager.primaryColor,
                                  fontWeight: FontWeight.bold))
                        ],
                      );
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                       color: ColorsManager.primaryColor,
                      child: MyTabBarView(
                        length: 2,
                        onTab: (index) {
                          if (index == 0) {
                            showAll = false;

                          } else {
                            showAll = true;
                          }
                          setState(() {});
                        },
                        tabs: [
                          TabBarItem(
                              label: CacheData.lang == CacheHelperKeys.keyEN?'Results':'النتائج'.toUpperCase()),
                          TabBarItem(
                              label:CacheData.lang == CacheHelperKeys.keyEN? 'Show All':'اعرض الكل'.toUpperCase()),

                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 10,),
                if(HotelsCubit.get(context).filteredHotels.isEmpty||showAll)
                  BlocConsumer<HotelsCubit, HotelsStates>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is ViewCitiesLoadingState) {
                          return SizedBox(
                            height: 25,
                          );
                        } else if (state is ViewCitiesErrorState) {
                          return Center(
                            child: Text(state.error),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: MyTabBarView2(
                              length: HotelsCubit.get(context).cities.length + 1,
                              onTab: (index) {
                                HotelsCubit.get(context).itemBarOnTap(index);
                              },
                              tabs: [
                                for (int i = 0; i < HotelsCubit.get(context).cities.length + 1; i++)
                                  TabBarItem2(
                                      label: i == 0
                                          ? TranslationKeyManager.showAll.tr
                                          : CacheData.lang ==
                                          TranslationKeyManager.localeAR
                                              .toString()
                                          ? HotelsCubit.get(context)
                                          .cities[i - 1]
                                          .name!
                                          : HotelsCubit.get(context)
                                          .cities[i - 1]
                                          .nameEn!),
                              ],
                            ),
                          );
                        }
                      }),
                SizedBox(height: 10,),
                Expanded(child: HotelsListView(showAll: showAll,)),
                const SizedBox(
                  height: 20,
                )
              ],
            )),
          ),
        );
  }
}


/*
 return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
           // color: ColorsManager.primaryColor,
            child: MyTabBarView(
              length: 2,
              onTab: (index) {
                if (index == 0) {
                  showAll = false;

                } else {
                  showAll = true;
                }
                setState(() {});
              },
              tabs: [
                TabBarItem(
                    label: CacheData.lang == CacheHelperKeys.keyEN?'Results':'النتائج'.toUpperCase()),
                TabBarItem(
                    label:CacheData.lang == CacheHelperKeys.keyEN? 'Show All':'اعرض الكل'.toUpperCase()),

              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: SwiperWidget(
          //     offerImages: swiperImages,
          //   ),
          // ),
          SizedBox(height: 10,),
          if(showAll)
          BlocConsumer<HotelsCubit, HotelsStates>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is ViewCitiesLoadingState) {
                  return SizedBox(
                    height: 25,
                  );
                } else if (state is ViewCitiesErrorState) {
                  return Center(
                    child: Text(state.error),
                  );
                } else {
                  return MyTabBarView2(
                    //isScrollable: true,
                    length: HotelsCubit.get(context).cities.length + 1,
                    onTab: (index) {
                      HotelsCubit.get(context).itemBarOnTap(index);
                    },
                    tabs: [
                      for (int i = 0;
                          i < HotelsCubit.get(context).cities.length + 1;
                          i++)
                        TabBarItem(
                            label: i == 0
                                ? TranslationKeyManager.showAll.tr
                                : CacheData.lang ==
                                        TranslationKeyManager.localeAR
                                            .toString()
                                    ? HotelsCubit.get(context)
                                        .cities[i - 1]
                                        .name!
                                    : HotelsCubit.get(context)
                                        .cities[i - 1]
                                        .nameEn!),
                    ],
                  );
                }
              }),
          SizedBox(height: 10,),
          HotelsListView(showAll: showAll),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
 */