import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_drop_down.dart';
import 'package:seasons/core/core_widgets/default_form_field.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';
import 'package:seasons/features/cars/data/models/cars_model.dart';
import 'package:seasons/features/cars/presentation/cubit/book_cubit/car_book_cubit.dart';
import 'package:seasons/features/cars/presentation/cubit/book_cubit/car_book_states.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_cubit.dart';

import '../../../../../core/local_database/cache_data.dart';

class CarBookLowerPart extends StatefulWidget {
  const CarBookLowerPart({Key? key, required this.bookCar}) : super(key: key);
  final CarsModel bookCar;

  @override
  State<CarBookLowerPart> createState() => _CarBookLowerPartState();
}

String? withDriverValue;
var carTypeController = TextEditingController();
var pricePerDayController = TextEditingController();
var firstNameController = TextEditingController();
var lastNameController = TextEditingController();
var phoneNumberController = TextEditingController();
var emailController = TextEditingController();
var fromDateController = TextEditingController();
var toDateController = TextEditingController();
var daysCountController = TextEditingController();
var totalController = TextEditingController();
var taxController = TextEditingController();
var netController = TextEditingController();
var notesController = TextEditingController();
DateTime? from;
DateTime? to;

class _CarBookLowerPartState extends State<CarBookLowerPart> {
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    carTypeController.text = CarsCubit.get(context).getCarTypeModel(widget.bookCar.typeId!, context).nameEn!;
    pricePerDayController.text = widget.bookCar.pricePerDay!;
    taxController.text = widget.bookCar.tax!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            Text(TranslationKeyManager.carBook.tr,
                style: StyleManager.bookTypeTitle),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.carType.tr,
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
              controller: carTypeController,
              enabled: false,
              hint: CacheData.lang == TranslationKeyManager.localeAR.toString()
                  ? CarsCubit.get(context)
                      .getCarTypeModel(widget.bookCar.typeId!, context)
                      .name!
                  : CarsCubit.get(context)
                      .getCarTypeModel(widget.bookCar.typeId!, context)
                      .nameEn!,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.withDriverQues.tr,
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
                value: withDriverValue,
                onChanged: (value) {
                  setState(() {
                    withDriverValue = value!;
                  });
                },
                items: [
                  TranslationKeyManager.withDriver.tr,
                  TranslationKeyManager.withoutDriver.tr
                ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.pricePerDay.tr,
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
              controller: pricePerDayController,
              enabled: false,
              hint: widget.bookCar.pricePerDay!,
            ),
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
            DefaultFormField(controller: firstNameController),
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
            DefaultFormField(controller: lastNameController),
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
                controller: phoneNumberController,
                textInputType: TextInputType.phone),
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
                controller: emailController,
                textInputType: TextInputType.emailAddress),
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
            DefaultFormField(
              controller: fromDateController,
              textInputType: TextInputType.datetime,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                ).then((value) {
                  from = value;
                  fromDateController.text = value.toString().substring(0, 10);
                  print("************************");
                  print(fromDateController.text);
                });
                print("************************");
                print(fromDateController.text);
              },
              hint: '',
            ),

            // DefaultDatePicker(controller: firstNameController),
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
            DefaultFormField(
              controller: toDateController,
              textInputType: TextInputType.datetime,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                ).then((value) {
                  to = value;
                  toDateController.text = value.toString().substring(0, 10);
                  if (to!.difference(from!).inDays >= 0) {
                    daysCountController.text =
                        (to!.difference(from!).inDays + 1).toString();
                    totalController.text =
                        (to!.difference(from!).inDays + 1).toString();
                    netController.text =
                        (int.tryParse(widget.bookCar.pricePerDay!) ??
                                0 * (to!.difference(from!).inDays + 1))
                            .toString();
                  }
                  print("************************");
                  print(toDateController.text);
                });
                print("************************");
                print(toDateController.text);
              },
              hint: '',
            ),
            //DefaultDatePicker(controller: toDateController),
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
            DefaultFormField(
              controller: daysCountController,
              enabled: false,
              hint: to != null && from != null
                  ? (to!.difference(from!).inDays + 1).toString()
                  : '',
            ),
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
            DefaultFormField(
              controller: totalController,
              enabled: false,
              hint: to != null && from != null
                  ? (to!.difference(from!).inDays + 1).toString()
                  : '',
            ),
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
            DefaultFormField(
              controller: taxController,
              enabled: false,
              hint: widget.bookCar.tax!,
            ),
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
            DefaultFormField(
              controller: netController,
              enabled: false,
              // int.tryParse(text) ?? defaultValue
              hint: to != null && from != null
                  ? (int.tryParse(widget.bookCar.pricePerDay!) ??
                          0 * (to!.difference(from!).inDays + 1))
                      .toString()
                  : '',
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  TranslationKeyManager.notes.tr,
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
              hint: TranslationKeyManager.notesHint.tr,
              controller: notesController,
              maxLines: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<CarBookCubit, CarBookStates>(
              builder: (context, state) {
                return state is CarBookCarBookLoadingState
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.black54,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              CarBookCubit.get(context).bookCar(
                                context: context,
                                typedId: carTypeController.text,
                                driver: withDriverValue!,
                                fName: firstNameController.text,
                                lName: lastNameController.text,
                                phone: phoneNumberController.text,
                                startDate: fromDateController.text,
                                endDate: toDateController.text,
                                email: emailController.text,
                                totalDays: daysCountController.text,
                                totalAmount: totalController.text,
                                tax: taxController.text,
                                net: netController.text,
                                notes: notesController.text,
                              );
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
            )
          ],
        ),
      ),
    );
  }
}
