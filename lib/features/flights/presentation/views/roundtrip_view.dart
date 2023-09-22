import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/delay_manager.dart';
import 'package:seasons/features/airports/data/models/airport_model.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_cubit.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_states.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/localization/translation_key_manager.dart';
import '../../../flights/presentation/views/flights_results_view.dart';
import 'adult_number_view2.dart';

class RoundTripView extends StatefulWidget {
  const RoundTripView(
      {Key? key,
      required this.roundTrip,
        required this.scaffoldKey,
      // required this.fromAirport,
      // required this.toAirport
      })
      : super(key: key);
  final bool roundTrip;
  // final AirportModel fromAirport;
  // final AirportModel toAirport;
  final GlobalKey scaffoldKey;


  @override
  State<RoundTripView> createState() => _RoundTripViewState();
}

class _RoundTripViewState extends State<RoundTripView> {
  String? startDateOfficial;
  String? endDateOfficial;
 AirportModel? fromAirport;
   AirportModel? toAirport;
  bool direct = true;

  List<int> kidsAges = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlightsCubit, FlightsStates>(
      listener: (context, state) {
        if (state is FlightsFilterSuccessState) {
          Get.to(() => FlightResultsView(
                roundTrip: widget.roundTrip,
                fromAirport: fromAirport!,
                toAirport: toAirport!,
                startDateOfficial: startDateOfficial!,
                endDateOfficial: widget.roundTrip ? endDateOfficial! : null,
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
                    Container(
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
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        String? startDate;
                        String? endDate;
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
                                          selectionMode: widget.roundTrip
                                              ? DateRangePickerSelectionMode
                                                  .range
                                              : DateRangePickerSelectionMode
                                                  .single,
                                          showTodayButton: true,
                                          onSubmit: (object) {
                                            if (widget.roundTrip) {
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
                                          monthCellStyle:
                                              DateRangePickerMonthCellStyle(
                                                  todayTextStyle: TextStyle(
                                                      color: ColorsManager
                                                          .primaryColor)),
                                          onSelectionChanged:
                                              (DateRangePickerSelectionChangedArgs
                                                  args) {
                                            if (!widget.roundTrip) {
                                              startDate =
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(args.value);
                                              print(startDate);
                                            } else {
                                              if (args.value.startDate !=
                                                  null) {
                                                startDate = DateFormat(
                                                        'dd/MM/yyyy')
                                                    .format(
                                                        args.value.startDate);
                                              } else {
                                                startDate = null;
                                              }
                                              if (args.value.endDate != null) {
                                                endDate = DateFormat(
                                                        'dd/MM/yyyy')
                                                    .format(args.value.endDate);
                                              } else {
                                                endDate = null;
                                              }
                                            }
                                          }),
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
                                widget.roundTrip
                                    ? (startDateOfficial == null ||
                                            endDateOfficial == null)
                                        ? TranslationKeyManager.when.tr
                                        : '$startDateOfficial - $endDateOfficial'
                                    : startDateOfficial == null
                                        ? TranslationKeyManager.when.tr
                                        : '$startDateOfficial',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: widget.roundTrip
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
              (state is FlightsGetLoadingState ||
                      state is FlightsGetSuccessState ||
                      state is FlightsFilterLoadingState)
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: InkWell(
                          onTap: ((widget.roundTrip &&
                                      (startDateOfficial == null ||
                                          endDateOfficial == null)) ||
                                  (!widget.roundTrip &&
                                      startDateOfficial == null))
                              ? null
                              : () {
                                  // FlightsCubit.get(context)
                                  //     .getFlights()
                                  //     .then((value) {
                                    // FlightsCubit.get(context).filter(
                                    //     from: widget.fromAirport.id!,
                                    //     to: widget.toAirport.id!,
                                    //     startDate: startDateOfficial!,
                                    //     departureDate: endDateOfficial!,
                                    //     allowReturn: '1',
                                    //     ticketsNumber: '${FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids}'
                                    // );
                                    // FlightsCubit.get(context).filter(
                                    //     from: '12',
                                    //     to: '12',
                                    //     returnDate: "2023-07-20",
                                    //     departureDate: "2023-07-20",
                                    //     allowReturn: '1',
                                    //     ticketsNumber: '22');
                                  //});
                                },
                          child: Container(
                            color: ((widget.roundTrip &&
                                        (startDateOfficial == null ||
                                            endDateOfficial == null)) ||
                                    (!widget.roundTrip &&
                                        startDateOfficial == null))
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
    );
  }
}
/*
                    SwitchListTile(
                      title: Text(
                        TranslationKeyManager.onlyFlight.tr,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      value: direct,
                      onChanged: (val) => setState(() {
                        direct = val;
                      }),
                      activeColor: ColorsManager.primaryColor,
                    ),

 */
/*
                  // Get.to(
                  //     () => Scaffold(
                  //           appBar:
                  //               defaultAppBar(context: context, text: 'Flight'),
                  //           body: SafeArea(
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(20.0),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     'Where from ?',
                  //                     style: TextStyle(
                  //                         color: ColorsManager.iconColor,
                  //                         fontSize: 20),
                  //                   ),
                  //                   SizedBox(
                  //                     height: 20,
                  //                   ),
                  //                   TextFormField(
                  //                     controller: whereFrom,
                  //                     decoration: InputDecoration(
                  //                         suffixIcon: IconButton(
                  //                             onPressed: () {
                  //                               whereFrom.text = '';
                  //                             },
                  //                             icon: Icon(Icons.cancel)),
                  //                         enabledBorder: UnderlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(3),
                  //                             borderSide: BorderSide(
                  //                               color: ColorsManager.iconColor,
                  //                             )),
                  //                         focusedBorder: UnderlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(3),
                  //                             borderSide: BorderSide(
                  //                               color:
                  //                                   ColorsManager.primaryColor,
                  //                             )),
                  //                         contentPadding:
                  //                             const EdgeInsets.symmetric(
                  //                                 horizontal: 10,
                  //                                 vertical: 10)),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //     transition: Transition.downToUp,
                  //     duration: Duration(seconds: 1));

 */

/*
   // Get.to(
                  //     () => Scaffold(
                  //           appBar: defaultAppBar(
                  //               context: context, text: 'Flight '),
                  //           body: SafeArea(
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(20.0),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     'Where are you headed ?',
                  //                     style: TextStyle(
                  //                         color: ColorsManager.iconColor,
                  //                         fontSize: 20),
                  //                   ),
                  //                   SizedBox(
                  //                     height: 20,
                  //                   ),
                  //                   TextFormField(
                  //                     controller: whereTo,
                  //                     decoration: InputDecoration(
                  //                         suffixIcon: IconButton(
                  //                             onPressed: () {
                  //                               whereTo.text = '';
                  //                             },
                  //                             icon: Icon(Icons.cancel)),
                  //                         enabledBorder: UnderlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(3),
                  //                             borderSide: BorderSide(
                  //                               color: ColorsManager.iconColor,
                  //                             )),
                  //                         focusedBorder: UnderlineInputBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(3),
                  //                             borderSide: BorderSide(
                  //                               color:
                  //                                   ColorsManager.primaryColor,
                  //                             )),
                  //                         contentPadding:
                  //                             const EdgeInsets.symmetric(
                  //                                 horizontal: 10,
                  //                                 vertical: 10)),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //     transition: Transition.downToUp,
                  //     duration: Duration(seconds: 1));
 */
