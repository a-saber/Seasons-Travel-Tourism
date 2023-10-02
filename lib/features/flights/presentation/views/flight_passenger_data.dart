import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/default_form_field.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';
import 'package:seasons/features/airports/data/models/airport_model.dart';
import 'package:seasons/features/flights/data/models/flight_model.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_cubit.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_states.dart';
import 'package:seasons/features/flights/presentation/views/flights_results_view.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/home/cubit/home_states.dart';
import 'package:seasons/features/home/presentation/views/main_home_view.dart';
import 'package:seasons/features/programs_view/presentation/views/programs_list_view.dart';
import 'package:seasons/features/sign_in/presentaion/views/sign_in_screen.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';
class PersonName
{
  TextEditingController first;
  TextEditingController last;
  String? value ;
  PersonName({required this.first, required this.last, this.value});
}
class FlightPassengerData extends StatefulWidget {
  const FlightPassengerData(
      {Key? key, required this.total, required this.flightModel,
        required this.roundTrip,
        this.noData=false,
        required this.fromAirport,
        required this.toAirport,
        // required this.startDateOfficial,
        // this.endDateOfficial,
      })
      : super(key: key);
  final FlightModel flightModel;
  final String total;
  final bool roundTrip;
  final bool noData;
  final AirportModel fromAirport;
  final AirportModel toAirport;
  // final String startDateOfficial;
  // final String? endDateOfficial;
  @override
  State<FlightPassengerData> createState() => _FlightPassengerDataState();
}

class _FlightPassengerDataState extends State<FlightPassengerData> {
  List<PersonName> adultsNames=[];
  List<PersonName> childrenNames=[];
  List<PersonName> infantsNames=[];
  final formKey = GlobalKey<FormState>();

  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var nationality = TextEditingController();
  var passport_number = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  String? female ;
  @override
  void initState() {
    adultsNames=[];
    infantsNames=[];
    childrenNames=[];
    for(int i=0; i<FlightsCubit.get(context).adults;i++)
    {
      adultsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
    }
    for(int i=0; i<FlightsCubit.get(context).infants;i++)
    {
      infantsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
    }
    for(int i=0; i<FlightsCubit.get(context).kids;i++)
    {
      childrenNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<FlightsCubit, FlightsStates>(
      listener: (context, state)
      {
        if(state is FlightsBookSuccessState)
        {
          callMySnackBar(context: context, text: state.message);
        }
        if(state is FlightsBookErrorState)
        {
          callMySnackBar(context: context, text: state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(context: context, text: TranslationKeyManager.passengers.tr),
          body: BasicView(
            bottomPadding: 20,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Container(
                    //     padding: EdgeInsets.all(10),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(0)
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Expanded(
                    //                 child: Center(
                    //                   child: Text(
                    //                     CacheData.lang == CacheHelperKeys.keyEN?
                    //                     widget.fromAirport.englishName!:
                    //                     widget.fromAirport.arabicName!,
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(fontWeight: FontWeight.bold),
                    //                   ),
                    //                 )),
                    //             Padding(
                    //               padding:
                    //               const EdgeInsets.symmetric(horizontal: 8.0),
                    //               child: widget.roundTrip
                    //                   ? Icon(Icons.compare_arrows_outlined)
                    //                   : Icon(Icons.arrow_right_alt),
                    //             ),
                    //             Expanded(
                    //                 child: Center(
                    //                   child: Text(
                    //                     CacheData.lang == CacheHelperKeys.keyEN?
                    //                     widget.toAirport.englishName!:
                    //                     widget.toAirport.arabicName!,
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(fontWeight: FontWeight.bold),
                    //                   ),
                    //                 )),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: 5,
                    //         ),
                    //         Row(
                    //           children: [
                    //             Text(
                    //               widget.endDateOfficial == null
                    //                   ? widget.startDateOfficial
                    //                   : '${widget.startDateOfficial} - ${widget.endDateOfficial}',
                    //               style: TextStyle(
                    //                   color: Colors.grey,
                    //                   fontWeight: FontWeight.w600),
                    //             ),
                    //             SizedBox(
                    //               width: 10,
                    //             ),
                    //             Icon(
                    //               Icons.person,
                    //               color: Colors.grey,
                    //               size: 17,
                    //             ),
                    //             Text(
                    //                 '${FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids}',
                    //                 style: TextStyle(color: Colors.grey))
                    //           ],
                    //         )
                    //       ],
                    //     )),
                    SizedBox(
                      height: 10,
                    ),
                    FlightBuilder2(
                        flightModel: widget.flightModel,
                        roundTrip: widget.roundTrip,
                        fromAirport: widget.fromAirport,
                        toAirport: widget.toAirport,
                      //   startDateOfficial: widget.startDateOfficial,
                      // endDateOfficial: widget.endDateOfficial,
                    ),
                    SizedBox(
                      height: 10,
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
                                height: 15,
                              ),
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
                              controller: nationality,
                              hint: TranslationKeyManager.nationality.tr),
                          SizedBox(height: 15),
                          DefaultField(
                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                              controller: passport_number,
                              hint: TranslationKeyManager.passportNum.tr,
                              textInputType: TextInputType.number),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    if(adultsNames.length>1 || infantsNames.isNotEmpty||childrenNames.isNotEmpty)
                    Divider(
                      color: Colors.amber,
                      height: 2,
                      thickness: 2,
                    ),
                    if(adultsNames.length>1 || infantsNames.isNotEmpty||childrenNames.isNotEmpty)
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index)=>Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:
                                    [
                                      Row(
                                        children: [
                                          Expanded(child: Text('${CacheData.lang == CacheHelperKeys.keyEN?'Adults':'البالغين'} ${index+2}' )),
                                          Expanded(
                                            child: GenderSwitch(
                                              value: adultsNames[index+1].value,
                                              onChanged: (val){setState(() {adultsNames[index+1].value = val;});},
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Expanded(child: DefaultField(
                                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                                            horizontalPadding: 0,
                                            controller: adultsNames[index+1].first, hint: TranslationKeyManager.firstName.tr,)),
                                          SizedBox(width: 20,),
                                          Expanded(child: DefaultField(
                                            horizontalPadding: 0,
                                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                                            controller: adultsNames[index+1].last, hint: TranslationKeyManager.lastName.tr,)),
                                        ],
                                      )
                                    ],
                                  ),
                                  separatorBuilder: (context, index)=> SizedBox(height: 10,),
                                  itemCount: adultsNames.length-1
                              ),
                            ),

                            SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index)=>Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:
                                    [
                                      Text('${CacheData.lang == CacheHelperKeys.keyEN?'Children':'الاطفال'} ${index+1}' ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Expanded(child: DefaultField(
                                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                                            horizontalPadding: 0,
                                            controller: childrenNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
                                          SizedBox(width: 20,),
                                          Expanded(child: DefaultField(
                                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                                            horizontalPadding: 0,controller: childrenNames[index].last, hint: TranslationKeyManager.lastName.tr,)),
                                        ],
                                      )
                                    ],
                                  ),
                                  separatorBuilder: (context, index)=> SizedBox(height: 10,),
                                  itemCount: childrenNames.length
                              ),
                            ),

                            SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index)=>Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:
                                    [
                                      Text('${CacheData.lang == CacheHelperKeys.keyEN?'Infants':'الرضع'} ${index+1}' ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Expanded(child: DefaultField(
                                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                                            horizontalPadding: 0,controller: infantsNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
                                          SizedBox(width: 20,),
                                          Expanded(child: DefaultField(
                                            fillColor: Theme.of(context).scaffoldBackgroundColor,
                                            horizontalPadding: 0,controller: infantsNames[index].last, hint: TranslationKeyManager.lastName.tr,)),
                                        ],
                                      )
                                    ],
                                  ),
                                  separatorBuilder: (context, index)=> SizedBox(height: 10,),
                                  itemCount: infantsNames.length
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),

                    state is FlightsBookLoadingState?
                    Center(child: CircularProgressIndicator(),):
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
                                  print(female);
                                  if (formKey.currentState!.validate()) {
                                    if(HomeCubit.get(context).login) {
                                      FlightsCubit.get(context).bookFlight(
                                        flight_number: widget.flightModel.flightNumber!,
                                        first_name: firstName.text,
                                        last_name: lastName.text,
                                        email: email.text,
                                        phone: phone.text,
                                        nationality: nationality.text,
                                        passport_number: passport_number.text,
                                        adultsNames: adultsNames,
                                        childrenNames: childrenNames,
                                        infantsNames: infantsNames,
                                      );
                                    }
                                    else
                                    {
                                      callMySnackBar(context: context, text: 'Please Login first');
                                      Get.to(()=>SignInScreen(fromBook: true,));
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


class GenderSwitch extends StatelessWidget {
  GenderSwitch({super.key, required this.value, required this.onChanged});
  String? value;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0, left: 12, bottom: 10),
      child:
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          errorStyle: const TextStyle(
              fontFamily: "Cairo",
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.red),
          //filled: true,
          contentPadding: const EdgeInsetsDirectional.only(start: 10),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 2,
            minHeight: 2,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 2,
            minHeight: 2,
          ),
          hintStyle: StyleManager.hintFormField,
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          focusedErrorBorder:  UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          errorBorder:  UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.red,
              )
          ),
        ),
        value: value,
        hint: Text(
          'Gender',
          style: StyleManager.hintFormField,
        ),
        padding: EdgeInsets.symmetric(horizontal: 2),
        onChanged: onChanged,
        validator: (value) => value == null ? 'field required' : null,
        items:
        ['Mr.', 'Mrs.'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
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


class FlightPassengerData2 extends StatefulWidget {
  const FlightPassengerData2(
      {Key? key, required this.flightModel, required this.adults, required this.kids, required this.infants, })
      : super(key: key);
  final FlightModel flightModel;
  final int adults;
  final int kids;
  final int infants;
  @override
  State<FlightPassengerData2> createState() => _FlightPassengerData2State();
}

class _FlightPassengerData2State extends State<FlightPassengerData2> {
  List<PersonName> adultsNames=[];
  List<PersonName> childrenNames=[];
  List<PersonName> infantsNames=[];
  final formKey = GlobalKey<FormState>();

  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var nationality = TextEditingController();
  var passport_number = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  String? female ;
  @override
  void initState() {
    adultsNames=[];
    infantsNames=[];
    childrenNames=[];
    for(int i=0; i<widget.adults;i++)
    {
      adultsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
    }
    for(int i=0; i<widget.infants;i++)
    {
      infantsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
    }
    for(int i=0; i<widget.kids;i++)
    {
      childrenNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<FlightsCubit, FlightsStates>(
      listener: (context, state)
      {
        if(state is FlightsBookSuccessState)
        {
          callMySnackBar(context: context, text: state.message);
        }
        if(state is FlightsBookErrorState)
        {
          callMySnackBar(context: context, text: state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(context: context, text: TranslationKeyManager.passengers.tr),
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
                      FlightBuilder3(
                        flightModel: widget.flightModel,
                        kids: widget.kids,
                        adults: widget.adults,
                        infants: widget.infants,
                      ),
                      SizedBox(
                        height: 10,
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
                                  height: 15,
                                ),
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
                                controller: nationality,
                                hint: TranslationKeyManager.nationality.tr),
                            SizedBox(height: 15),
                            DefaultField(
                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                controller: passport_number,
                                hint: TranslationKeyManager.passportNum.tr,
                                textInputType: TextInputType.number),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      if(adultsNames.length>1 || infantsNames.isNotEmpty||childrenNames.isNotEmpty)
                        Divider(
                          color: Colors.amber,
                          height: 2,
                          thickness: 2,
                        ),
                      if(adultsNames.length>1 || infantsNames.isNotEmpty||childrenNames.isNotEmpty)
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(0)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index)=>Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:
                                        [
                                          Row(
                                            children: [
                                              Expanded(child: Text('${CacheData.lang == CacheHelperKeys.keyEN?'Adults':'البالغين'} ${index+2}' )),
                                              Expanded(
                                                child: GenderSwitch(
                                                  value: adultsNames[index+1].value,
                                                  onChanged: (val){setState(() {adultsNames[index+1].value = val;});},
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Expanded(child: DefaultField(
                                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                horizontalPadding: 0,
                                                controller: adultsNames[index+1].first, hint: TranslationKeyManager.firstName.tr,)),
                                              SizedBox(width: 20,),
                                              Expanded(child: DefaultField(
                                                horizontalPadding: 0,
                                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                controller: adultsNames[index+1].last, hint: TranslationKeyManager.lastName.tr,)),
                                            ],
                                          )
                                        ],
                                      ),
                                      separatorBuilder: (context, index)=> SizedBox(height: 10,),
                                      itemCount: adultsNames.length-1
                                  ),
                                ),

                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index)=>Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:
                                        [
                                          Text('${CacheData.lang == CacheHelperKeys.keyEN?'Children':'الاطفال'} ${index+1}' ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Expanded(child: DefaultField(
                                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                horizontalPadding: 0,
                                                controller: childrenNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
                                              SizedBox(width: 20,),
                                              Expanded(child: DefaultField(
                                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                horizontalPadding: 0,controller: childrenNames[index].last, hint: TranslationKeyManager.lastName.tr,)),
                                            ],
                                          )
                                        ],
                                      ),
                                      separatorBuilder: (context, index)=> SizedBox(height: 10,),
                                      itemCount: childrenNames.length
                                  ),
                                ),

                                SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index)=>Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:
                                        [
                                          Text('${CacheData.lang == CacheHelperKeys.keyEN?'Infants':'الرضع'} ${index+1}' ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Expanded(child: DefaultField(
                                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                horizontalPadding: 0,controller: infantsNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
                                              SizedBox(width: 20,),
                                              Expanded(child: DefaultField(
                                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                horizontalPadding: 0,controller: infantsNames[index].last, hint: TranslationKeyManager.lastName.tr,)),
                                            ],
                                          )
                                        ],
                                      ),
                                      separatorBuilder: (context, index)=> SizedBox(height: 10,),
                                      itemCount: infantsNames.length
                                  ),
                                )
                              ],
                            )),
                      SizedBox(
                        height: 20,
                      ),

                      state is FlightsBookLoadingState?
                      Center(child: CircularProgressIndicator(),):
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
                                    print(female);
                                    if (formKey.currentState!.validate()) {
                                      if(HomeCubit.get(context).login) {
                                        FlightsCubit.get(context).bookFlight(
                                          flight_number: widget.flightModel.flightNumber!,
                                          first_name: firstName.text,
                                          last_name: lastName.text,
                                          email: email.text,
                                          phone: phone.text,
                                          nationality: nationality.text,
                                          passport_number: passport_number.text,
                                          adultsNames: adultsNames,
                                          childrenNames: childrenNames,
                                          infantsNames: infantsNames,
                                        );
                                      }
                                      else
                                      {
                                        callMySnackBar(context: context, text: 'Please Login first');
                                        Get.to(()=>SignInScreen(fromBook: true,));
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