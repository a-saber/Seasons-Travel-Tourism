import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/airports/cubit/airports_cubit.dart';
import 'package:seasons/features/airports/cubit/airports_states.dart';
import 'package:seasons/features/airports/data/models/airport_model.dart';

import '../../../../core/localization/translation_key_manager.dart';
import 'flights_view.dart';

class ChooseDestinationView2 extends StatefulWidget {
  const ChooseDestinationView2({Key? key, required this.fromAirport})
      : super(key: key);

  final AirportModel? fromAirport;
  @override
  State<ChooseDestinationView2> createState() => _ChooseDestinationView2State();
}

class _ChooseDestinationView2State extends State<ChooseDestinationView2> {
  var search = TextEditingController();
  AirportModel? toAirport;
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AirportsCubit, AirportsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  color: ColorsManager.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10.0),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
                              enabled: false,
                              controller: TextEditingController(
                                  text: toAirport == null
                                      ? ''
                                      : CacheData.lang == CacheHelperKeys.keyEN?
                                  toAirport!.englishName!:
                                  toAirport!.arabicName!,
                              ),
                              style: TextStyle(
                                  color: ColorsManager.primaryColor,
                                  fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                  hintText: TranslationKeyManager.whereTo.tr,
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Transform.rotate(
                                      angle: pi * 0.25,
                                      child: Icon(
                                        Icons.airplanemode_active,
                                        size: 18,
                                      )),
                                  prefixIconColor: ColorsManager.formFieldFill,
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
                                  disabledBorder: OutlineInputBorder(
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
                            TextFormField(
                              onChanged: (String val) {
                                if (val.isEmpty) {
                                  isSearch = false;
                                } else {
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //SizedBox(height: 10,),
                // InkWell(
                //   onTap:()
                //   {
                //     fromLocation.text = 'Use Current Location';
                //     setState(() {});
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //     child: Row(
                //       children:
                //       [
                //         Text('Use Current Location', style: TextStyle(
                //             color: ColorsManager.primaryColor,
                //             fontWeight: FontWeight.w600, fontSize: 15),),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),

                Expanded(
                  child: Builder(builder: (context) {
                    if (state is AirportsGetLoadingState || state is AirportsFilterLoadingState)
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
                    else if ((toAirport == null || search.text.isEmpty) && !isSearch)
                    {
                      // show all
                      return Column(
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
                                          horizontal: 20.0),
                                      child: InkWell(
                                        onTap: () {
                                          toAirport = AirportsCubit.get(context)
                                              .airportsResponse!
                                              .data![index];
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
                                                        size: 15,
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
                      );
                    }
                    else
                    {
                      // show filtered
                      return Column(
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
                                          horizontal: 20.0),
                                      child: InkWell(
                                        onTap: () {
                                          toAirport = AirportsCubit.get(context)
                                              .airPortsFiltered[index];
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
                                                        size: 15,
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
                      );
                    }
                  }),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: Colors.white,
                  alignment: AlignmentDirectional.centerEnd,
                  child: InkWell(
                    onTap: (toAirport == null)
                        ? null
                        : () {
                            Get.to(() => FlightsView(
                                // fromAirport: widget.fromAirport!,
                                // toAirport: toAirport!
                            ));
                          },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      color: (toAirport == null)
                          ? Colors.grey
                          : ColorsManager.primaryColor,
                      child: Text(
                        TranslationKeyManager.Continue.tr,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
