import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/my_tab_bar_view.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/delay_manager.dart';
import 'package:seasons/features/airports/cubit/airports_cubit.dart';
import 'package:seasons/features/airports/cubit/airports_states.dart';
import 'package:seasons/features/airports/data/models/airport_model.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_cubit.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_states.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/tab_bar_item.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/localization/translation_key_manager.dart';
import 'adult_number_view2.dart';
import 'flights_results_view.dart';
import 'roundtrip_view.dart';

class FlightsView extends StatefulWidget {
  const FlightsView(
      {Key? key,
      //  required this.fromAirport, required this.toAirport
      })
      : super(key: key);
  // final AirportModel fromAirport;
  // final AirportModel toAirport;

  @override
  State<FlightsView> createState() => _FlightsState();
}

class _FlightsState extends State<FlightsView> {
  bool roundTrip = true;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var search = TextEditingController();

  DateTime? startDateOfficial;
  DateTime? endDateOfficial;
  AirportModel? fromAirport;
  AirportModel? toAirport;
  bool direct = true;
  bool isSearch = false;

  List<int> kidsAges = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlightsCubit, FlightsStates>(
      listener: (context, state) {
        if (state is FlightsFilterSuccessState) {
          Get.to(() => FlightResultsView(
            roundTrip: roundTrip,
            fromAirport: fromAirport!,
            toAirport: toAirport!,
            startDateOfficial: DateFormat('dd/MM/yyyy').format(startDateOfficial!).toString(),
            endDateOfficial: roundTrip ? DateFormat('dd/MM/yyyy').format(endDateOfficial!).toString() : null,
          ),
          transition: DelayManager.transitionToBook,
          duration: Duration(milliseconds: 500));
        }
        if (state is FlightsFilterSuccessWithNoDataState) {
          Get.to(() => FlightResultsView(
            noData: true,
            roundTrip: roundTrip,
            fromAirport: fromAirport!,
            toAirport: toAirport!,
            startDateOfficial: DateFormat('dd/MM/yyyy').format(startDateOfficial!).toString(),
            endDateOfficial: roundTrip ? DateFormat('dd/MM/yyyy').format(endDateOfficial!).toString() : null,
          ),
              transition: DelayManager.transitionToBook,
              duration: Duration(milliseconds: 500));
        }
      },
      builder: (context, state) {
        return BasicView2(
          scaffoldKey: scaffoldKey,
          button: (state is FlightsFilterLoadingState)
              ? CircularProgressIndicator()
              : SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: ((roundTrip && (startDateOfficial == null || endDateOfficial == null)) ||
                    (!roundTrip && startDateOfficial == null)) || (fromAirport ==null || toAirport ==null)
                    ? null
                    : () {
                  FlightsCubit.get(context).filter(
                      from: fromAirport!.id!,
                      to: toAirport!.id!,
                      returnDate: endDateOfficial,
                      departureDate: startDateOfficial!,
                      allowReturn: roundTrip? 1 : 0,
                      ticketsNumber: FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids
                  );
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color:  ((roundTrip && (startDateOfficial == null || endDateOfficial == null)) ||
                        (!roundTrip && startDateOfficial == null))|| (fromAirport ==null || toAirport ==null)
                        ?
                    Colors.grey:
                    ColorsManager.primaryColor,
                      borderRadius: BorderRadius.circular(0)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      TranslationKeyManager.searchFlight.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Cairo",
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )),
            appbarTitle: TranslationKeyManager.bottomNavFlight.tr,
            children:
            [
              Container(
                color: ColorsManager.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MyTabBarView(
                  length: 2,
                  onTab: (index) {
                    if (index == 0) {
                      roundTrip = true;
                    } else {
                      roundTrip = false;
                    }
                    setState(() {});
                  },
                  tabs: [
                    TabBarItem(
                      selected: roundTrip,
                        label: TranslationKeyManager.roundTrip.tr.toUpperCase()),
                    TabBarItem(
                        selected: !roundTrip,
                        label: TranslationKeyManager.oneWay.tr.toUpperCase()),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        Column(
                          children: [
                            InkWell(
                                onTap: ()
                                {
                                  // if(fromAirport !=null)
                                  // {
                                  //   search.text =  CacheData.lang == CacheHelperKeys.keyEN? fromAirport!.englishName! :fromAirport!.arabicName!;
                                  // }
                                  // else
                                    search.text='';
                                  scaffoldKey.currentState!.showBottomSheet(
                                      backgroundColor: Colors.transparent, (context) {
                                    return BottomSheetBody(
                                      fromAirport: fromAirport,
                                      isSearch: isSearch,
                                      search: search,
                                      onTap: (model)
                                      {
                                        fromAirport = model;
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                    );
                                    // return Stack(
                                    //   alignment: Alignment.bottomCenter,
                                    //   children: [
                                    //     InkWell(
                                    //       onTap: () {
                                    //         Navigator.pop(context);
                                    //       },
                                    //       child: Container(
                                    //         width: double.infinity,
                                    //         height: MediaQuery.of(context).size.height,
                                    //         color: Colors.black.withOpacity(0.5),
                                    //       ),
                                    //     ),
                                    //     Container(
                                    //       width: double.infinity,
                                    //       height: MediaQuery.of(context).size.height * 0.65,
                                    //       decoration: BoxDecoration(
                                    //           //color: Colors.white,
                                    //           color: Theme.of(context).scaffoldBackgroundColor,
                                    //           borderRadius: BorderRadius.only(
                                    //             topRight: Radius.circular(20),
                                    //             topLeft: Radius.circular(20),
                                    //           )),
                                    //       padding: EdgeInsets.symmetric(
                                    //           vertical: 20),
                                    //       child: Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           DefaultField(
                                    //             onChange: (String val) {
                                    //               if (val.isEmpty)
                                    //               {
                                    //                 isSearch = false;
                                    //               }
                                    //               else
                                    //               {
                                    //                 isSearch = true;
                                    //               }
                                    //               AirportsCubit.get(context).filter(name: val);
                                    //             },
                                    //             controller: search,
                                    //             hint: TranslationKeyManager.search.tr,
                                    //             prefix: Padding(
                                    //               padding: EdgeInsets.symmetric(horizontal: 15),
                                    //               child: FaIcon(
                                    //                 FontAwesomeIcons.magnifyingGlass,
                                    //                 color: ColorsManager.iconColor,
                                    //                 size: 20,
                                    //               )
                                    //             ),
                                    //
                                    //           ),
                                    //           // TextFormField(
                                    //           //   onChanged: (String val) {
                                    //           //     if (val.isEmpty)
                                    //           //     {
                                    //           //       isSearch = false;
                                    //           //     }
                                    //           //     else
                                    //           //     {
                                    //           //       isSearch = true;
                                    //           //     }
                                    //           //     AirportsCubit.get(context).filter(name: val);
                                    //           //   },
                                    //           //   controller: search,
                                    //           //   style: TextStyle(
                                    //           //       color: Colors.white,
                                    //           //       fontWeight: FontWeight.w600),
                                    //           //   decoration: InputDecoration(
                                    //           //       hintText: TranslationKeyManager.search.tr,
                                    //           //       filled: true,
                                    //           //       fillColor: Colors.black.withOpacity(0.5),
                                    //           //       prefixIcon: Icon(
                                    //           //         Icons.location_pin,
                                    //           //         size: 18,
                                    //           //       ),
                                    //           //       prefixIconColor: Colors.white,
                                    //           //       hintStyle: TextStyle(
                                    //           //           color: Colors.grey.withOpacity(0.8),
                                    //           //           fontWeight: FontWeight.w600),
                                    //           //       enabledBorder: OutlineInputBorder(
                                    //           //           borderRadius: BorderRadius.circular(3),
                                    //           //           borderSide: BorderSide(
                                    //           //               color: Colors.transparent)),
                                    //           //       focusedBorder: OutlineInputBorder(
                                    //           //           borderRadius: BorderRadius.circular(3),
                                    //           //           borderSide: BorderSide(
                                    //           //             color: Colors.transparent,
                                    //           //           )),
                                    //           //       contentPadding: const EdgeInsets.symmetric(
                                    //           //           horizontal: 10, vertical: 10)),
                                    //           // ),
                                    //           SizedBox(
                                    //             height: 20,
                                    //           ),
                                    //           BlocConsumer<AirportsCubit, AirportsStates>(
                                    //               listener: (context, state) {},
                                    //               builder: (context, state)
                                    //               {
                                    //                 if (state is AirportsGetLoadingState ||
                                    //                     state is AirportsFilterLoadingState)
                                    //                 {
                                    //                   return Column(
                                    //                     mainAxisAlignment: MainAxisAlignment.center,
                                    //                     children: [
                                    //                       SizedBox(
                                    //                           height: 30,
                                    //                           width: 30,
                                    //                           child: CircularProgressIndicator()),
                                    //                     ],
                                    //                   );
                                    //                 }
                                    //                 else if (state is AirportsGetErrorState)
                                    //                 {
                                    //                   return Column(
                                    //                     mainAxisAlignment: MainAxisAlignment.center,
                                    //                     children: [
                                    //                       Text(state.error),
                                    //                     ],
                                    //                   );
                                    //                 }
                                    //                 else if (state is AirportsFilterErrorState)
                                    //                 {
                                    //                   return Column(
                                    //                     mainAxisAlignment: MainAxisAlignment.center,
                                    //                     children: [
                                    //                       Text(state.error),
                                    //                     ],
                                    //                   );
                                    //                 }
                                    //                 else if ((fromAirport == null || search.text.isEmpty) && !isSearch)
                                    //                 {
                                    //                   // show all
                                    //                   return Expanded(
                                    //                     child: Column(
                                    //                       children: [
                                    //                         Container(
                                    //                           padding: EdgeInsets.symmetric(horizontal: 30),
                                    //                           width: double.infinity,
                                    //                           color: Colors.grey.withOpacity(0.2),
                                    //                           child: Text(
                                    //                             TranslationKeyManager.allAirports.tr,
                                    //                             style: TextStyle(
                                    //                                 color: Colors.grey,
                                    //                                 fontWeight: FontWeight.bold),
                                    //                           ),
                                    //                         ),
                                    //                         SizedBox(
                                    //                           height: 15,
                                    //                         ),
                                    //                         Expanded(
                                    //                           child: ListView.builder(
                                    //                               itemCount: AirportsCubit.get(context)
                                    //                                   .airportsResponse!
                                    //                                   .data!
                                    //                                   .length,
                                    //                               itemBuilder: (context, index) => Padding(
                                    //                                 padding: const EdgeInsets.symmetric(
                                    //                                     horizontal: 30.0,vertical: 7),
                                    //                                 child: InkWell(
                                    //                                   onTap: () {
                                    //                                     fromAirport =
                                    //                                     AirportsCubit.get(context)
                                    //                                         .airportsResponse!
                                    //                                         .data![index];
                                    //                                     Navigator.pop(context);
                                    //                                     setState(() {});
                                    //                                   },
                                    //                                   child: Column(
                                    //                                     crossAxisAlignment:
                                    //                                     CrossAxisAlignment.start,
                                    //                                     children: [
                                    //                                       Row(
                                    //                                         mainAxisAlignment:
                                    //                                         MainAxisAlignment.start,
                                    //                                         crossAxisAlignment:
                                    //                                         CrossAxisAlignment.center,
                                    //                                         children: [
                                    //                                           Transform.rotate(
                                    //                                               angle: pi * 0.2,
                                    //                                               child: Icon(
                                    //                                                   Icons
                                    //                                                       .airplanemode_on_sharp,
                                    //                                                   size: 20,
                                    //                                                   color: Colors.grey)),
                                    //                                           SizedBox(
                                    //                                             width: 10,
                                    //                                           ),
                                    //                                           Text(
                                    //                                             CacheData.lang == CacheHelperKeys.keyEN?
                                    //                                             AirportsCubit.get(context).airportsResponse!.data![index].englishName!:
                                    //                                             AirportsCubit.get(context).airportsResponse!.data![index].arabicName!,
                                    //                                             style: TextStyle(
                                    //                                                 fontWeight:
                                    //                                                 FontWeight.bold,
                                    //                                                 color: Colors.black),
                                    //                                             maxLines: 1,
                                    //                                             overflow:
                                    //                                             TextOverflow.ellipsis,
                                    //                                           ),
                                    //                                         ],
                                    //                                       ),
                                    //                                       Divider()
                                    //                                     ],
                                    //                                   ),
                                    //                                 ),
                                    //                               )),
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   );
                                    //                 }
                                    //                 else
                                    //                 {
                                    //                   // show filtered
                                    //                   return Expanded(
                                    //                     child: Column(
                                    //                       children: [
                                    //                         Container(
                                    //                           padding: EdgeInsets.symmetric(horizontal: 30),
                                    //                           width: double.infinity,
                                    //                           color: Colors.grey.withOpacity(0.2),
                                    //                           child: Text(
                                    //                             TranslationKeyManager.results.tr,
                                    //                             style: TextStyle(
                                    //                                 color: Colors.grey,
                                    //                                 fontWeight: FontWeight.bold),
                                    //                           ),
                                    //                         ),
                                    //                         SizedBox(
                                    //                           height: 15,
                                    //                         ),
                                    //                         Expanded(
                                    //                           child: ListView.builder(
                                    //                               itemCount: AirportsCubit.get(context)
                                    //                                   .airPortsFiltered
                                    //                                   .length,
                                    //                               itemBuilder: (context, index) => Padding(
                                    //                                 padding: const EdgeInsets.symmetric(
                                    //                                     horizontal: 30.0, vertical: 7),
                                    //                                 child: InkWell(
                                    //                                   onTap: () {
                                    //                                     fromAirport =
                                    //                                     AirportsCubit.get(context)
                                    //                                         .airPortsFiltered[index];
                                    //                                     Navigator.pop(context);
                                    //                                     setState(() {});
                                    //                                   },
                                    //                                   child: Column(
                                    //                                     crossAxisAlignment:
                                    //                                     CrossAxisAlignment.start,
                                    //                                     children: [
                                    //                                       Row(
                                    //                                         mainAxisAlignment:
                                    //                                         MainAxisAlignment.start,
                                    //                                         crossAxisAlignment:
                                    //                                         CrossAxisAlignment.center,
                                    //                                         children: [
                                    //                                           Transform.rotate(
                                    //                                               angle: pi * 0.2,
                                    //                                               child: Icon(
                                    //                                                   Icons
                                    //                                                       .airplanemode_on_sharp,
                                    //                                                   size: 20,
                                    //                                                   color: Colors.grey)),
                                    //                                           SizedBox(
                                    //                                             width: 10,
                                    //                                           ),
                                    //                                           Text(
                                    //                                             CacheData.lang == CacheHelperKeys.keyEN?
                                    //                                             AirportsCubit.get(context).airPortsFiltered[index].englishName!:
                                    //                                             AirportsCubit.get(context).airPortsFiltered[index].arabicName!,
                                    //                                             style: TextStyle(
                                    //                                                 fontWeight:
                                    //                                                 FontWeight.bold,
                                    //                                                 color: Colors.black),
                                    //                                           ),
                                    //                                         ],
                                    //                                       ),
                                    //                                       Divider()
                                    //                                     ],
                                    //                                   ),
                                    //                                 ),
                                    //                               )),
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   );
                                    //                 }
                                    //               })
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // );
                                  });
                                },
                                child: DefaultField(
                                  horizontalPadding: 20,
                                  prefix:  Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10),
                                    child: FaIcon(
                                      FontAwesomeIcons.planeDeparture,
                                      color: ColorsManager.iconColor,
                                      size: 20,
                                    ),
                                  ),
                                    enabled: false,
                                    hint: TranslationKeyManager.whereFrom.tr,
                                    controller: TextEditingController(
                                      text: fromAirport != null?
                                      CacheData.lang == CacheHelperKeys.keyEN ?
                                      fromAirport!.englishName!:
                                      fromAirport!.arabicName! :
                                      ''
                                    ))),
                            SizedBox(height: 15,),
                            // InkWell(
                            //   onTap: ()
                            //   {
                            //     if(fromAirport !=null)
                            //     {
                            //       search.text =  CacheData.lang == CacheHelperKeys.keyEN? fromAirport!.englishName! :fromAirport!.arabicName!;
                            //     }
                            //     else
                            //       search.text='';
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
                            //                 TextFormField(
                            //                   onChanged: (String val) {
                            //                     if (val.isEmpty)
                            //                     {
                            //                       isSearch = false;
                            //                     }
                            //                     else
                            //                     {
                            //                       isSearch = true;
                            //                     }
                            //                     AirportsCubit.get(context).filter(name: val);
                            //                   },
                            //                   controller: search,
                            //                   style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontWeight: FontWeight.w600),
                            //                   decoration: InputDecoration(
                            //                       hintText: TranslationKeyManager.search.tr,
                            //                       filled: true,
                            //                       fillColor: Colors.black.withOpacity(0.5),
                            //                       prefixIcon: Icon(
                            //                         Icons.location_pin,
                            //                         size: 18,
                            //                       ),
                            //                       prefixIconColor: Colors.white,
                            //                       hintStyle: TextStyle(
                            //                           color: Colors.grey.withOpacity(0.8),
                            //                           fontWeight: FontWeight.w600),
                            //                       enabledBorder: OutlineInputBorder(
                            //                           borderRadius: BorderRadius.circular(3),
                            //                           borderSide: BorderSide(
                            //                               color: Colors.transparent)),
                            //                       focusedBorder: OutlineInputBorder(
                            //                           borderRadius: BorderRadius.circular(3),
                            //                           borderSide: BorderSide(
                            //                             color: Colors.transparent,
                            //                           )),
                            //                       contentPadding: const EdgeInsets.symmetric(
                            //                           horizontal: 10, vertical: 10)),
                            //                 ),
                            //                 SizedBox(
                            //                   height: 10,
                            //                 ),
                            //                 BlocConsumer<AirportsCubit, AirportsStates>(
                            //                     listener: (context, state) {},
                            //                     builder: (context, state)
                            //                     {
                            //                       if (state is AirportsGetLoadingState ||
                            //                           state is AirportsFilterLoadingState)
                            //                       {
                            //                         return Column(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             SizedBox(
                            //                                 height: 30,
                            //                                 width: 30,
                            //                                 child: CircularProgressIndicator()),
                            //                           ],
                            //                         );
                            //                       }
                            //                       else if (state is AirportsGetErrorState)
                            //                       {
                            //                         return Column(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Text(state.error),
                            //                           ],
                            //                         );
                            //                       }
                            //                       else if (state is AirportsFilterErrorState)
                            //                       {
                            //                         return Column(
                            //                           mainAxisAlignment: MainAxisAlignment.center,
                            //                           children: [
                            //                             Text(state.error),
                            //                           ],
                            //                         );
                            //                       }
                            //                       else if ((fromAirport == null || search.text.isEmpty) && !isSearch)
                            //                       {
                            //                         // show all
                            //                         return Expanded(
                            //                           child: Column(
                            //                             children: [
                            //                               Container(
                            //                                 padding: EdgeInsets.symmetric(horizontal: 20),
                            //                                 width: double.infinity,
                            //                                 color: Colors.grey.withOpacity(0.2),
                            //                                 child: Text(
                            //                                   TranslationKeyManager.allAirports.tr,
                            //                                   style: TextStyle(
                            //                                       color: Colors.grey,
                            //                                       fontWeight: FontWeight.bold),
                            //                                 ),
                            //                               ),
                            //                               SizedBox(
                            //                                 height: 10,
                            //                               ),
                            //                               Expanded(
                            //                                 child: ListView.builder(
                            //                                     itemCount: AirportsCubit.get(context)
                            //                                         .airportsResponse!
                            //                                         .data!
                            //                                         .length,
                            //                                     itemBuilder: (context, index) => Padding(
                            //                                       padding: const EdgeInsets.symmetric(
                            //                                           horizontal: 20.0,vertical: 5),
                            //                                       child: InkWell(
                            //                                         onTap: () {
                            //                                           fromAirport =
                            //                                           AirportsCubit.get(context)
                            //                                               .airportsResponse!
                            //                                               .data![index];
                            //                                           Navigator.pop(context);
                            //                                           setState(() {});
                            //                                         },
                            //                                         child: Column(
                            //                                           crossAxisAlignment:
                            //                                           CrossAxisAlignment.start,
                            //                                           children: [
                            //                                             Row(
                            //                                               mainAxisAlignment:
                            //                                               MainAxisAlignment.start,
                            //                                               crossAxisAlignment:
                            //                                               CrossAxisAlignment.center,
                            //                                               children: [
                            //                                                 Transform.rotate(
                            //                                                     angle: pi * 0.2,
                            //                                                     child: Icon(
                            //                                                         Icons
                            //                                                             .airplanemode_on_sharp,
                            //                                                         size: 20,
                            //                                                         color: Colors.grey)),
                            //                                                 SizedBox(
                            //                                                   width: 10,
                            //                                                 ),
                            //                                                 Text(
                            //                                                   CacheData.lang == CacheHelperKeys.keyEN?
                            //                                                   AirportsCubit.get(context).airportsResponse!.data![index].englishName!:
                            //                                                   AirportsCubit.get(context).airportsResponse!.data![index].arabicName!,
                            //                                                   style: TextStyle(
                            //                                                       fontWeight:
                            //                                                       FontWeight.bold,
                            //                                                       color: Colors.black),
                            //                                                   maxLines: 1,
                            //                                                   overflow:
                            //                                                   TextOverflow.ellipsis,
                            //                                                 ),
                            //                                               ],
                            //                                             ),
                            //                                             Divider()
                            //                                           ],
                            //                                         ),
                            //                                       ),
                            //                                     )),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         );
                            //                       }
                            //                       else
                            //                       {
                            //                         // show filtered
                            //                         return Expanded(
                            //                           child: Column(
                            //                             children: [
                            //                               Container(
                            //                                 padding: EdgeInsets.symmetric(horizontal: 20),
                            //                                 width: double.infinity,
                            //                                 color: Colors.grey.withOpacity(0.2),
                            //                                 child: Text(
                            //                                   TranslationKeyManager.results.tr,
                            //                                   style: TextStyle(
                            //                                       color: Colors.grey,
                            //                                       fontWeight: FontWeight.bold),
                            //                                 ),
                            //                               ),
                            //                               SizedBox(
                            //                                 height: 10,
                            //                               ),
                            //                               Expanded(
                            //                                 child: ListView.builder(
                            //                                     itemCount: AirportsCubit.get(context)
                            //                                         .airPortsFiltered
                            //                                         .length,
                            //                                     itemBuilder: (context, index) => Padding(
                            //                                       padding: const EdgeInsets.symmetric(
                            //                                           horizontal: 20.0, vertical: 5),
                            //                                       child: InkWell(
                            //                                         onTap: () {
                            //                                           fromAirport =
                            //                                           AirportsCubit.get(context)
                            //                                               .airPortsFiltered[index];
                            //                                           Navigator.pop(context);
                            //                                           setState(() {});
                            //                                         },
                            //                                         child: Column(
                            //                                           crossAxisAlignment:
                            //                                           CrossAxisAlignment.start,
                            //                                           children: [
                            //                                             Row(
                            //                                               mainAxisAlignment:
                            //                                               MainAxisAlignment.start,
                            //                                               crossAxisAlignment:
                            //                                               CrossAxisAlignment.center,
                            //                                               children: [
                            //                                                 Transform.rotate(
                            //                                                     angle: pi * 0.2,
                            //                                                     child: Icon(
                            //                                                         Icons
                            //                                                             .airplanemode_on_sharp,
                            //                                                         size: 20,
                            //                                                         color: Colors.grey)),
                            //                                                 SizedBox(
                            //                                                   width: 10,
                            //                                                 ),
                            //                                                 Text(
                            //                                                   CacheData.lang == CacheHelperKeys.keyEN?
                            //                                                   AirportsCubit.get(context).airPortsFiltered[index].englishName!:
                            //                                                   AirportsCubit.get(context).airPortsFiltered[index].arabicName!,
                            //                                                   style: TextStyle(
                            //                                                       fontWeight:
                            //                                                       FontWeight.bold,
                            //                                                       color: Colors.black),
                            //                                                 ),
                            //                                               ],
                            //                                             ),
                            //                                             Divider()
                            //                                           ],
                            //                                         ),
                            //                                       ),
                            //                                     )),
                            //                               ),
                            //                             ],
                            //                           ),
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
                            //           Icons.flight_takeoff,
                            //           color: ColorsManager.iconColor,
                            //         ),
                            //         SizedBox(
                            //           width: 15,
                            //         ),
                            //         Expanded(
                            //           child: Text(
                            //             fromAirport != null?
                            //             CacheData.lang == CacheHelperKeys.keyEN ?
                            //             fromAirport!.englishName!:
                            //             fromAirport!.arabicName! :
                            //             TranslationKeyManager.whereFrom.tr,
                            //             maxLines: 1,
                            //             overflow: TextOverflow.ellipsis,
                            //             style: TextStyle(
                            //               color: fromAirport == null?
                            //               Colors.grey:
                            //               Colors.black,
                            //               fontSize: 15,
                            //             ),
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            InkWell(
                                onTap: ()
                                {
                                  // if(toAirport !=null)
                                  // {
                                  //   search.text =  CacheData.lang == CacheHelperKeys.keyEN? toAirport!.englishName! :toAirport!.arabicName!;
                                  // }
                                  // else
                                    search.text='';
                                  scaffoldKey.currentState!.showBottomSheet(
                                      backgroundColor: Colors.transparent, (context) {
                                    return BottomSheetBody(
                                      fromAirport: toAirport,
                                      isSearch: isSearch,
                                      search: search,
                                      onTap: (model)
                                      {
                                        toAirport = model;
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                    );
                                    //  return Stack(
                                    //   alignment: Alignment.bottomCenter,
                                    //   children: [
                                    //     InkWell(
                                    //       onTap: () {
                                    //         Navigator.pop(context);
                                    //       },
                                    //       child: Container(
                                    //         width: double.infinity,
                                    //         height: MediaQuery.of(context).size.height,
                                    //         color: Colors.black.withOpacity(0.5),
                                    //       ),
                                    //     ),
                                    //     Container(
                                    //       width: double.infinity,
                                    //       height: MediaQuery.of(context).size.height * 0.65,
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.white,
                                    //           borderRadius: BorderRadius.only(
                                    //             topRight: Radius.circular(20),
                                    //             topLeft: Radius.circular(20),
                                    //           )),
                                    //       padding: EdgeInsets.symmetric(
                                    //           vertical: 20, horizontal: 20),
                                    //       child: Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           TextFormField(
                                    //             onChanged: (String val) {
                                    //               if (val.isEmpty)
                                    //               {
                                    //                 isSearch = false;
                                    //               }
                                    //               else
                                    //               {
                                    //                 isSearch = true;
                                    //               }
                                    //               AirportsCubit.get(context).filter(name: val);
                                    //             },
                                    //             controller: search,
                                    //             style: TextStyle(
                                    //                 color: Colors.white,
                                    //                 fontWeight: FontWeight.w600),
                                    //             decoration: InputDecoration(
                                    //                 hintText: TranslationKeyManager.search.tr,
                                    //                 filled: true,
                                    //                 fillColor: Colors.black.withOpacity(0.5),
                                    //                 prefixIcon: Icon(
                                    //                   Icons.location_pin,
                                    //                   size: 18,
                                    //                 ),
                                    //                 prefixIconColor: Colors.white,
                                    //                 hintStyle: TextStyle(
                                    //                     color: Colors.grey.withOpacity(0.8),
                                    //                     fontWeight: FontWeight.w600),
                                    //                 enabledBorder: OutlineInputBorder(
                                    //                     borderRadius: BorderRadius.circular(3),
                                    //                     borderSide: BorderSide(
                                    //                         color: Colors.transparent)),
                                    //                 focusedBorder: OutlineInputBorder(
                                    //                     borderRadius: BorderRadius.circular(3),
                                    //                     borderSide: BorderSide(
                                    //                       color: Colors.transparent,
                                    //                     )),
                                    //                 contentPadding: const EdgeInsets.symmetric(
                                    //                     horizontal: 10, vertical: 10)),
                                    //           ),
                                    //           SizedBox(
                                    //             height: 10,
                                    //           ),
                                    //           BlocConsumer<AirportsCubit, AirportsStates>(
                                    //               listener: (context, state) {},
                                    //               builder: (context, state)
                                    //               {
                                    //                 if (state is AirportsGetLoadingState ||
                                    //                     state is AirportsFilterLoadingState)
                                    //                 {
                                    //                   return Column(
                                    //                     mainAxisAlignment: MainAxisAlignment.center,
                                    //                     children: [
                                    //                       SizedBox(
                                    //                           height: 30,
                                    //                           width: 30,
                                    //                           child: CircularProgressIndicator()),
                                    //                     ],
                                    //                   );
                                    //                 }
                                    //                 else if (state is AirportsGetErrorState)
                                    //                 {
                                    //                   return Column(
                                    //                     mainAxisAlignment: MainAxisAlignment.center,
                                    //                     children: [
                                    //                       Text(state.error),
                                    //                     ],
                                    //                   );
                                    //                 }
                                    //                 else if (state is AirportsFilterErrorState)
                                    //                 {
                                    //                   return Column(
                                    //                     mainAxisAlignment: MainAxisAlignment.center,
                                    //                     children: [
                                    //                       Text(state.error),
                                    //                     ],
                                    //                   );
                                    //                 }
                                    //                 else if ((fromAirport == null || search.text.isEmpty) && !isSearch)
                                    //                 {
                                    //                   // show all
                                    //                   return Expanded(
                                    //                     child: Column(
                                    //                       children: [
                                    //                         Container(
                                    //                           padding: EdgeInsets.symmetric(horizontal: 20),
                                    //                           width: double.infinity,
                                    //                           color: Colors.grey.withOpacity(0.2),
                                    //                           child: Text(
                                    //                             TranslationKeyManager.allAirports.tr,
                                    //                             style: TextStyle(
                                    //                                 color: Colors.grey,
                                    //                                 fontWeight: FontWeight.bold),
                                    //                           ),
                                    //                         ),
                                    //                         SizedBox(
                                    //                           height: 10,
                                    //                         ),
                                    //                         Expanded(
                                    //                           child: ListView.builder(
                                    //                               itemCount: AirportsCubit.get(context)
                                    //                                   .airportsResponse!
                                    //                                   .data!
                                    //                                   .length,
                                    //                               itemBuilder: (context, index) => Padding(
                                    //                                 padding: const EdgeInsets.symmetric(
                                    //                                     horizontal: 20.0,vertical: 5),
                                    //                                 child: InkWell(
                                    //                                   onTap: () {
                                    //                                     toAirport =
                                    //                                     AirportsCubit.get(context)
                                    //                                         .airportsResponse!
                                    //                                         .data![index];
                                    //                                     Navigator.pop(context);
                                    //                                     setState(() {});
                                    //                                   },
                                    //                                   child: Column(
                                    //                                     crossAxisAlignment:
                                    //                                     CrossAxisAlignment.start,
                                    //                                     children: [
                                    //                                       Row(
                                    //                                         mainAxisAlignment:
                                    //                                         MainAxisAlignment.start,
                                    //                                         crossAxisAlignment:
                                    //                                         CrossAxisAlignment.center,
                                    //                                         children: [
                                    //                                           Transform.rotate(
                                    //                                               angle: pi * 0.2,
                                    //                                               child: Icon(
                                    //                                                   Icons
                                    //                                                       .airplanemode_on_sharp,
                                    //                                                   size: 20,
                                    //                                                   color: Colors.grey)),
                                    //                                           SizedBox(
                                    //                                             width: 10,
                                    //                                           ),
                                    //                                           Text(
                                    //                                             CacheData.lang == CacheHelperKeys.keyEN?
                                    //                                             AirportsCubit.get(context).airportsResponse!.data![index].englishName!:
                                    //                                             AirportsCubit.get(context).airportsResponse!.data![index].arabicName!,
                                    //                                             style: TextStyle(
                                    //                                                 fontWeight:
                                    //                                                 FontWeight.bold,
                                    //                                                 color: Colors.black),
                                    //                                             maxLines: 1,
                                    //                                             overflow:
                                    //                                             TextOverflow.ellipsis,
                                    //                                           ),
                                    //                                         ],
                                    //                                       ),
                                    //                                       Divider()
                                    //                                     ],
                                    //                                   ),
                                    //                                 ),
                                    //                               )),
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   );
                                    //                 }
                                    //                 else
                                    //                 {
                                    //                   // show filtered
                                    //                   return Expanded(
                                    //                     child: Column(
                                    //                       children: [
                                    //                         Container(
                                    //                           padding: EdgeInsets.symmetric(horizontal: 20),
                                    //                           width: double.infinity,
                                    //                           color: Colors.grey.withOpacity(0.2),
                                    //                           child: Text(
                                    //                             TranslationKeyManager.results.tr,
                                    //                             style: TextStyle(
                                    //                                 color: Colors.grey,
                                    //                                 fontWeight: FontWeight.bold),
                                    //                           ),
                                    //                         ),
                                    //                         SizedBox(
                                    //                           height: 10,
                                    //                         ),
                                    //                         Expanded(
                                    //                           child: ListView.builder(
                                    //                               itemCount: AirportsCubit.get(context)
                                    //                                   .airPortsFiltered
                                    //                                   .length,
                                    //                               itemBuilder: (context, index) => Padding(
                                    //                                 padding: const EdgeInsets.symmetric(
                                    //                                     horizontal: 20.0, vertical: 5),
                                    //                                 child: InkWell(
                                    //                                   onTap: () {
                                    //                                     toAirport =
                                    //                                     AirportsCubit.get(context)
                                    //                                         .airPortsFiltered[index];
                                    //                                     Navigator.pop(context);
                                    //                                     setState(() {});
                                    //                                   },
                                    //                                   child: Column(
                                    //                                     crossAxisAlignment:
                                    //                                     CrossAxisAlignment.start,
                                    //                                     children: [
                                    //                                       Row(
                                    //                                         mainAxisAlignment:
                                    //                                         MainAxisAlignment.start,
                                    //                                         crossAxisAlignment:
                                    //                                         CrossAxisAlignment.center,
                                    //                                         children: [
                                    //                                           Transform.rotate(
                                    //                                               angle: pi * 0.2,
                                    //                                               child: Icon(
                                    //                                                   Icons
                                    //                                                       .airplanemode_on_sharp,
                                    //                                                   size: 20,
                                    //                                                   color: Colors.grey)),
                                    //                                           SizedBox(
                                    //                                             width: 10,
                                    //                                           ),
                                    //                                           Text(
                                    //                                             CacheData.lang == CacheHelperKeys.keyEN?
                                    //                                             AirportsCubit.get(context).airPortsFiltered[index].englishName!:
                                    //                                             AirportsCubit.get(context).airPortsFiltered[index].arabicName!,
                                    //                                             style: TextStyle(
                                    //                                                 fontWeight:
                                    //                                                 FontWeight.bold,
                                    //                                                 color: Colors.black),
                                    //                                           ),
                                    //                                         ],
                                    //                                       ),
                                    //                                       Divider()
                                    //                                     ],
                                    //                                   ),
                                    //                                 ),
                                    //                               )),
                                    //                         ),
                                    //                       ],
                                    //                     ),
                                    //                   );
                                    //                 }
                                    //               })
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // );
                                  });
                                },
                                child: DefaultField(
                                    horizontalPadding: 20,
                                    prefix:  Padding(
                                      padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10),
                                      child: FaIcon(
                                        FontAwesomeIcons.planeArrival,
                                        color: ColorsManager.iconColor,
                                        size: 20,
                                      ),
                                    ),
                                    enabled: false,
                                    hint: TranslationKeyManager.whereTo.tr,
                                    controller: TextEditingController(
                                      text: toAirport != null?
                                      CacheData.lang == CacheHelperKeys.keyEN ?
                                      toAirport!.englishName!:
                                      toAirport!.arabicName! :
                                      '',
                                    ))),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(onPressed: ()
                          {
                            AirportModel? temp = fromAirport;
                            fromAirport = toAirport;
                            toAirport = temp;
                            setState(() {});
                          }, icon: Icon(Icons.change_circle, size: 35,)),
                        ),
                      ],
                    ),
                    // InkWell(
                    //   onTap:()
                    //   {
                    //     if(toAirport !=null)
                    //     {
                    //       search.text =  CacheData.lang == CacheHelperKeys.keyEN? toAirport!.englishName! :toAirport!.arabicName!;
                    //     }
                    //     else
                    //       search.text='';
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
                    //                 //color: Colors.white,
                    //                 borderRadius: BorderRadius.only(
                    //                   topRight: Radius.circular(20),
                    //                   topLeft: Radius.circular(20),
                    //                 )),
                    //             padding: EdgeInsets.symmetric(
                    //                 vertical: 20, horizontal: 20),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 TextFormField(
                    //                   onChanged: (String val) {
                    //                     if (val.isEmpty)
                    //                     {
                    //                       isSearch = false;
                    //                     }
                    //                     else
                    //                     {
                    //                       isSearch = true;
                    //                     }
                    //                     AirportsCubit.get(context).filter(name: val);
                    //                   },
                    //                   controller: search,
                    //                   style: TextStyle(
                    //                       color: Colors.white,
                    //                       fontWeight: FontWeight.w600),
                    //                   decoration: InputDecoration(
                    //                       hintText: TranslationKeyManager.search.tr,
                    //                       filled: true,
                    //                       fillColor: Colors.black.withOpacity(0.5),
                    //                       prefixIcon: Icon(
                    //                         Icons.location_pin,
                    //                         size: 18,
                    //                       ),
                    //                       prefixIconColor: Colors.white,
                    //                       hintStyle: TextStyle(
                    //                           color: Colors.grey.withOpacity(0.8),
                    //                           fontWeight: FontWeight.w600),
                    //                       enabledBorder: OutlineInputBorder(
                    //                           borderRadius: BorderRadius.circular(3),
                    //                           borderSide: BorderSide(
                    //                               color: Colors.transparent)),
                    //                       focusedBorder: OutlineInputBorder(
                    //                           borderRadius: BorderRadius.circular(3),
                    //                           borderSide: BorderSide(
                    //                             color: Colors.transparent,
                    //                           )),
                    //                       contentPadding: const EdgeInsets.symmetric(
                    //                           horizontal: 10, vertical: 10)),
                    //                 ),
                    //                 SizedBox(
                    //                   height: 10,
                    //                 ),
                    //                 BlocConsumer<AirportsCubit, AirportsStates>(
                    //                     listener: (context, state) {},
                    //                     builder: (context, state)
                    //                     {
                    //                       if (state is AirportsGetLoadingState ||
                    //                           state is AirportsFilterLoadingState)
                    //                       {
                    //                         return Column(
                    //                           mainAxisAlignment: MainAxisAlignment.center,
                    //                           children: [
                    //                             SizedBox(
                    //                                 height: 30,
                    //                                 width: 30,
                    //                                 child: CircularProgressIndicator()),
                    //                           ],
                    //                         );
                    //                       }
                    //                       else if (state is AirportsGetErrorState)
                    //                       {
                    //                         return Column(
                    //                           mainAxisAlignment: MainAxisAlignment.center,
                    //                           children: [
                    //                             Text(state.error),
                    //                           ],
                    //                         );
                    //                       }
                    //                       else if (state is AirportsFilterErrorState)
                    //                       {
                    //                         return Column(
                    //                           mainAxisAlignment: MainAxisAlignment.center,
                    //                           children: [
                    //                             Text(state.error),
                    //                           ],
                    //                         );
                    //                       }
                    //                       else if ((fromAirport == null || search.text.isEmpty) && !isSearch)
                    //                       {
                    //                         // show all
                    //                         return Expanded(
                    //                           child: Column(
                    //                             children: [
                    //                               Container(
                    //                                 padding: EdgeInsets.symmetric(horizontal: 20),
                    //                                 width: double.infinity,
                    //                                 color: Colors.grey.withOpacity(0.2),
                    //                                 child: Text(
                    //                                   TranslationKeyManager.allAirports.tr,
                    //                                   style: TextStyle(
                    //                                       color: Colors.grey,
                    //                                       fontWeight: FontWeight.bold),
                    //                                 ),
                    //                               ),
                    //                               SizedBox(
                    //                                 height: 10,
                    //                               ),
                    //                               Expanded(
                    //                                 child: ListView.builder(
                    //                                     itemCount: AirportsCubit.get(context)
                    //                                         .airportsResponse!
                    //                                         .data!
                    //                                         .length,
                    //                                     itemBuilder: (context, index) => Padding(
                    //                                       padding: const EdgeInsets.symmetric(
                    //                                           horizontal: 20.0,vertical: 5),
                    //                                       child: InkWell(
                    //                                         onTap: () {
                    //                                           toAirport =
                    //                                           AirportsCubit.get(context)
                    //                                               .airportsResponse!
                    //                                               .data![index];
                    //                                           Navigator.pop(context);
                    //                                           setState(() {});
                    //                                         },
                    //                                         child: Column(
                    //                                           crossAxisAlignment:
                    //                                           CrossAxisAlignment.start,
                    //                                           children: [
                    //                                             Row(
                    //                                               mainAxisAlignment:
                    //                                               MainAxisAlignment.start,
                    //                                               crossAxisAlignment:
                    //                                               CrossAxisAlignment.center,
                    //                                               children: [
                    //                                                 Transform.rotate(
                    //                                                     angle: pi * 0.2,
                    //                                                     child: Icon(
                    //                                                         Icons
                    //                                                             .airplanemode_on_sharp,
                    //                                                         size: 20,
                    //                                                         color: Colors.grey)),
                    //                                                 SizedBox(
                    //                                                   width: 10,
                    //                                                 ),
                    //                                                 Text(
                    //                                                   CacheData.lang == CacheHelperKeys.keyEN?
                    //                                                   AirportsCubit.get(context).airportsResponse!.data![index].englishName!:
                    //                                                   AirportsCubit.get(context).airportsResponse!.data![index].arabicName!,
                    //                                                   style: TextStyle(
                    //                                                       fontWeight:
                    //                                                       FontWeight.bold,
                    //                                                       color: Colors.black),
                    //                                                   maxLines: 1,
                    //                                                   overflow:
                    //                                                   TextOverflow.ellipsis,
                    //                                                 ),
                    //                                               ],
                    //                                             ),
                    //                                             Divider()
                    //                                           ],
                    //                                         ),
                    //                                       ),
                    //                                     )),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         );
                    //                       }
                    //                       else
                    //                       {
                    //                         // show filtered
                    //                         return Expanded(
                    //                           child: Column(
                    //                             children: [
                    //                               Container(
                    //                                 padding: EdgeInsets.symmetric(horizontal: 20),
                    //                                 width: double.infinity,
                    //                                 color: Colors.grey.withOpacity(0.2),
                    //                                 child: Text(
                    //                                   TranslationKeyManager.results.tr,
                    //                                   style: TextStyle(
                    //                                       color: Colors.grey,
                    //                                       fontWeight: FontWeight.bold),
                    //                                 ),
                    //                               ),
                    //                               SizedBox(
                    //                                 height: 10,
                    //                               ),
                    //                               Expanded(
                    //                                 child: ListView.builder(
                    //                                     itemCount: AirportsCubit.get(context)
                    //                                         .airPortsFiltered
                    //                                         .length,
                    //                                     itemBuilder: (context, index) => Padding(
                    //                                       padding: const EdgeInsets.symmetric(
                    //                                           horizontal: 20.0, vertical: 5),
                    //                                       child: InkWell(
                    //                                         onTap: () {
                    //                                           toAirport =
                    //                                           AirportsCubit.get(context)
                    //                                               .airPortsFiltered[index];
                    //                                           Navigator.pop(context);
                    //                                           setState(() {});
                    //                                         },
                    //                                         child: Column(
                    //                                           crossAxisAlignment:
                    //                                           CrossAxisAlignment.start,
                    //                                           children: [
                    //                                             Row(
                    //                                               mainAxisAlignment:
                    //                                               MainAxisAlignment.start,
                    //                                               crossAxisAlignment:
                    //                                               CrossAxisAlignment.center,
                    //                                               children: [
                    //                                                 Transform.rotate(
                    //                                                     angle: pi * 0.2,
                    //                                                     child: Icon(
                    //                                                         Icons
                    //                                                             .airplanemode_on_sharp,
                    //                                                         size: 20,
                    //                                                         color: Colors.grey)),
                    //                                                 SizedBox(
                    //                                                   width: 10,
                    //                                                 ),
                    //                                                 Text(
                    //                                                   CacheData.lang == CacheHelperKeys.keyEN?
                    //                                                   AirportsCubit.get(context).airPortsFiltered[index].englishName!:
                    //                                                   AirportsCubit.get(context).airPortsFiltered[index].arabicName!,
                    //                                                   style: TextStyle(
                    //                                                       fontWeight:
                    //                                                       FontWeight.bold,
                    //                                                       color: Colors.black),
                    //                                                 ),
                    //                                               ],
                    //                                             ),
                    //                                             Divider()
                    //                                           ],
                    //                                         ),
                    //                                       ),
                    //                                     )),
                    //                               ),
                    //                             ],
                    //                           ),
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
                    //           Icons.flight_land_outlined,
                    //           color: ColorsManager.iconColor,
                    //         ),
                    //         SizedBox(
                    //           width: 15,
                    //         ),
                    //         Expanded(
                    //           child: Text(
                    //             toAirport != null?
                    //             CacheData.lang == CacheHelperKeys.keyEN ?
                    //             toAirport!.englishName!:
                    //             toAirport!.arabicName! :
                    //             TranslationKeyManager.whereTo.tr,
                    //             maxLines: 1,
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //               color: toAirport == null?
                    //               Colors.grey:
                    //               Colors.black,
                    //               fontSize: 15,
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: ()
                        {
                          DateTime? startDate;
                          DateTime? endDate;
                          Get.to(
                                  () => Scaffold(
                                appBar: defaultAppBar(
                                    context: context,
                                    text: TranslationKeyManager.bottomNavFlight.tr
                                ),
                                body: SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: SfDateRangePicker(

                                      todayHighlightColor: ColorsManager.primaryColor,
                                      toggleDaySelection: true,
                                      startRangeSelectionColor: ColorsManager.primaryColor,
                                      endRangeSelectionColor: ColorsManager.primaryColor,
                                      rangeSelectionColor: ColorsManager.primaryColor.withOpacity(0.3),
                                      showActionButtons: true,
                                      view: DateRangePickerView.month,
                                      enablePastDates: false,
                                      selectionMode: roundTrip ? DateRangePickerSelectionMode.range : DateRangePickerSelectionMode.single,
                                      showTodayButton: true,
                                      onSubmit: (object) {
                                        if (roundTrip) {
                                          if (startDate == null ||
                                              endDate == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    TranslationKeyManager
                                                        .dateRange
                                                        .tr)));
                                          } else {
                                            startDateOfficial = startDate;
                                            endDateOfficial = endDate;
                                            setState(() {});
                                            Navigator.pop(context);
                                          }
                                          print(object.toString());
                                        }
                                        else
                                        {
                                          if (startDate == null)
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    TranslationKeyManager
                                                        .dateRange
                                                        .tr)));
                                          } else {
                                            startDateOfficial = startDate;
                                            setState(() {});
                                            Navigator.pop(context);
                                          }
                                          print(object.toString());
                                        }
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      monthCellStyle: DateRangePickerMonthCellStyle(
                                          specialDatesDecoration: BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle
                                          ),
                                          specialDatesTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Colors.white
                                          ),
                                          todayTextStyle: TextStyle(
                                              color: ColorsManager.primaryColor
                                          )
                                      ),
                                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                        if (!roundTrip)
                                        {
                                          startDate = args.value;
                                          print(startDate);
                                        }
                                        else
                                        {
                                          if (args.value.startDate != null) {
                                            startDate = args.value.startDate;
                                          }
                                          else
                                          {
                                            startDate = null;
                                          }
                                          if (args.value.endDate != null)
                                          {
                                            endDate = args.value.endDate;
                                          }
                                          else
                                          {
                                            endDate = null;
                                          }
                                        }
                                      },
                                      monthViewSettings: DateRangePickerMonthViewSettings(specialDates: FlightsCubit.get(context).specialDates),
                                      //cellBuilder: cellBuilder,

                                    ),
                                  ),
                                ),
                              ),
                              transition: DelayManager.transitionToHotelDetails,
                              duration: Duration(seconds: 1));
                        },
                        child: DefaultField(
                            horizontalPadding: 20,
                            prefix:  Padding(
                              padding: const EdgeInsetsDirectional.only(start: 13.0, end: 15),
                              child: FaIcon(
                                FontAwesomeIcons.calendarDays,
                                color: ColorsManager.iconColor,
                                size: 20,
                              ),
                            ),
                            enabled: false,
                            hint: TranslationKeyManager.when.tr,
                            controller: TextEditingController(
                              text:  roundTrip
                                  ? (startDateOfficial == null ||
                                  endDateOfficial == null)
                                  ? ''
                                  : '${DateFormat('dd/MM/yyyy').format(startDateOfficial!)} - ${DateFormat('dd/MM/yyyy').format(endDateOfficial!)}'
                                  : startDateOfficial == null
                                  ? ''
                                  : '${DateFormat('dd/MM/yyyy').format(startDateOfficial!)}'
                            ))),
                    // InkWell(
                    //   onTap: () {
                    //     DateTime? startDate;
                    //     DateTime? endDate;
                    //     Get.to(
                    //             () => Scaffold(
                    //           appBar: defaultAppBar(
                    //               context: context,
                    //               text: TranslationKeyManager.bottomNavFlight.tr
                    //           ),
                    //           body: SafeArea(
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(20.0),
                    //               child: SfDateRangePicker(
                    //
                    //                 todayHighlightColor: ColorsManager.primaryColor,
                    //                 toggleDaySelection: true,
                    //                 startRangeSelectionColor: ColorsManager.primaryColor,
                    //                 endRangeSelectionColor: ColorsManager.primaryColor,
                    //                 rangeSelectionColor: ColorsManager.primaryColor.withOpacity(0.3),
                    //                 showActionButtons: true,
                    //                 view: DateRangePickerView.month,
                    //                 enablePastDates: false,
                    //                 selectionMode: roundTrip ? DateRangePickerSelectionMode.range : DateRangePickerSelectionMode.single,
                    //                 showTodayButton: true,
                    //                 onSubmit: (object) {
                    //                   if (roundTrip) {
                    //                     if (startDate == null ||
                    //                         endDate == null) {
                    //                       ScaffoldMessenger.of(context)
                    //                           .showSnackBar(SnackBar(
                    //                           content: Text(
                    //                               TranslationKeyManager
                    //                                   .dateRange
                    //                                   .tr)));
                    //                     } else {
                    //                       startDateOfficial = startDate;
                    //                       endDateOfficial = endDate;
                    //                       setState(() {});
                    //                       Navigator.pop(context);
                    //                     }
                    //                     print(object.toString());
                    //                   }
                    //                   else
                    //                   {
                    //                     if (startDate == null)
                    //                     {
                    //                       ScaffoldMessenger.of(context)
                    //                           .showSnackBar(SnackBar(
                    //                           content: Text(
                    //                               TranslationKeyManager
                    //                                   .dateRange
                    //                                   .tr)));
                    //                     } else {
                    //                       startDateOfficial = startDate;
                    //                       setState(() {});
                    //                       Navigator.pop(context);
                    //                     }
                    //                     print(object.toString());
                    //                   }
                    //                 },
                    //                 onCancel: () {
                    //                   Navigator.pop(context);
                    //                 },
                    //                 monthCellStyle: DateRangePickerMonthCellStyle(
                    //                     specialDatesDecoration: BoxDecoration(
                    //                         color: Colors.grey,
                    //                         //  border: Border.all(color: const Color(0xFF2B732F), width: 1),
                    //                         shape: BoxShape.circle),
                    //                     specialDatesTextStyle: TextStyle(
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 12,
                    //                         color: Colors.white),
                    //                     todayTextStyle: TextStyle(
                    //                         color: ColorsManager
                    //                             .primaryColor)),
                    //                 onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    //                   if (!roundTrip)
                    //                   {
                    //                     startDate = args.value;
                    //                     print(startDate);
                    //                   }
                    //                   else
                    //                   {
                    //                     if (args.value.startDate != null) {
                    //                       startDate = args.value.startDate;
                    //                     }
                    //                     else
                    //                     {
                    //                       startDate = null;
                    //                     }
                    //                     if (args.value.endDate != null)
                    //                     {
                    //                       endDate = args.value.endDate;
                    //                     }
                    //                     else
                    //                     {
                    //                       endDate = null;
                    //                     }
                    //                   }
                    //                 },
                    //                 monthViewSettings: DateRangePickerMonthViewSettings(specialDates: FlightsCubit.get(context).specialDates),
                    //                 //cellBuilder: cellBuilder,
                    //
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         transition: DelayManager.transitionToHotelDetails,
                    //         duration: Duration(seconds: 1));
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
                    //           Icons.date_range,
                    //           color: ColorsManager.iconColor,
                    //         ),
                    //         SizedBox(
                    //           width: 15,
                    //         ),
                    //         Expanded(
                    //           child: Text(
                    //             roundTrip
                    //                 ? (startDateOfficial == null ||
                    //                 endDateOfficial == null)
                    //                 ? TranslationKeyManager.when.tr
                    //                 : '${DateFormat('dd/MM/yyyy').format(startDateOfficial!)} - ${DateFormat('dd/MM/yyyy').format(endDateOfficial!)}'
                    //                 : startDateOfficial == null
                    //                 ? TranslationKeyManager.when.tr
                    //                 : '${DateFormat('dd/MM/yyyy').format(startDateOfficial!)}',
                    //             maxLines: 1,
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //               color: roundTrip
                    //                   ? (startDateOfficial == null ||
                    //                   endDateOfficial == null)
                    //                   ? ColorsManager.iconColor
                    //                   : Colors.black
                    //                   : startDateOfficial == null
                    //                   ? ColorsManager.iconColor
                    //                   : Colors.black,
                    //               fontSize: 15,
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: ()
                        {
                          Get.to(
                                  () => AdultNumberView2(
                                adults: FlightsCubit.get(context).adults,
                                infants: FlightsCubit.get(context).infants,
                                kids: FlightsCubit.get(context).kids,
                              ),
                              transition: DelayManager.transitionToHotelDetails,
                              duration: Duration(seconds: 1));
                        },
                        child: DefaultField(
                            horizontalPadding: 20,
                            prefix:  Padding(
                              padding: const EdgeInsetsDirectional.only(start: 8.0, end: 13),
                              child: FaIcon(
                                FontAwesomeIcons.users,
                                color: ColorsManager.iconColor,
                                size: 20,
                              ),
                            ),
                            enabled: false,
                            hint: TranslationKeyManager.when.tr,
                            controller: TextEditingController(
                                text:  '${FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids} ${CacheData.lang == CacheHelperKeys.keyEN? 'passengers' : 'مسافر'}',
                            ))),
                    // InkWell(
                    //   onTap: () {
                    //     Get.to(
                    //             () => AdultNumberView2(
                    //           adults: FlightsCubit.get(context).adults,
                    //           infants: FlightsCubit.get(context).infants,
                    //           kids: FlightsCubit.get(context).kids,
                    //         ),
                    //         transition: DelayManager.transitionToHotelDetails,
                    //         duration: Duration(seconds: 1));
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
                    //           Icons.person,
                    //           color: ColorsManager.iconColor,
                    //         ),
                    //         SizedBox(
                    //           width: 15,
                    //         ),
                    //         Expanded(
                    //           child: Text(
                    //             '${FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids} ${CacheData.lang == CacheHelperKeys.keyEN? 'passengers' : 'مسافر'}',
                    //             style: TextStyle(
                    //               color: Colors.black,
                    //               fontSize: 15,
                    //             ),
                    //             maxLines: 1,
                    //             overflow: TextOverflow.ellipsis,
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              if (state is FlightsGetErrorState)
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TranslationKeyManager.sorry.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.withOpacity(0.5),
                                fontSize: 15),
                          ),
                          Text(
                            state.error,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (state is FlightsFilterErrorState)
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TranslationKeyManager.sorry.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.withOpacity(0.5),
                                fontSize: 15),
                          ),
                          Text(
                            TranslationKeyManager.noResult.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      TranslationKeyManager.changeDate.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 16),
                    ),
                  ],
                )
            ]);
      },
    );


  }
  // Widget cellBuilder(BuildContext context, DateRangePickerCellDetails details) {
  //   DateTime _visibleDates = details.date;
  //   if (isSpecialDate(_visibleDates)) {
  //     return Column(
  //       children: [
  //         Container(
  //           child: Text(
  //             details.date.day.toString(),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         Divider(
  //           color: Colors.white,
  //           height: 5,
  //         ),
  //         Icon(
  //           Icons.celebration,
  //           size: 13,
  //           color: Colors.red,
  //         ),
  //       ],
  //     );
  //   } else {
  //     return Container(
  //       child: Text(
  //         details.date.day.toString(),
  //         textAlign: TextAlign.center,
  //       ),
  //     );
  //   }
  // }

  // bool isSpecialDate(DateTime date) {
  //   for (int j = 0; j < _specialDates.length; j++) {
  //     if (date.year == _specialDates[j].year &&
  //         date.month == _specialDates[j].month &&
  //         date.day == _specialDates[j].day) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }
}

class BottomSheetBody extends StatelessWidget {
  BottomSheetBody({super.key,
  required this.isSearch,
  required this.search,
  required this.onTap,
  required this.fromAirport,

  });

  AirportModel? fromAirport;
  bool isSearch;
  final TextEditingController search;
  final void Function(dynamic model) onTap;

  @override
  Widget build(BuildContext context) {
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
            //color: Colors.white,
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )),
          padding: EdgeInsets.symmetric(
              vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultField(
                onChange: (String val) {
                  if (val.isEmpty)
                  {
                    isSearch = false;
                  }
                  else
                  {
                    isSearch = true;
                  }
                  AirportsCubit.get(context).filter(name: val);
                },
                controller: search,
                hint: TranslationKeyManager.search.tr,
                prefix: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: ColorsManager.iconColor,
                      size: 20,
                    )
                ),

              ),
              SizedBox(
                height: 20,
              ),
              BlocConsumer<AirportsCubit, AirportsStates>(
                  listener: (context, state) {},
                  builder: (context, state)
                  {
                    if (state is AirportsGetLoadingState ||
                        state is AirportsFilterLoadingState)
                    {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator()),
                          ],
                        ),
                      );
                    }
                    else if (state is AirportsGetErrorState)
                    {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.error),
                          ],
                        ),
                      );
                    }
                    else if (state is AirportsFilterErrorState)
                    {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.error),
                          ],
                        ),
                      );
                    }
                    else if ((fromAirport == null || search.text.isEmpty) && !isSearch)
                    {
                      return BottomSheetListBuilder(
                          title: TranslationKeyManager.allAirports.tr,
                          models: AirportsCubit.get(context).airportsResponse!.data!,
                          onTap: onTap
                      );
                    }
                    else
                    {
                      return BottomSheetListBuilder(
                        title: TranslationKeyManager.results.tr,
                          models: AirportsCubit.get(context).airPortsFiltered,
                          onTap: onTap
                      );

                    }
                  })
            ],
          ),
        ),
      ],
    );
  }
}

class BottomSheetListBuilder extends StatelessWidget {
  const BottomSheetListBuilder({super.key,
  required this.title,
  required this.models,
  required this.onTap
  });

  final String title;
  final List models;
  final void Function(dynamic model) onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            color: Colors.grey.withOpacity(0.2),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: models.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 7),
                  child: InkWell(
                    onTap: ()
                    {
                      onTap( models[index]);
                    },
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Transform.rotate(
                                angle: pi * 0.2,
                                child: Icon(
                                    Icons
                                        .airplanemode_on_sharp,
                                    size: 20,
                                    color: Colors.grey)),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                CacheData.lang == CacheHelperKeys.keyEN?
                                models[index].englishName!:
                                models[index].arabicName!,
                                style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}


/*
BasicView2(
        appbarTitle: TranslationKeyManager.bottomNavFlight.tr,
        button: (state is FlightsFilterLoadingState)
        ? CircularProgressIndicator()
        : SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: InkWell(
            onTap: ((roundTrip && (startDateOfficial == null || endDateOfficial == null)) ||
                (!roundTrip && startDateOfficial == null)) || (fromAirport ==null || toAirport ==null)
                ? null
                : () {

              FlightsCubit.get(context).filter(
                  from: fromAirport!.id!,
                  to: toAirport!.id!,
                  returnDate: endDateOfficial!,
                  departureDate: startDateOfficial!,
                  allowReturn: roundTrip? 1 : 0,
                  ticketsNumber: FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids
              );
              // FlightsCubit.get(context).filter(
              //     from: '12',
              //     to: '16',
              //     returnDate: "2023-09-14",
              //     departureDate: "2023-09-07",
              //     allowReturn: '1',
              //     ticketsNumber: '12');

            },
            child: Container(
              color: ((roundTrip && (startDateOfficial == null || endDateOfficial == null)) ||
                  (!roundTrip && startDateOfficial == null))|| (fromAirport ==null || toAirport ==null)
                  ? Colors.grey
                  : ColorsManager.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    TranslationKeyManager.searchFlight.tr,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
        children: [
          Container(
            color: ColorsManager.primaryColor,
            child: MyTabBarView(
              length: 2,
              onTab: (index) {
                if (index == 0) {
                  roundTrip = true;
                } else {
                  roundTrip = false;
                }
                setState(() {});
              },
              tabs: [
                TabBarItem(
                    label: TranslationKeyManager.roundTrip.tr.toUpperCase()),
                TabBarItem(
                    label: TranslationKeyManager.oneWay.tr.toUpperCase()),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          BlocConsumer<FlightsCubit, FlightsStates>(
            listener: (context, state) {
              if (state is FlightsFilterSuccessState) {
                Get.to(() => FlightResultsView(
                  roundTrip: roundTrip,
                  fromAirport: fromAirport!,
                  toAirport: toAirport!,
                  startDateOfficial: DateFormat('dd/MM/yyyy').format(startDateOfficial!).toString(),
                  endDateOfficial: roundTrip ? DateFormat('dd/MM/yyyy').format(endDateOfficial!).toString() : null,
                ));
              }
              if (state is FlightsFilterSuccessWithNoDataState) {
                Get.to(() => FlightResultsView(
                  noData: true,
                  roundTrip: roundTrip,
                  fromAirport: fromAirport!,
                  toAirport: toAirport!,
                  startDateOfficial: DateFormat('dd/MM/yyyy').format(startDateOfficial!).toString(),
                  endDateOfficial: roundTrip ? DateFormat('dd/MM/yyyy').format(endDateOfficial!).toString() : null,
                ));
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20, bottom: 20),
                      color: Colors.white,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: ()
                            {
                              if(fromAirport !=null)
                              {
                                search.text =  CacheData.lang == CacheHelperKeys.keyEN? fromAirport!.englishName! :fromAirport!.arabicName!;
                              }
                              else
                                search.text='';
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
                                          TextFormField(
                                            onChanged: (String val) {
                                              if (val.isEmpty)
                                              {
                                                isSearch = false;
                                              }
                                              else
                                              {
                                                isSearch = true;
                                              }
                                              AirportsCubit.get(context).filter(name: val);
                                            },
                                            controller: search,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                            decoration: InputDecoration(
                                                hintText: TranslationKeyManager.search.tr,
                                                filled: true,
                                                fillColor: Colors.black.withOpacity(0.5),
                                                prefixIcon: Icon(
                                                  Icons.location_pin,
                                                  size: 18,
                                                ),
                                                prefixIconColor: Colors.white,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey.withOpacity(0.8),
                                                    fontWeight: FontWeight.w600),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(3),
                                                    borderSide: BorderSide(
                                                        color: Colors.transparent)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(3),
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                    )),
                                                contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 10)),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          BlocConsumer<AirportsCubit, AirportsStates>(
                                              listener: (context, state) {},
                                              builder: (context, state)
                                              {
                                                if (state is AirportsGetLoadingState ||
                                                    state is AirportsFilterLoadingState)
                                                {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: CircularProgressIndicator()),
                                                    ],
                                                  );
                                                }
                                                else if (state is AirportsGetErrorState)
                                                {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(state.error),
                                                    ],
                                                  );
                                                }
                                                else if (state is AirportsFilterErrorState)
                                                {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(state.error),
                                                    ],
                                                  );
                                                }
                                                else if ((fromAirport == null || search.text.isEmpty) && !isSearch)
                                                {
                                                  // show all
                                                  return Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                                          width: double.infinity,
                                                          color: Colors.grey.withOpacity(0.2),
                                                          child: Text(
                                                            TranslationKeyManager.allAirports.tr,
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                              itemCount: AirportsCubit.get(context)
                                                                  .airportsResponse!
                                                                  .data!
                                                                  .length,
                                                              itemBuilder: (context, index) => Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 20.0,vertical: 5),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    fromAirport =
                                                                    AirportsCubit.get(context)
                                                                        .airportsResponse!
                                                                        .data![index];
                                                                    Navigator.pop(context);
                                                                    setState(() {});
                                                                  },
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.center,
                                                                        children: [
                                                                          Transform.rotate(
                                                                              angle: pi * 0.2,
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .airplanemode_on_sharp,
                                                                                  size: 20,
                                                                                  color: Colors.grey)),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text(
                                                                            CacheData.lang == CacheHelperKeys.keyEN?
                                                                            AirportsCubit.get(context).airportsResponse!.data![index].englishName!:
                                                                            AirportsCubit.get(context).airportsResponse!.data![index].arabicName!,
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                color: Colors.black),
                                                                            maxLines: 1,
                                                                            overflow:
                                                                            TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider()
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                else
                                                {
                                                  // show filtered
                                                  return Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                                          width: double.infinity,
                                                          color: Colors.grey.withOpacity(0.2),
                                                          child: Text(
                                                            TranslationKeyManager.results.tr,
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                              itemCount: AirportsCubit.get(context)
                                                                  .airPortsFiltered
                                                                  .length,
                                                              itemBuilder: (context, index) => Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 20.0, vertical: 5),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    fromAirport =
                                                                    AirportsCubit.get(context)
                                                                        .airPortsFiltered[index];
                                                                    Navigator.pop(context);
                                                                    setState(() {});
                                                                  },
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.center,
                                                                        children: [
                                                                          Transform.rotate(
                                                                              angle: pi * 0.2,
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .airplanemode_on_sharp,
                                                                                  size: 20,
                                                                                  color: Colors.grey)),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text(
                                                                            CacheData.lang == CacheHelperKeys.keyEN?
                                                                            AirportsCubit.get(context).airPortsFiltered[index].englishName!:
                                                                            AirportsCubit.get(context).airPortsFiltered[index].arabicName!,
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider()
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
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
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: ColorsManager.iconColor,
                                  )),
                              padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flight_takeoff,
                                    color: ColorsManager.iconColor,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      fromAirport != null?
                                      CacheData.lang == CacheHelperKeys.keyEN ?
                                      fromAirport!.englishName!:
                                      fromAirport!.arabicName! :
                                      TranslationKeyManager.whereFrom.tr,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: fromAirport == null?
                                        Colors.grey:
                                        Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap:()
                            {
                              if(toAirport !=null)
                              {
                                search.text =  CacheData.lang == CacheHelperKeys.keyEN? toAirport!.englishName! :toAirport!.arabicName!;
                              }
                              else
                                search.text='';
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
                                          TextFormField(
                                            onChanged: (String val) {
                                              if (val.isEmpty)
                                              {
                                                isSearch = false;
                                              }
                                              else
                                              {
                                                isSearch = true;
                                              }
                                              AirportsCubit.get(context).filter(name: val);
                                            },
                                            controller: search,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                            decoration: InputDecoration(
                                                hintText: TranslationKeyManager.search.tr,
                                                filled: true,
                                                fillColor: Colors.black.withOpacity(0.5),
                                                prefixIcon: Icon(
                                                  Icons.location_pin,
                                                  size: 18,
                                                ),
                                                prefixIconColor: Colors.white,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey.withOpacity(0.8),
                                                    fontWeight: FontWeight.w600),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(3),
                                                    borderSide: BorderSide(
                                                        color: Colors.transparent)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(3),
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                    )),
                                                contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 10)),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          BlocConsumer<AirportsCubit, AirportsStates>(
                                              listener: (context, state) {},
                                              builder: (context, state)
                                              {
                                                if (state is AirportsGetLoadingState ||
                                                    state is AirportsFilterLoadingState)
                                                {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: CircularProgressIndicator()),
                                                    ],
                                                  );
                                                }
                                                else if (state is AirportsGetErrorState)
                                                {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(state.error),
                                                    ],
                                                  );
                                                }
                                                else if (state is AirportsFilterErrorState)
                                                {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(state.error),
                                                    ],
                                                  );
                                                }
                                                else if ((fromAirport == null || search.text.isEmpty) && !isSearch)
                                                {
                                                  // show all
                                                  return Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                                          width: double.infinity,
                                                          color: Colors.grey.withOpacity(0.2),
                                                          child: Text(
                                                            TranslationKeyManager.allAirports.tr,
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                              itemCount: AirportsCubit.get(context)
                                                                  .airportsResponse!
                                                                  .data!
                                                                  .length,
                                                              itemBuilder: (context, index) => Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 20.0,vertical: 5),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    toAirport =
                                                                    AirportsCubit.get(context)
                                                                        .airportsResponse!
                                                                        .data![index];
                                                                    Navigator.pop(context);
                                                                    setState(() {});
                                                                  },
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.center,
                                                                        children: [
                                                                          Transform.rotate(
                                                                              angle: pi * 0.2,
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .airplanemode_on_sharp,
                                                                                  size: 20,
                                                                                  color: Colors.grey)),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text(
                                                                            CacheData.lang == CacheHelperKeys.keyEN?
                                                                            AirportsCubit.get(context).airportsResponse!.data![index].englishName!:
                                                                            AirportsCubit.get(context).airportsResponse!.data![index].arabicName!,
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                color: Colors.black),
                                                                            maxLines: 1,
                                                                            overflow:
                                                                            TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider()
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                else
                                                {
                                                  // show filtered
                                                  return Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                                          width: double.infinity,
                                                          color: Colors.grey.withOpacity(0.2),
                                                          child: Text(
                                                            TranslationKeyManager.results.tr,
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Expanded(
                                                          child: ListView.builder(
                                                              itemCount: AirportsCubit.get(context)
                                                                  .airPortsFiltered
                                                                  .length,
                                                              itemBuilder: (context, index) => Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 20.0, vertical: 5),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    toAirport =
                                                                    AirportsCubit.get(context)
                                                                        .airPortsFiltered[index];
                                                                    Navigator.pop(context);
                                                                    setState(() {});
                                                                  },
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.center,
                                                                        children: [
                                                                          Transform.rotate(
                                                                              angle: pi * 0.2,
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .airplanemode_on_sharp,
                                                                                  size: 20,
                                                                                  color: Colors.grey)),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text(
                                                                            CacheData.lang == CacheHelperKeys.keyEN?
                                                                            AirportsCubit.get(context).airPortsFiltered[index].englishName!:
                                                                            AirportsCubit.get(context).airPortsFiltered[index].arabicName!,
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Divider()
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
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
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: ColorsManager.iconColor,
                                  )),
                              padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flight_land_outlined,
                                    color: ColorsManager.iconColor,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      toAirport != null?
                                      CacheData.lang == CacheHelperKeys.keyEN ?
                                      toAirport!.englishName!:
                                      toAirport!.arabicName! :
                                      TranslationKeyManager.whereTo.tr,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: toAirport == null?
                                        Colors.grey:
                                        Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              DateTime? startDate;
                              DateTime? endDate;
                              Get.to(
                                      () => Scaffold(
                                    appBar: defaultAppBar(
                                        context: context,
                                        text: TranslationKeyManager.bottomNavFlight.tr
                                    ),
                                    body: SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: SfDateRangePicker(

                                          todayHighlightColor: ColorsManager.primaryColor,
                                          toggleDaySelection: true,
                                          startRangeSelectionColor: ColorsManager.primaryColor,
                                          endRangeSelectionColor: ColorsManager.primaryColor,
                                          rangeSelectionColor: ColorsManager.primaryColor.withOpacity(0.3),
                                          showActionButtons: true,
                                          view: DateRangePickerView.month,
                                          enablePastDates: false,
                                          selectionMode: roundTrip ? DateRangePickerSelectionMode.range : DateRangePickerSelectionMode.single,
                                          showTodayButton: true,
                                          onSubmit: (object) {
                                            if (roundTrip) {
                                              if (startDate == null ||
                                                  endDate == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        TranslationKeyManager
                                                            .dateRange
                                                            .tr)));
                                              } else {
                                                startDateOfficial = startDate;
                                                endDateOfficial = endDate;
                                                setState(() {});
                                                Navigator.pop(context);
                                              }
                                              print(object.toString());
                                            }
                                            else
                                            {
                                              if (startDate == null)
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        TranslationKeyManager
                                                            .dateRange
                                                            .tr)));
                                              } else {
                                                startDateOfficial = startDate;
                                                setState(() {});
                                                Navigator.pop(context);
                                              }
                                              print(object.toString());
                                            }
                                          },
                                          onCancel: () {
                                            Navigator.pop(context);
                                          },
                                          monthCellStyle: DateRangePickerMonthCellStyle(
                                              specialDatesDecoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  //  border: Border.all(color: const Color(0xFF2B732F), width: 1),
                                                  shape: BoxShape.circle),
                                              specialDatesTextStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.white),
                                              todayTextStyle: TextStyle(
                                                  color: ColorsManager
                                                      .primaryColor)),
                                          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                            if (!roundTrip)
                                            {
                                              startDate = args.value;
                                              print(startDate);
                                            }
                                            else
                                            {
                                              if (args.value.startDate != null) {
                                                startDate = args.value.startDate;
                                              }
                                              else
                                              {
                                                startDate = null;
                                              }
                                              if (args.value.endDate != null)
                                              {
                                                endDate = args.value.endDate;
                                              }
                                              else
                                              {
                                                endDate = null;
                                              }
                                            }
                                          },
                                          monthViewSettings: DateRangePickerMonthViewSettings(specialDates: FlightsCubit.get(context).specialDates),
                                          //cellBuilder: cellBuilder,

                                        ),
                                      ),
                                    ),
                                  ),
                                  transition: DelayManager.transitionToHotelDetails,
                                  duration: Duration(seconds: 1));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: ColorsManager.iconColor,
                                  )),
                              padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    color: ColorsManager.iconColor,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      roundTrip
                                          ? (startDateOfficial == null ||
                                          endDateOfficial == null)
                                          ? TranslationKeyManager.when.tr
                                          : '${DateFormat('dd/MM/yyyy').format(startDateOfficial!)} - ${DateFormat('dd/MM/yyyy').format(endDateOfficial!)}'
                                          : startDateOfficial == null
                                          ? TranslationKeyManager.when.tr
                                          : '${DateFormat('dd/MM/yyyy').format(startDateOfficial!)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: roundTrip
                                            ? (startDateOfficial == null ||
                                            endDateOfficial == null)
                                            ? ColorsManager.iconColor
                                            : Colors.black
                                            : startDateOfficial == null
                                            ? ColorsManager.iconColor
                                            : Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(
                                      () => AdultNumberView2(
                                    adults: FlightsCubit.get(context).adults,
                                    infants: FlightsCubit.get(context).infants,
                                    kids: FlightsCubit.get(context).kids,
                                  ),
                                  transition: DelayManager.transitionToHotelDetails,
                                  duration: Duration(seconds: 1));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: ColorsManager.iconColor,
                                  )),
                              padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: ColorsManager.iconColor,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids} ${CacheData.lang == CacheHelperKeys.keyEN? 'passengers' : 'مسافر'}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (state is FlightsFilterLoadingState)
                        ? CircularProgressIndicator()
                        : SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: InkWell(
                          onTap: ((roundTrip && (startDateOfficial == null || endDateOfficial == null)) ||
                              (!roundTrip && startDateOfficial == null)) || (fromAirport ==null || toAirport ==null)
                              ? null
                              : () {

                            FlightsCubit.get(context).filter(
                                from: fromAirport!.id!,
                                to: toAirport!.id!,
                                returnDate: endDateOfficial!,
                                departureDate: startDateOfficial!,
                                allowReturn: roundTrip? 1 : 0,
                                ticketsNumber: FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids
                            );
                            // FlightsCubit.get(context).filter(
                            //     from: '12',
                            //     to: '16',
                            //     returnDate: "2023-09-14",
                            //     departureDate: "2023-09-07",
                            //     allowReturn: '1',
                            //     ticketsNumber: '12');

                          },
                          child: Container(
                            color: ((roundTrip && (startDateOfficial == null || endDateOfficial == null)) ||
                                (!roundTrip && startDateOfficial == null))|| (fromAirport ==null || toAirport ==null)
                                ? Colors.grey
                                : ColorsManager.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  TranslationKeyManager.searchFlight.tr,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (state is FlightsGetErrorState)
                      Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  TranslationKeyManager.sorry.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.withOpacity(0.5),
                                      fontSize: 15),
                                ),
                                Text(
                                  state.error,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (state is FlightsFilterErrorState)
                      Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  TranslationKeyManager.sorry.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.withOpacity(0.5),
                                      fontSize: 15),
                                ),
                                Text(
                                  TranslationKeyManager.noResult.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            TranslationKeyManager.changeDate.tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 16),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          )
        ]
    );
 */
/*
 // show filtered
                      // return Expanded(
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 30),
                      //         width: double.infinity,
                      //         color: Colors.grey.withOpacity(0.2),
                      //         child: Text(
                      //           TranslationKeyManager.results.tr,
                      //           style: TextStyle(
                      //               color: Colors.grey,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 15,
                      //       ),
                      //       Expanded(
                      //         child: ListView.builder(
                      //             itemCount: AirportsCubit.get(context)
                      //                 .airPortsFiltered
                      //                 .length,
                      //             itemBuilder: (context, index) => Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 30.0, vertical: 7),
                      //               child: InkWell(
                      //                 onTap: () {
                      //                   fromAirport =
                      //                   AirportsCubit.get(context)
                      //                       .airPortsFiltered[index];
                      //                   Navigator.pop(context);
                      //                   setState(() {});
                      //                 },
                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //                   children: [
                      //                     Row(
                      //                       mainAxisAlignment:
                      //                       MainAxisAlignment.start,
                      //                       crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                       children: [
                      //                         Transform.rotate(
                      //                             angle: pi * 0.2,
                      //                             child: Icon(
                      //                                 Icons
                      //                                     .airplanemode_on_sharp,
                      //                                 size: 20,
                      //                                 color: Colors.grey)),
                      //                         SizedBox(
                      //                           width: 10,
                      //                         ),
                      //                         Text(
                      //                           CacheData.lang == CacheHelperKeys.keyEN?
                      //                           AirportsCubit.get(context).airPortsFiltered[index].englishName!:
                      //                           AirportsCubit.get(context).airPortsFiltered[index].arabicName!,
                      //                           style: TextStyle(
                      //                               fontWeight:
                      //                               FontWeight.bold,
                      //                               color: Colors.black),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                     Divider()
                      //                   ],
                      //                 ),
                      //               ),
                      //             )),
                      //       ),
                      //     ],
                      //   ),
                      // );
 */

/*
 // show all
                      // return Expanded(
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 30),
                      //         width: double.infinity,
                      //         color: Colors.grey.withOpacity(0.2),
                      //         child: Text(
                      //           TranslationKeyManager.allAirports.tr,
                      //           style: TextStyle(
                      //               color: Colors.grey,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 15,
                      //       ),
                      //       Expanded(
                      //         child: ListView.builder(
                      //             itemCount: AirportsCubit.get(context)
                      //                 .airportsResponse!
                      //                 .data!
                      //                 .length,
                      //             itemBuilder: (context, index) => Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 30.0,vertical: 7),
                      //               child: InkWell(
                      //                 onTap: () {
                      //                   fromAirport =
                      //                   AirportsCubit.get(context)
                      //                       .airportsResponse!
                      //                       .data![index];
                      //                   Navigator.pop(context);
                      //                   setState(() {});
                      //                 },
                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //                   children: [
                      //                     Row(
                      //                       mainAxisAlignment:
                      //                       MainAxisAlignment.start,
                      //                       crossAxisAlignment:
                      //                       CrossAxisAlignment.center,
                      //                       children: [
                      //                         Transform.rotate(
                      //                             angle: pi * 0.2,
                      //                             child: Icon(
                      //                                 Icons
                      //                                     .airplanemode_on_sharp,
                      //                                 size: 20,
                      //                                 color: Colors.grey)),
                      //                         SizedBox(
                      //                           width: 10,
                      //                         ),
                      //                         Text(
                      //                           CacheData.lang == CacheHelperKeys.keyEN?
                      //                           AirportsCubit.get(context).airportsResponse!.data![index].englishName!:
                      //                           AirportsCubit.get(context).airportsResponse!.data![index].arabicName!,
                      //                           style: TextStyle(
                      //                               fontWeight:
                      //                               FontWeight.bold,
                      //                               color: Colors.black),
                      //                           maxLines: 1,
                      //                           overflow:
                      //                           TextOverflow.ellipsis,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                     Divider()
                      //                   ],
                      //                 ),
                      //               ),
                      //             )),
                      //       ),
                      //     ],
                      //   ),
                      // );
 */