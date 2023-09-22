import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';

import '../../../../../core/app_cubit/app_cubit.dart';
import '../../../../../core/app_cubit/app_states.dart';
import '../../../../../core/resources_manager/style_manager.dart';
import '../../../../travel/presentation/views/widgets/go_and_back_container.dart';
import '../../../../travel/presentation/views/widgets/leaving_date_bottom_sheet.dart';
import '../../../../travel/presentation/views/widgets/line_container.dart';
import '../../../../travel/presentation/views/widgets/travel_arrive_row.dart';
import 'row_drop_down.dart';
import 'tourism_choose_row.dart';

class TourismContainerBody extends StatefulWidget {
  const TourismContainerBody({Key? key}) : super(key: key);

  @override
  State<TourismContainerBody> createState() => _TourismContainerBodyState();
}

bool tapped = false;

class _TourismContainerBodyState extends State<TourismContainerBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            GoAndBackContainer(
              firstText: TranslationKeyManager.includeFlight.tr,
              secondText: TranslationKeyManager.notIncludeFlight.tr,
              firstFunction: () {
                AppCubit.get(context).goBackTapped();
              },
              secondFunction: () {
                AppCubit.get(context).goBackTapped();
              },
            ),
            TravelArriveRow(
              firstText: TranslationKeyManager.country.tr,
              secondText: TranslationKeyManager.city.tr,
              isTravel: false,
              width: 150,
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            TourismChooseRow(
              rList: AppCubit.get(context).countryList,
              lList: AppCubit.get(context).townList,
            ),
            const SizedBox(
              height: 5,
            ),
            const LineContainer(
              isTourism: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Text(
                TranslationKeyManager.departureDate.tr,
                style: StyleManager.leavingDateTextStyle
                    .copyWith(color: Colors.grey),
              ),
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => const LeavingDateBottomSheet(
                          fromTour: true,
                        ));
              },
              child:  Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10),
                        child: Text(AppCubit.get(context).tourDepartureDate == null? '' :AppCubit.get(context).tourDepartureDate! ),
                      )
                  ),
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
              height: 8,
            ),
            const LineContainer(
              isTourism: true,
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildColumn(
                        text1: TranslationKeyManager.numberOfAdults.tr,
                        text2: TranslationKeyManager.yearsOld12.tr,
                        isTourism: true,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      buildColumn(
                        text1: TranslationKeyManager.numberOfChildren2.tr,
                        text2: TranslationKeyManager.years11.tr,
                        isTourism: true,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      buildColumn(
                        text1: TranslationKeyManager.numberOfInfantsFrom.tr,
                        text2: TranslationKeyManager.yearsOld02.tr,
                        isTourism: true,
                      ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildExpanded(
                      text: '1',
                      isTourism: true,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    buildExpanded(
                      text: '0',
                      isTourism: true,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    buildExpanded(
                      text: '0',
                      isTourism: true,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const LineContainer(
              isTourism: true,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: 200,
              child: MaterialButton(
                color: ColorsManager.yellow,
                elevation: 3,
                onPressed: () {
                  setState(() {
                    tapped = true;
                  });
                },
                child: Center(
                  child: Text(
                    TranslationKeyManager.roomChoose.tr,
                    style: StyleManager.searchTextStyle
                        .copyWith(color: Colors.black, fontSize: 17),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // tapped
            //     ? Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children:
            //           [
            //             Text(
            //              TranslationKeyManager.roomType.tr,
            //               style: StyleManager.textStyle1,
            //             ),
            //             Text(TranslationKeyManager.kidsReservation.tr, style: StyleManager.textStyle1),
            //             Text(TranslationKeyManager.kidsCount.tr, style: StyleManager.textStyle1),
            //           ],
            //         ),
            //       ):
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: tapped
                    ? const Border()
                    : Border.all(
                        color: Colors.grey,
                      ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        TranslationKeyManager.roomType.tr,
                        style: StyleManager.textStyle1,
                      ),
                    ),
                  ),
                  if (!tapped)
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                  Expanded(
                    child: Center(
                      child: Text(TranslationKeyManager.kidsReservation.tr,
                          style: StyleManager.textStyle1),
                    ),
                  ),
                  if (!tapped)
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey,
                    ),
                  Expanded(
                    child: Center(
                      child: Text(TranslationKeyManager.kidsCount.tr,
                          style: StyleManager.textStyle1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            tapped
                ? Stack(
                    children: [
                      Container(
                        height: 40,
                        width: double.infinity,
                        // padding: const EdgeInsets.only(top: 17),
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            ShowBottomSheetTourismBody(
                                              list: [
                                                TranslationKeyManager
                                                    .singleRoom.tr,
                                                TranslationKeyManager
                                                    .doubleRoom.tr,
                                                TranslationKeyManager
                                                    .tripleRoom.tr
                                              ],
                                              isRoomType: true,
                                            ));
                                  },
                                  child: Text(
                                    AppCubit.get(context).roomType==null ?TranslationKeyManager.roomType.tr : AppCubit.get(context).roomType!,
                                    style: StyleManager.textStyle1,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            ShowBottomSheetTourismBody(
                                              list: [
                                                TranslationKeyManager
                                                    .noChild.tr,
                                                TranslationKeyManager
                                                    .childWithoutBed.tr,
                                                TranslationKeyManager
                                                    .childWithBed.tr
                                              ],
                                            ));
                                  },
                                  child: Text(
                                      AppCubit.get(context).kidsReservation==null ?TranslationKeyManager.kidsReservation.tr : AppCubit.get(context).kidsReservation!,
                                      style: StyleManager.textStyle1),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: Center(
                                child: buildTextField(
                                    TranslationKeyManager.kidsCount.tr,
                                    false,
                                    true,
                                    inCenter: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              tapped = false;
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : const SizedBox(),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: SizedBox(
                height: 40,
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
        );
      },
    );
  }

  Expanded buildExpanded({required String text, required bool isTourism}) {
    return Expanded(
      child: isTourism
          ? buildTextField(text, isTourism, false)
          : Container(
              height: 45,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: .8,
                  )),
              child: Center(
                child: buildTextField(text, isTourism, false),
              ),
            ),
    );
  }

  Widget buildTextField(String text, bool isTourism, bool isTapped,
      {bool inCenter = false}) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8.0),
      child: TextField(
        scrollPadding:
            isTapped ? const EdgeInsets.only(top: 15) : EdgeInsets.zero,
        // textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: TextEditingController(),
        textAlign: inCenter ? TextAlign.center : TextAlign.start,
        decoration: InputDecoration(
          contentPadding: inCenter
              ? const EdgeInsetsDirectional.only(bottom: 10)
              : const EdgeInsetsDirectional.only(start: 5),
          hintText: text,
          hintStyle: isTapped
              ? StyleManager.textStyle1
              : StyleManager.textFieldTextStyle,
          border: isTourism
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))
              : InputBorder.none,
          errorBorder: isTourism
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red))
              : InputBorder.none,
          focusedBorder: isTourism
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))
              : InputBorder.none,
          disabledBorder: isTourism
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))
              : InputBorder.none,
        ),
      ),
    );
  }

  Widget buildColumn(
      {required String text1, required String text2, required bool isTourism}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$text1 $text2',
              style: isTourism
                  ? StyleManager.rowTextStyle.copyWith(color: Colors.grey)
                  : StyleManager.rowTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
