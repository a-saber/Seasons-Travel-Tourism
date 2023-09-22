import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/default_drop_down.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/core_widgets/my_tab_bar_view.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/en.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_cubit.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_states.dart';
import 'package:seasons/features/hotels/presentation/views/hotels_adult_number_view.dart';
import 'package:seasons/features/hotels/presentation/views/hotels_view.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/tab_bar_item.dart';
import 'package:seasons/features/programs_view/data/models/city_model.dart';
import 'package:seasons/features/programs_view/data/models/country_model.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_cubit.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_states.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'adult_number_view2.dart';

class HotelsView2 extends StatefulWidget {
  const HotelsView2({Key? key}) : super(key: key);

  @override
  State<HotelsView2> createState() => _HotelsView2State();
}

class _HotelsView2State extends State<HotelsView2> {
  DateTime? startDateOfficial;
  DateTime? endDateOfficial;
  CountryModel? country;

  ProgrammeCityModel? city;
  String? roomType;
  String? childBook;

  bool includeFlights = true;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BasicView2(
      scaffoldKey: scaffoldKey,
      button: BlocConsumer<HotelsCubit, HotelsStates>(
          listener: (context, state)
          {
            if(state is ViewHotelsSuccessState)
            {
              Get.to(()=>HotelView());
            }
            if(state is ViewCitiesErrorState)
            {
              callMySnackBar(context: context, text: state.error);
            }
            if(state is ViewHotelsErrorState)
            {
              callMySnackBar(context: context, text: state.error);
            }
          },
          builder: (context, state)
          {
            if(
            state is ViewHotelsLoadingState||
                state is ViewCitiesLoadingState||
                state is ViewCitiesSuccessState
            )
            {
              return CircularProgressIndicator();
            }
            else
            {
              return SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap:
                  (city == null ||startDateOfficial==null||endDateOfficial==null)?
                  null: ()
                  {
                    HotelsCubit.get(context).getCities(
                        context,
                        city: city!.id.toString(),
                        startDate: startDateOfficial!,
                        endDate: endDateOfficial!,
                        daysCount: startDateOfficial!.difference(endDateOfficial!).inDays
                    );
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        color: (city == null ||startDateOfficial==null ||endDateOfficial==null)?
                        Colors.grey:
                        ColorsManager.primaryColor,

                        borderRadius: BorderRadius.circular(0)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        CacheData.lang == CacheHelperKeys.keyEN ?
                        'Search Hotels':
                        'ابحث عن فنادق',
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
        appbarTitle: TranslationKeyManager.hotels.tr,
        children:
        [
          Divider(
            color: Colors.amber,
            thickness: 2,
            height: 2,
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 10,),
                InkWell(
                    onTap: ()
                    {
                      scaffoldKey.currentState!.showBottomSheet(
                          backgroundColor: Colors.transparent, (context) {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.65,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  )),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    TranslationKeyManager.countries.tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BlocConsumer<ProgramsCubit, ProgramsStates>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        if (state is CountriesGetLoadingState)
                                        {
                                          return Center(
                                              child:
                                              CircularProgressIndicator());
                                        }
                                        else if (state is CountriesGetErrorState)
                                        {
                                          return Center(
                                              child: Text(state.error));
                                        }
                                        else if (ProgramsCubit.get(context).countries.isEmpty)
                                        {
                                          return Center(
                                              child: Text(
                                                  TranslationKeyManager.serverError.tr));
                                        }
                                        else
                                        {
                                          return Expanded(
                                            child: ListView.builder(
                                                itemCount:
                                                ProgramsCubit.get(context)
                                                    .countries
                                                    .length,
                                                itemBuilder:
                                                    (context, index) => Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          5.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          country = ProgramsCubit
                                                              .get(
                                                              context)
                                                              .countries[index];
                                                          city = null;
                                                          setState(
                                                                  () {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                              child:
                                                              Container(
                                                                height:
                                                                50,
                                                                width:
                                                                50,
                                                                child: CachedNetworkImage(
                                                                    placeholder: (context, error) => const Icon(
                                                                      Icons.image_outlined,
                                                                      color: Colors.grey,
                                                                    ),
                                                                    fit: BoxFit.fill,
                                                                    errorWidget: (context, url, error) => const Icon(
                                                                      Icons.image_outlined,
                                                                      color: Colors.grey,
                                                                    ),
                                                                    imageUrl: 'https://api.seasonsge.com/images/Agents/${ProgramsCubit.get(context).countries[index].img!}'),
                                                                // Image.network(
                                                                //   'https://api.seasonsge.com/images/Agents/${ProgramsCubit.get(context).countries[index].img!}',
                                                                //   fit: BoxFit
                                                                //       .fill,),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  CacheData.lang == CacheHelperKeys.keyEN?
                                                                  ProgramsCubit.get(context).countries[index].nameEn!:
                                                                  ProgramsCubit.get(context).countries[index].name!,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: ColorsManager.primaryColor),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          50.0),
                                                      child: Divider(),
                                                    )
                                                  ],
                                                )),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    },
                    child: DefaultField(
                        horizontalPadding: 20,
                        prefix:  Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                          child: FaIcon(
                            FontAwesomeIcons.flag,
                            color: ColorsManager.iconColor,
                            size: 20,
                          ),
                        ),
                        enabled: false,
                        hint: TranslationKeyManager.country.tr,
                        controller: TextEditingController(
                            text: country != null ?
                            CacheData.lang == CacheHelperKeys.keyEN ?
                            country!.nameEn! :
                            country!.name! :
                            ''
                        ))),
                SizedBox(height: 15,),
                // InkWell(
                //   onTap: () {
                //     scaffoldKey.currentState!.showBottomSheet(
                //         backgroundColor: Colors.transparent, (context) {
                //       return Stack(
                //         alignment: Alignment.bottomCenter,
                //         children: [
                //           InkWell(
                //             onTap: () {
                //               Navigator.pop(context);
                //             },
                //             child: Container(
                //               width: double.infinity,
                //               height: MediaQuery.of(context).size.height,
                //               color: Colors.black.withOpacity(0.5),
                //             ),
                //           ),
                //           Container(
                //             width: double.infinity,
                //             height: MediaQuery.of(context).size.height * 0.65,
                //             decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.only(
                //                   topRight: Radius.circular(20),
                //                   topLeft: Radius.circular(20),
                //                 )),
                //             padding: EdgeInsets.symmetric(
                //                 vertical: 20, horizontal: 20),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   TranslationKeyManager.countries.tr,
                //                   style: TextStyle(
                //                       fontSize: 17,
                //                       color: Colors.grey,
                //                       fontWeight: FontWeight.bold),
                //                 ),
                //                 SizedBox(
                //                   height: 10,
                //                 ),
                //                 BlocConsumer<ProgramsCubit, ProgramsStates>(
                //                     listener: (context, state) {},
                //                     builder: (context, state) {
                //                       if (state is CountriesGetLoadingState)
                //                       {
                //                         return Center(
                //                             child:
                //                             CircularProgressIndicator());
                //                       }
                //                       else if (state is CountriesGetErrorState)
                //                       {
                //                         return Center(
                //                             child: Text(state.error));
                //                       }
                //                       else if (ProgramsCubit.get(context).countries.isEmpty)
                //                       {
                //                         return Center(
                //                             child: Text(
                //                                 TranslationKeyManager.serverError.tr));
                //                       }
                //                       else
                //                       {
                //                         return Expanded(
                //                           child: ListView.builder(
                //                               itemCount:
                //                               ProgramsCubit.get(context)
                //                                   .countries
                //                                   .length,
                //                               itemBuilder:
                //                                   (context, index) => Column(
                //                                 children: [
                //                                   Padding(
                //                                     padding:
                //                                     const EdgeInsets
                //                                         .symmetric(
                //                                         vertical:
                //                                         5.0),
                //                                     child: InkWell(
                //                                       onTap: () {
                //                                         country = ProgramsCubit
                //                                             .get(
                //                                             context)
                //                                             .countries[index];
                //                                         city = null;
                //                                         setState(
                //                                                 () {});
                //                                         Navigator.pop(
                //                                             context);
                //                                       },
                //                                       child: Row(
                //                                         children: [
                //                                           ClipRRect(
                //                                             borderRadius:
                //                                             BorderRadius.circular(
                //                                                 10),
                //                                             child:
                //                                             Container(
                //                                               height:
                //                                               50,
                //                                               width:
                //                                               50,
                //                                               child: CachedNetworkImage(
                //                                                   placeholder: (context, error) => const Icon(
                //                                                     Icons.image_outlined,
                //                                                     color: Colors.grey,
                //                                                   ),
                //                                                   fit: BoxFit.fill,
                //                                                   errorWidget: (context, url, error) => const Icon(
                //                                                     Icons.image_outlined,
                //                                                     color: Colors.grey,
                //                                                   ),
                //                                                   imageUrl: 'https://api.seasonsge.com/images/Agents/${ProgramsCubit.get(context).countries[index].img!}'),
                //                                               // Image.network(
                //                                               //   'https://api.seasonsge.com/images/Agents/${ProgramsCubit.get(context).countries[index].img!}',
                //                                               //   fit: BoxFit
                //                                               //       .fill,),
                //                                             ),
                //                                           ),
                //                                           SizedBox(
                //                                             width: 10,
                //                                           ),
                //                                           Column(
                //                                             crossAxisAlignment:
                //                                             CrossAxisAlignment
                //                                                 .start,
                //                                             children: [
                //                                               Text(
                //                                                 CacheData.lang == CacheHelperKeys.keyEN?
                //                                                 ProgramsCubit.get(context).countries[index].nameEn!:
                //                                                 ProgramsCubit.get(context).countries[index].name!,
                //                                                 style: TextStyle(
                //                                                     fontWeight: FontWeight.bold,
                //                                                     color: ColorsManager.primaryColor),
                //                                               ),
                //                                             ],
                //                                           )
                //                                         ],
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   Padding(
                //                                     padding: const EdgeInsets
                //                                         .symmetric(
                //                                         horizontal:
                //                                         50.0),
                //                                     child: Divider(),
                //                                   )
                //                                 ],
                //                               )),
                //                         );
                //                       }
                //                     })
                //               ],
                //             ),
                //           ),
                //         ],
                //       );
                //     });
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(5),
                //         border: Border.all(
                //           color: ColorsManager.iconColor,
                //         )),
                //     padding:
                //     EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                //     child: Row(
                //       children: [
                //         Icon(
                //           Icons.flag_circle,
                //           color: ColorsManager.iconColor,
                //         ),
                //         SizedBox(
                //           width: 15,
                //         ),
                //         Text(
                //           country != null ? CacheData.lang == CacheHelperKeys.keyEN?country!.nameEn!:country!.name!: TranslationKeyManager.country.tr,
                //           style: TextStyle(
                //             color: country != null
                //                 ? Colors.black
                //                 : ColorsManager.iconColor,
                //             fontSize: 15,
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),

                InkWell(
                    onTap: ()
                    {
                      scaffoldKey.currentState!.showBottomSheet(
                          backgroundColor: Colors.transparent, (context) {
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.65,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  )),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    TranslationKeyManager.cities.tr,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BlocConsumer<ProgramsCubit, ProgramsStates>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        if (country == null) {
                                          return Center(
                                              child: Text(
                                                  TranslationKeyManager.chooseCountry.tr));
                                        } else if (state
                                        is CitiesGetLoadingState) {
                                          return Center(
                                              child:
                                              CircularProgressIndicator());
                                        } else if (state
                                        is CitiesGetErrorState) {
                                          return Center(
                                              child: Text(state.error));
                                        } else if (country!.cities.isEmpty) {
                                          return Center(
                                              child: Text(
                                                  TranslationKeyManager.noCities.tr));
                                        } else {
                                          return Expanded(
                                            child: ListView.builder(
                                                itemCount:
                                                country!.cities.length,
                                                itemBuilder:
                                                    (context, index) => Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          5.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          city = country!
                                                              .cities[
                                                          index];
                                                          setState(
                                                                  () {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                              child:
                                                              Container(
                                                                height:
                                                                50,
                                                                width:
                                                                50,
                                                                child:
                                                                CachedNetworkImage(
                                                                  imageUrl:
                                                                  'https://api.seasonsge.com/images/Agents/${country!.cities[index].img!}',
                                                                  placeholder: (context, error) =>
                                                                  const Icon(
                                                                    Icons.image_outlined,
                                                                    color:
                                                                    Colors.grey,
                                                                  ),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  errorWidget: (context, url, error) =>
                                                                  const Icon(
                                                                    Icons.image_outlined,
                                                                    color:
                                                                    Colors.grey,
                                                                  ),
                                                                ),
                                                                // Image.network(
                                                                //   'https://api.seasonsge.com/images/Agents/${country!.cities[index].img!}',
                                                                //   fit: BoxFit
                                                                //       .fill,),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  CacheData.lang == CacheHelperKeys.keyEN?
                                                                  country!.cities[index].nameEn!:
                                                                  country!.cities[index].name!,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: ColorsManager.primaryColor),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          50.0),
                                                      child: Divider(),
                                                    )
                                                  ],
                                                )),
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    },
                    child: DefaultField(
                        horizontalPadding: 20,
                        prefix:  Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                          child: FaIcon(
                            FontAwesomeIcons.city,
                            color: ColorsManager.iconColor,
                            size: 20,
                          ),
                        ),
                        enabled: false,
                        hint: TranslationKeyManager.city.tr,
                        controller: TextEditingController(
                            text: city != null ?
                            CacheData.lang == CacheHelperKeys.keyEN ?
                            city!.nameEn! :
                            city!.name! :
                            ''
                        ))),
                SizedBox(height: 15,),
                InkWell(
                    onTap: ()
                    {
                      DateTime? startDate;
                      DateTime? endDate;
                      Get.to(
                            () => Scaffold(
                          appBar: defaultAppBar(
                              context: context, text: TranslationKeyManager.hotels.tr),
                          body: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SfDateRangePicker(
                                  todayHighlightColor:
                                  ColorsManager.primaryColor,
                                  toggleDaySelection: true,
                                  startRangeSelectionColor:
                                  ColorsManager.primaryColor,
                                  endRangeSelectionColor:
                                  ColorsManager.primaryColor,
                                  rangeSelectionColor: ColorsManager
                                      .primaryColor
                                      .withOpacity(0.3),
                                  showActionButtons: true,
                                  view: DateRangePickerView.month,
                                  enablePastDates: false,
                                  selectionMode:
                                  DateRangePickerSelectionMode.range,
                                  showTodayButton: true,
                                  onSubmit: (object) {
                                    if (startDate == null || endDate == null)
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text(
                                              TranslationKeyManager
                                                  .dateRange
                                                  .tr)));
                                    }
                                    else
                                    {
                                      startDateOfficial = startDate;
                                      endDateOfficial = endDate;
                                      setState(() {});
                                      Navigator.pop(context);
                                    }
                                    print(object.toString());
                                  },
                                  onCancel: () {
                                    Navigator.pop(context);
                                  },
                                  monthCellStyle: DateRangePickerMonthCellStyle(
                                      todayTextStyle: TextStyle(
                                          color: ColorsManager.primaryColor)),
                                  onSelectionChanged:
                                      (DateRangePickerSelectionChangedArgs
                                  args) {

                                    if (args.value.startDate !=
                                        null) {
                                      startDate = args.value.startDate;
                                    } else {
                                      startDate = null;
                                    }
                                    if (args.value.endDate != null) {
                                      endDate =args.value.endDate;
                                    } else {
                                      endDate = null;
                                    }

                                  }),
                            ),
                          ),
                        ),
                        // transition: Transition.downToUp,
                        // duration: Duration(seconds: 1)
                      );
                    },
                    child: DefaultField(
                        horizontalPadding: 20,
                        prefix:  Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                          child: FaIcon(
                            FontAwesomeIcons.calendarDays,
                            color: ColorsManager.iconColor,
                            size: 20,
                          ),
                        ),
                        enabled: false,
                        hint: CacheData.lang == CacheHelperKeys.keyEN ?
                        'When ?':'متي ؟',
                        controller: TextEditingController(
                            text: (startDateOfficial == null || endDateOfficial == null)?
                                '':
                            '${DateFormat('dd/MM/yyyy').format(startDateOfficial!)} : ${DateFormat('dd/MM/yyyy').format(endDateOfficial!) }'
                        ))),
                SizedBox(height: 15,),
                BlocConsumer<HotelsCubit, HotelsStates>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      int rooms = HotelsCubit.get(context).roomsData.length;
                      int kidsWithBed = 0;
                      int kidsWithNoBed = 0;
                      int infants = 0;
                      int adults = 0;
                      HotelsCubit.get(context).roomsData.forEach((element) {
                        adults += element.adults;
                        kidsWithBed += element.kidsWithBed;
                        kidsWithNoBed += element.kidsWithNoBed;
                        infants += element.infants;
                      });
                      return InkWell(
                          onTap: ()
                          {
                            Get.to(
                                  () => HotelsAdultNumberView(
                                  roomsData:
                                  HotelsCubit.get(context).roomsData),
                            );
                          },
                          child: DefaultField(
                              horizontalPadding: 20,
                              prefix:  Padding(
                                padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                                child: FaIcon(
                                  FontAwesomeIcons.users,
                                  color: ColorsManager.iconColor,
                                  size: 20,
                                ),
                              ),
                              enabled: false,
                              hint: CacheData.lang == CacheHelperKeys.keyEN ?
                              'Passengers ?':'المسافرون',
                              controller: TextEditingController(
                                text: CacheData.lang == CacheHelperKeys.keyEN?
                                '$rooms ${'rooms'}, ${adults} adults, ${kidsWithNoBed+kidsWithBed} Children, $infants Infants':
                                '$rooms ${'غرفة'}, ${adults} بالغ, ${kidsWithNoBed+kidsWithBed} طفل, $infants رضيع ',
                              )));
                    }),
                SizedBox(height: 20,),

              ],
            ),
          ),

        ]
    );
  }
}
