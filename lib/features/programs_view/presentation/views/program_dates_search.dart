import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/features/programs_view/data/models/program_model.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_cubit.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/localization/translation_key_manager.dart';
import '../../../../core/resources_manager/colors_manager.dart';
import 'programs_passenger_data.dart';

class ProgramSearchDates extends StatefulWidget {
  const ProgramSearchDates({super.key, required this.programModel});
  final ProgramModel? programModel;


  @override
  State<ProgramSearchDates> createState() => _ProgramSearchDatesState();
}

class _ProgramSearchDatesState extends State<ProgramSearchDates> {
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
                  int adultsSingle=0;
                  int adultsDouble=0;
                  int adultsTriple=0;
                  int kidsWithBed=0;
                  int kidsWithNoBed=0;
                  int infants=0;
                  for(int i=0; i<ProgramsCubit.get(context).roomsDataSearch.length;i++)
                  {
                  print('object');
                  //adultsSingle += ProgramsCubit.get(context).roomsData[i].adults;
                  kidsWithBed += ProgramsCubit.get(context).roomsDataSearch[i].kidsWithBed;
                  kidsWithNoBed += ProgramsCubit.get(context).roomsDataSearch[i].kidsWithNoBed;
                  infants += ProgramsCubit.get(context).roomsDataSearch[i].infants;
                  if(ProgramsCubit.get(context).roomsDataSearch[i].adults==1)
                  {
                  hasSingle = true;
                  adultsSingle++;
                  }
                  else if(ProgramsCubit.get(context).roomsDataSearch[i].adults==2)
                  {
                  hasDouble = true;
                  adultsDouble+=2;
                  }
                  else
                  {
                  adultsTriple+=3;
                  hasTriple = true;
                  }
                  if(ProgramsCubit.get(context).roomsDataSearch[i].kidsWithBed >0)
                  {
                  hasChildBed = true;
                  }
                  if(ProgramsCubit.get(context).roomsDataSearch[i].kidsWithNoBed >0)
                  {
                  hasChildNoBed = true;
                  }
                  if(ProgramsCubit.get(context).roomsDataSearch[i].infants >0)
                  {
                  hasInfants = true;
                  }
                  }

                  print(adultsSingle);
                  print(adultsDouble);
                  print(adultsTriple);

                  double net = (infants * double.parse(widget.programModel!.pricePerInfant!))+
                      (adultsSingle * double.parse(widget.programModel!.pricePerAdultIndividual!)) +
                      (adultsDouble * double.parse(widget.programModel!.pricePerAdultDouble!)) +
                      (adultsTriple * double.parse(widget.programModel!.pricePerAdultTriple!)) +
                      (kidsWithBed * double.parse(widget.programModel!.pricePerChildWithBed!)) +
                      (kidsWithNoBed * double.parse(widget.programModel!.pricePerChildNoBed!))
                  ;
                  double total = net+ (net*(double.parse(widget.programModel!.tax!)/100));

                  Get.to(()=>ProgramPassengerData2(
                    programModel: widget.programModel!
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
