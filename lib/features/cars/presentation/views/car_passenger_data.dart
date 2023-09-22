import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/default_form_field.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/cars/data/models/cars_model.dart';
import 'package:seasons/features/cars/presentation/cubit/book_cubit/car_book_cubit.dart';
import 'package:seasons/features/cars/presentation/cubit/book_cubit/car_book_states.dart';
import 'package:seasons/features/flights/presentation/views/flight_passenger_data.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/home/cubit/home_states.dart';
import 'package:seasons/features/sign_in/presentaion/views/sign_in_screen.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'widgets/cars_list_item.dart';


class CarPassengerData extends StatefulWidget {
  const CarPassengerData(
      {Key? key, required this.car})
      : super(key: key);
  final CarsModel car;
  @override
  State<CarPassengerData> createState() => _CarPassengerDataState();
}
class _CarPassengerDataState extends State<CarPassengerData> {
  final formKey = GlobalKey<FormState>();

  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var notesController = TextEditingController();
  String? female ;

  DateTime? from;
  DateTime? to;
  bool withDriver = false;
  double? total;
  double? net;
  @override
  void initState() {
    from = CarBookCubit.get(context).from;
    to = CarBookCubit.get(context).to;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(from!= null && to!=null)
    {
      if(withDriver)
        net = (to!.difference(from!).inDays+1) * double.parse(widget.car.priceWithDriver!);
      else
      {
        net = (to!.difference(from!).inDays+1) * double.parse(widget.car.pricePerDay!);
      }
      total = net! +  (net! * (double.parse(widget.car.tax!)/100));
    }
    return BlocConsumer<CarBookCubit, CarBookStates>(
      listener: (context, state)
      {
        if(state is CarBookCarBookSuccessState)
        {
          callMySnackBar(context: context, text: '${state.carBook!.status}\n${state.carBook!.message}');
        }
        if(state is CarBookCarBookErrorState)
        {
          callMySnackBar(context: context, text: state.error);
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: defaultAppBar(
              context: context, text: TranslationKeyManager.carBook.tr),
          body: BasicView(
              bottomPadding: 20,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CarsListItem(
                          inDetails: true,
                          car: widget.car,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        color: Colors.amber,
                        height: 2,
                        thickness: 2,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0)
                        ),
                        child: Column(
                          children:
                          [
                            Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  //color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(
                                child: Theme(
                                  data: ThemeData(
                                    //useMaterial3: false
                                  ),
                                  child: SwitchListTile(
                                      activeColor: ColorsManager.primaryColor,
                                      inactiveThumbColor: Colors.grey.withOpacity(0.2),
                                      inactiveTrackColor: Colors.grey.withOpacity(0.5),
                                      title: Text(CacheData.lang == CacheHelperKeys.keyEN?'With driver':'مع سائق',style: TextStyle(color: ColorsManager.primaryColor),),
                                      value: withDriver, onChanged: (val){setState(() { withDriver = val;});}),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
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
                                                  from = startDate;
                                                  to = endDate;
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
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                                    horizontalPadding: 10,
                                    prefix:  Padding(
                                      padding: const EdgeInsetsDirectional.only(start: 10.0, end: 15),
                                      child: FaIcon(
                                        FontAwesomeIcons.calendar,
                                        color: ColorsManager.iconColor,
                                        size: 20,
                                      ),
                                    ),
                                    enabled: false,
                                    hint: CacheData.lang == CacheHelperKeys.keyEN ?
                                    'When ?':'متي ؟',
                                    controller: TextEditingController(
                                        text: (from == null || to == null)?
                                        '':
                                        '${DateFormat('dd/MM/yyyy').format(from!)} : ${DateFormat('dd/MM/yyyy').format(to!) }'
                                    ))
                            ),
                            SizedBox(height: 15,),
                            DefaultField(
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                horizontalPadding: 10,
                                prefix:  Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 12.0, end: 18),
                                  child: FaIcon(
                                    FontAwesomeIcons.dollarSign,
                                    color: ColorsManager.iconColor,
                                    size: 20,
                                  ),
                                ),
                                enabled: false,
                                hint: CacheData.lang == CacheHelperKeys.keyEN ?
                                'Total ?':'الاجمالي ؟',
                                controller: TextEditingController(
                                    text: (from != null && to != null)?
                                    CacheData.lang == CacheHelperKeys.keyEN ?
                                    'Total : $total \$':
                                    'الاجمالي : $total \$' +
                                        '${total}':
                                    ''
                                )),
                            SizedBox(height: 5,)

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlocConsumer<HomeCubit, HomeStates>(
                        listener: (context, state) {},
                        builder: (context, state)
                        {
                          if(!HomeCubit.get(context).login)
                            return Column(
                              children: [
                                Divider(
                                  color: Colors.amber,
                                  height: 2,
                                  thickness: 2,
                                ),
                                Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(0)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                TranslationKeyManager.haveAccount.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, height: 1.2),
                                              ),
                                              Text(
                                                TranslationKeyManager.loginFaster.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.2,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          TextButton(
                                              onPressed: ()
                                              {
                                                Get.to(()=>SignInScreen(fromBook: true,));
                                              },
                                              child: Text(
                                                TranslationKeyManager.login.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorsManager.primaryColor),
                                              )),
                                        ],
                                      ),
                                    )
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Divider(
                                //   color: Colors.amber,
                                //   thickness: 1.5,
                                //   height: 0,
                                // ),
                              ],
                            );
                          return SizedBox();
                        },

                      ),


                      Divider(
                        color: Colors.amber,
                        height: 2,
                        thickness: 2,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                child: Text(
                                  TranslationKeyManager.contactDetails.tr,
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 15),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: GenderSwitch(
                                  value: female,
                                  onChanged: (val){setState(() {female = val;});},
                                ),
                              ),
                              DefaultField(
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,

                                  controller: firstName,
                                  hint: TranslationKeyManager.firstName.tr),
                              SizedBox(height: 15),
                              DefaultField(
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,

                                  controller: lastName,
                                  hint: TranslationKeyManager.lastName.tr),
                              SizedBox(height: 15),
                              DefaultField(
                                fillColor: Theme.of(context).scaffoldBackgroundColor,

                                controller: phone,
                                hint: TranslationKeyManager.phoneNumber.tr,
                                textInputType: TextInputType.phone,
                              ),
                              SizedBox(height: 15),
                              DefaultField(
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,

                                  controller: email,
                                  hint: TranslationKeyManager.email.tr,
                                  textInputType: TextInputType.emailAddress),
                              SizedBox(height: 15),
                              DefaultField(
                                  fillColor: Theme.of(context).scaffoldBackgroundColor,

                                  controller: notesController,
                                  hint: TranslationKeyManager.notes.tr,
                                  textInputType: TextInputType.text),
                              SizedBox(height: 15),
                            ],
                          )),
                      state is CarBookCarBookLoadingState?
                      Center(child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: CircularProgressIndicator(),
                      ),):
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20),
                          child: BlocConsumer<HomeCubit, HomeStates>(
                              builder: (context, state)
                              {
                                return MaterialButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if(from == null || to == null)
                                      {}
                                      else{
                                        if(HomeCubit.get(context).login) {
                                          CarBookCubit.get(context).bookCar(
                                            context: context,
                                            fName: firstName.text,
                                            lName: lastName.text,
                                            email: email.text,
                                            phone: phone.text,
                                            endDate: DateFormat('dd/MM/yyyy').format(to!),
                                            startDate: DateFormat('dd/MM/yyyy').format(from!),
                                            tax: widget.car.tax!,
                                            net: net.toString(),
                                            totalAmount: total.toString(),
                                            totalDays: to!.difference(from!).inDays.toString(),
                                            driver: withDriver ? 'with':'without',
                                            notes: notesController.text,
                                            typedId: widget.car.typeId!,
                                          );
                                        }
                                        else
                                        {
                                          callMySnackBar(context: context, text: 'Please Login first');
                                          Get.to(()=>SignInScreen(fromBook: true,));
                                        }
                                      }
                                    }
                                  },
                                  color: ColorsManager.primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      TranslationKeyManager.bookNow.tr,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                );
                              }, listener: (context, state){}),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }
}

class DataFormField extends StatelessWidget {
  const DataFormField(
      {Key? key,
      required this.controller,
      required this.label,
      this.textInputType = TextInputType.text})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return TranslationKeyManager.defValidation.tr;
        }
        return null;
      },
      keyboardType: textInputType,
      controller: controller,
      style: TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
          labelText: label,
          errorStyle: TextStyle(height: 1.2),
          labelStyle: TextStyle(
              color: Colors.grey.withOpacity(0.8), fontWeight: FontWeight.w600),
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(
                color: Colors.grey,
              )),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(
                color: ColorsManager.primaryColor,
              )),
          focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          )),
    );
  }
}
