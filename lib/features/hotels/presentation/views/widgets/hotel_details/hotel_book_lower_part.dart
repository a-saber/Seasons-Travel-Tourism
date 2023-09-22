import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_cubit.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_states.dart';

import '../../../../../../core/core_widgets/default_date_picker.dart';
import '../../../../../../core/core_widgets/default_drop_down.dart';
import '../../../../../../core/core_widgets/default_form_field.dart';
import '../../../../../../core/localization/translation_key_manager.dart';
import '../../../../../../core/resources_manager/style_manager.dart';

class HotelBookLowerPart extends StatefulWidget {
  const HotelBookLowerPart({Key? key, required this.hotel}) : super(key: key);
  final HotelModel hotel;

  @override
  State<HotelBookLowerPart> createState() => _HotelBookLowerPartState();
}

String? roomType;
String? childBook;

class _HotelBookLowerPartState extends State<HotelBookLowerPart> {
  double sumDayPrice = 0.0;
  double sumChildrenBook = 0.0;
  double sumDaysCount = 0.0;
  DateTime? fromDate;
  DateTime? toDate;

  var formKey = GlobalKey<FormState>();
  var name = TextEditingController();
  var rate = TextEditingController();
  var type = TextEditingController();
  var pricePerDay = TextEditingController();
  var childrenBook = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var daysCount = TextEditingController();
  var total = TextEditingController();
  var tax = TextEditingController();
  var net = TextEditingController();

  @override
  void initState() {
    name.text = CacheData.lang == TranslationKeyManager.localeAR.toString()
        ? widget.hotel.name!
        : widget.hotel.nameEn!;
    rate.text = widget.hotel.rating!;
    type.text = widget.hotel.hotelType!;
    tax.text = widget.hotel.tax!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    net.text = daysCount.text.isNotEmpty
        ? (double.parse(daysCount.text) * sumDayPrice).toString()
        : '';
    total.text = net.text.isNotEmpty
        ? (double.parse(net.text) +
                (double.parse(net.text) * double.parse(tax.text) / 100))
            .toString()
        : '';

    return Form(
      key: formKey,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.withOpacity(0.1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TranslationKeyManager.hotelBook.tr,
                style: StyleManager.bookTypeTitle),
            const SizedBox(
              height: 5,
            ),
            Center(
                child: Text(TranslationKeyManager.hotelData.tr,
                    style: StyleManager.bookTypeTitle
                        .copyWith(fontWeight: FontWeight.bold))),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.hotelName.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: name, enabled: false),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.hotelRate.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: rate, enabled: false),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.hotelType.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: type, enabled: false),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.roomChoose.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultDropDown(
                value: roomType,
                onChanged: (value) {
                  if (roomType == null) {
                    if (value == TranslationKeyManager.singleRoom.tr) {
                      sumDayPrice =
                          sumDayPrice + double.parse(widget.hotel.singlePrice!);
                    } else if (value == TranslationKeyManager.doubleRoom.tr) {
                      sumDayPrice =
                          sumDayPrice + double.parse(widget.hotel.doublePrice!);
                    } else {
                      sumDayPrice =
                          sumDayPrice + double.parse(widget.hotel.triplePrice!);
                    }
                  } else {
                    if (roomType == TranslationKeyManager.singleRoom.tr) {
                      sumDayPrice =
                          sumDayPrice - double.parse(widget.hotel.singlePrice!);
                    } else if (roomType ==
                        TranslationKeyManager.doubleRoom.tr) {
                      sumDayPrice =
                          sumDayPrice - double.parse(widget.hotel.doublePrice!);
                    } else {
                      sumDayPrice =
                          sumDayPrice - double.parse(widget.hotel.triplePrice!);
                    }
                    if (value == TranslationKeyManager.singleRoom.tr) {
                      sumDayPrice =
                          sumDayPrice + double.parse(widget.hotel.singlePrice!);
                    } else if (value == TranslationKeyManager.doubleRoom.tr) {
                      sumDayPrice =
                          sumDayPrice + double.parse(widget.hotel.doublePrice!);
                    } else {
                      sumDayPrice =
                          sumDayPrice + double.parse(widget.hotel.triplePrice!);
                    }
                  }
                  setState(() {
                    roomType = value!;
                    pricePerDay.text = sumDayPrice.toString();
                  });
                },
                items: [
                  TranslationKeyManager.singleRoom.tr,
                  TranslationKeyManager.doubleRoom.tr,
                  TranslationKeyManager.tripleRoom.tr
                ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.childBook.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultDropDown(
                value: childBook,
                onChanged: (value) {
                  if (childBook == null) {
                    if (value == TranslationKeyManager.noChild.tr) {
                    } else if (value ==
                        TranslationKeyManager.childWithoutBed.tr) {
                      sumDayPrice = sumDayPrice +
                          double.parse(widget.hotel.childNoBedPrice!);
                      sumChildrenBook = sumChildrenBook +
                          double.parse(widget.hotel.childNoBedPrice!);
                    } else {
                      sumDayPrice = sumDayPrice +
                          double.parse(widget.hotel.childWithBedPrice!);
                      sumChildrenBook = sumChildrenBook +
                          double.parse(widget.hotel.childWithBedPrice!);
                    }
                  } else {
                    if (childBook == TranslationKeyManager.noChild.tr) {
                    } else if (childBook ==
                        TranslationKeyManager.childWithoutBed.tr) {
                      sumDayPrice = sumDayPrice -
                          double.parse(widget.hotel.childNoBedPrice!);
                      sumChildrenBook = sumChildrenBook -
                          double.parse(widget.hotel.childNoBedPrice!);
                    } else {
                      sumDayPrice = sumDayPrice -
                          double.parse(widget.hotel.childWithBedPrice!);
                      sumChildrenBook = sumChildrenBook -
                          double.parse(widget.hotel.childWithBedPrice!);
                    }
                    if (value == TranslationKeyManager.noChild.tr) {
                    } else if (value ==
                        TranslationKeyManager.childWithoutBed.tr) {
                      sumDayPrice = sumDayPrice +
                          double.parse(widget.hotel.childNoBedPrice!);
                      sumChildrenBook = sumChildrenBook +
                          double.parse(widget.hotel.childNoBedPrice!);
                    } else {
                      sumDayPrice = sumDayPrice +
                          double.parse(widget.hotel.childWithBedPrice!);
                      sumChildrenBook = sumChildrenBook +
                          double.parse(widget.hotel.childWithBedPrice!);
                    }
                  }

                  setState(() {
                    childBook = value!;
                    pricePerDay.text = sumDayPrice.toString();
                    childrenBook.text = sumChildrenBook.toString();
                  });
                },
                items: [
                  TranslationKeyManager.noChild.tr,
                  TranslationKeyManager.childWithoutBed.tr,
                  TranslationKeyManager.childWithBed.tr
                ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.roomPricePerDay.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: pricePerDay, enabled: false),
            const SizedBox(
              height: 40,
            ),
            Text(
              TranslationKeyManager.usd.tr,
              style: StyleManager.bookTypeTitle
                  .copyWith(color: ColorsManager.tabBarIndicator),
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.childBook.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: childrenBook, enabled: false),
            const SizedBox(
              height: 40,
            ),
            Text(
              TranslationKeyManager.usd.tr,
              style: StyleManager.bookTypeTitle
                  .copyWith(color: ColorsManager.tabBarIndicator),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.firstName.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(
              controller: firstName,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.lastName.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: lastName),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.phoneNumber.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(
                controller: phone, textInputType: TextInputType.phone),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.email.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(
                controller: email, textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.fromDate.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultDatePicker(
                controller: fromDateController,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2200),
                  ).then((value) {
                    fromDateController.text = value.toString().substring(0, 10);
                    fromDate = value;
                    if (fromDate != null && toDate != null) {
                      print(toDate!.difference(fromDate!).inDays);
                      if (toDate!.difference(fromDate!).inDays >= 0) {
                        daysCount.text =
                            (toDate!.difference(fromDate!).inDays + 1)
                                .toString();
                      } else {
                        //makeToast(context: context, msg: 'make sure that \'to date\' is after \'from date\'', state: ToastStates.ERRORINFO);
                        callMySnackBar(
                            context: context,
                            text:
                                'make sure that \'to date\' is after \'from date\' or equals');
                        daysCount.text = '';
                      }
                    } else {
                      daysCount.text = '';
                    }
                    setState(() {});
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.toDate.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultDatePicker(
                controller: toDateController,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2200),
                  ).then((value) {
                    toDateController.text = value.toString().substring(0, 10);
                    toDate = value;
                    if (fromDate != null && toDate != null) {
                      if (toDate!.difference(fromDate!).inDays >= 0) {
                        daysCount.text =
                            (toDate!.difference(fromDate!).inDays + 1)
                                .toString();
                      } else {
                        //makeToast(context: context, msg: 'make sure that \'to date\' is after \'from date\'', state: ToastStates.ERRORINFO);
                        callMySnackBar(
                            context: context,
                            text:
                                'make sure that \'to date\' is after \'from date\'');
                        daysCount.text = '';
                      }
                    } else {
                      daysCount.text = '';
                    }
                    setState(() {});
                  });
                }),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.daysCount.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: daysCount, enabled: false),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.total.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: total, enabled: false),
            const SizedBox(
              height: 40,
            ),
            Text(
              TranslationKeyManager.usd.tr,
              style: StyleManager.bookTypeTitle
                  .copyWith(color: ColorsManager.tabBarIndicator),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.tax.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: tax, enabled: false),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.net.tr,
                  style: StyleManager.bookAboveInput,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  '*',
                  style: TextStyle(color: ColorsManager.tabBarIndicator),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultFormField(controller: net, enabled: false),
            const SizedBox(
              height: 40,
            ),
            BlocConsumer<HotelsCubit, HotelsStates>(
                builder: (context, state) {
                  if (state is ViewBookHotelsLoadingState)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () {
                          /*
                  single => 1
                  double => 2
                  triple => 3
                  noChild => 1
                  childWithoutBed => 2
                  childWithBed => 3
                  */

                          if (formKey.currentState!.validate()) {
                            String ROOMTYPE;
                            if (roomType! ==
                                TranslationKeyManager.singleRoom.tr) {
                              ROOMTYPE = '1';
                            } else if (roomType! ==
                                TranslationKeyManager.doubleRoom.tr) {
                              ROOMTYPE = '2';
                            } else {
                              ROOMTYPE = '3';
                            }
                            String CHILDTYPE;
                            if (childBook! ==
                                TranslationKeyManager.noChild.tr) {
                              CHILDTYPE = '1';
                            } else if (childBook! ==
                                TranslationKeyManager.childWithoutBed.tr) {
                              CHILDTYPE = '2';
                            } else {
                              CHILDTYPE = '3';
                            }

                            // HotelsCubit.get(context).bookHotel(
                            //     context: context,
                            //     hotel: widget.hotel,
                            //     roomType: ROOMTYPE,
                            //     childRoomType: CHILDTYPE,
                            //     firstName: firstName.text,
                            //     lastName: lastName.text,
                            //     email: email.text,
                            //     phone: phone.text,
                            //     startDate: fromDateController.text,
                            //     endDate: toDateController.text,
                            //     numberOdDays: daysCount.text,
                            //     total: total.text,
                            //     net: net.text);
                          }
                        },
                        color: Colors.black,
                        child: Text(
                          TranslationKeyManager.next.tr,
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    );
                },
                listener: (context, state) {})
          ],
        ),
      ),
    );
  }
}
