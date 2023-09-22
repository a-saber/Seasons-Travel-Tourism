import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/app_cubit/app_states.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';

import '../../../../../core/app_cubit/app_cubit.dart';
import '../../../../../core/localization/translation_key_manager.dart';
import 'choose_row.dart';
import 'go_and_back_container.dart';
import 'leaving_date_bottom_sheet.dart';
import 'line_container.dart';
import 'travel_arrive_row.dart';


class TravelBodyContainer extends StatelessWidget {
  const TravelBodyContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
         // height: 435,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black45,
                    blurRadius: .5,
                    blurStyle: BlurStyle.solid,
                    offset: Offset(0, 1))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoAndBackContainer(
                firstText: TranslationKeyManager.oneWay.tr,
                secondText: TranslationKeyManager.goingAndComingBack.tr,
                firstFunction: () {
                  AppCubit.get(context).goBackTapped();
                },
                secondFunction: () {
                  AppCubit.get(context).goBackTapped();
                },
              ),
              TravelArriveRow(
                firstText: TranslationKeyManager.travelFrom.tr,
                secondText: TranslationKeyManager.arriveTo.tr,
                isTravel: true,
                width: 95,
              ),
              const SizedBox(
                height: 10,
              ),
              const ChooseRow(),
              const SizedBox(
                height: 8,
              ),
              const LineContainer(
                isTourism: false,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Text(
                  TranslationKeyManager.departureDate.tr,
                  style: StyleManager.leavingDateTextStyle,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => const LeavingDateBottomSheet());
                    },
                    child:  Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10.0),
                          child: Text(AppCubit.get(context).flightDepartureDate ==null ?'': AppCubit.get(context).flightDepartureDate!),
                        )),
                        //Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 25,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const LineContainer(
                    isTourism: false,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const LineContainer(
                isTourism: false,
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildColumn(
                            text1: TranslationKeyManager.numberOfAdults.tr,
                            text2: TranslationKeyManager.yearsOld12.tr,
                            text3: '1'
                        ),
                        buildColumn(
                            text1: TranslationKeyManager.numberOfChildren2.tr,
                            text2: TranslationKeyManager.years11.tr,
                            text3: '0'
                        ),
                        buildColumn(
                            text1: TranslationKeyManager.numberOfInfantsFrom.tr,
                            text2: TranslationKeyManager.yearsOld02.tr,
                            text3: '0'
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     buildExpanded(text: '1'),
                  //     const SizedBox(
                  //       width: 12,
                  //     ),
                  //     buildExpanded(text: '0'),
                  //     const SizedBox(
                  //       width: 12,
                  //     ),
                  //     buildExpanded(text: '0'),
                  //   ],
                  // )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const LineContainer(
                isTourism: false,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 38,
                  child: MaterialButton(
                    color: Colors.red,
                    elevation: 3,
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        TranslationKeyManager.search.tr,
                        style: StyleManager.searchTextStyle,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildExpanded({required String text}) {
    return Container(
      height: 35,
      margin: const EdgeInsetsDirectional.only(end: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: .8,
          )),
      child: Center(
        child: buildTextField(text),
      ),
    );
  }

  TextField buildTextField(String text) {
    return TextField(
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      controller: TextEditingController(),
      decoration: InputDecoration(

        hintText: text,
        hintStyle: StyleManager.textFieldTextStyle,
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }

  Widget buildColumn(
      {required String text1, required String text2, required String text3}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Column(
              children: [
                Text(
                  '$text1 $text2',
                  style: StyleManager.rowTextStyle,
                ),
                // Text(
                //   text2,
                //   style: StyleManager.rowTextStyle,
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          buildExpanded(text: text3)
        ],
      ),
    );
  }
}
