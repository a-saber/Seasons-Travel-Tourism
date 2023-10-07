import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_cubit.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/localization/translation_key_manager.dart';
import '../../../../core/resources_manager/colors_manager.dart';
import 'hotels_passenger_data.dart';

class HotelsSearchDates extends StatefulWidget {
  const HotelsSearchDates({super.key, required this.hotelModel});
  final HotelModel? hotelModel;


  @override
  State<HotelsSearchDates> createState() => _HotelsSearchDatesState();
}

class _HotelsSearchDatesState extends State<HotelsSearchDates> {
  DateTime? startDateOfficial;
  DateTime? endDateOfficial;
  @override
  Widget build(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;
    return Scaffold(
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
                  bool hasSingle = false;
                  bool hasDouble = false;
                  bool hasTriple = false;
                  bool hasChildBed = false;
                  bool hasChildNoBed = false;
                  bool hasInfants = false;
                  int adultsSingle = 0;
                  int adultsDouble = 0;
                  int adultsTriple = 0;
                  int kidsWithBed = 0;
                  int kidsWithNoBed = 0;
                  int infants = 0;

                  for (int i = 0;
                      i < HotelsCubit.get(context).roomsData.length;
                      i++) {
                    print('object');
                    //adultsSingle += ProgramsCubit.get(context).roomsData[i].adults;
                    kidsWithBed +=
                        HotelsCubit.get(context).roomsData[i].kidsWithBed;
                    kidsWithNoBed +=
                        HotelsCubit.get(context).roomsData[i].kidsWithNoBed;
                    infants += HotelsCubit.get(context).roomsData[i].infants;
                    if (HotelsCubit.get(context).roomsData[i].adults == 1) {
                      hasSingle = true;
                      adultsSingle++;
                    } else if (HotelsCubit.get(context).roomsData[i].adults ==
                        2) {
                      hasDouble = true;
                      adultsDouble += 2;
                    } else {
                      adultsTriple += 3;
                      hasTriple = true;
                    }
                    if (HotelsCubit.get(context).roomsData[i].kidsWithBed > 0) {
                      hasChildBed = true;
                    }
                    if (HotelsCubit.get(context).roomsData[i].kidsWithNoBed >
                        0) {
                      hasChildNoBed = true;
                    }
                    if (HotelsCubit.get(context).roomsData[i].infants > 0) {
                      hasInfants = true;
                    }
                  }
                  double net =
                      (adultsSingle * double.parse(widget.hotelModel!.singlePrice!)) +
                          (adultsDouble * double.parse(widget.hotelModel!.doublePrice!)) +
                          (adultsTriple * double.parse(widget.hotelModel!.triplePrice!)) +
                          (kidsWithBed * double.parse(widget.hotelModel!.childWithBedPrice!)) +
                          (kidsWithNoBed * double.parse(widget.hotelModel!.childNoBedPrice!))
                  ;
                  if(endDateOfficial!.difference(startDateOfficial!).inDays!=0)
                    net =  net*endDateOfficial!.difference(startDateOfficial!).inDays;
                  double total = net+ (net*(double.parse(widget.hotelModel!.tax!)/100));
                  Get.to(()=>HotelPassengerData2(
                    total: total,
                    net: net,
                    endDateOfficial: endDateOfficial,
                    startDateOfficial: startDateOfficial,
                    hotelModel: widget.hotelModel!
                  ));
                  //Navigator.pop(context);
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
    );
  }
}
