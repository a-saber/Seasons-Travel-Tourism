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
import 'package:seasons/features/flights/presentation/views/flight_passenger_data.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/home/cubit/home_states.dart';
import 'package:seasons/features/programs_view/data/models/program_model.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_cubit.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_states.dart';
import 'package:seasons/features/sign_in/presentaion/views/sign_in_screen.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';

import 'programs_list_view.dart';

class ProgramPassengerData extends StatefulWidget {
  const ProgramPassengerData(
      {Key? key, required this.total, required this.programModel})
      : super(key: key);
  final String total;
  final ProgramModel programModel;
  @override
  State<ProgramPassengerData> createState() => _ProgramPassengerDataState();
}
class _ProgramPassengerDataState extends State<ProgramPassengerData> {
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
    for(int i=0; i<ProgramsCubit.get(context).roomsData.length;i++)
    {
      for(int j=0; j<ProgramsCubit.get(context).roomsData[i].adults;j++)
      {
        adultsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
      for(int j=0; j<ProgramsCubit.get(context).roomsData[i].infants;j++)
      {
        infantsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
      for(int j=0; j<(ProgramsCubit.get(context).roomsData[i].kidsWithNoBed+ProgramsCubit.get(context).roomsData[i].kidsWithBed);j++)
      {
        childrenNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ProgramsCubit, ProgramsStates>(
      listener: (context, state)
      {
        if(state is ProgramsBookSuccessState)
        {
          callMySnackBar(context: context, text: state.message);
        }
        if(state is ProgramsBookErrorState)
        {
          callMySnackBar(context: context, text: state.error);
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: defaultAppBar(
              context: context, text: TranslationKeyManager.passengers.tr),
          body: BasicView(
              bottomPadding: 20,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ProgramBuilder(programModel: widget.programModel),
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
                          )),
                      SizedBox(height: 10,),
                      if(adultsNames.length>1||infantsNames.isNotEmpty||childrenNames.isNotEmpty)
                        Divider(
                          color: Colors.amber,
                          height: 2,
                          thickness: 2,
                        ),
                      if(adultsNames.length>1||infantsNames.isNotEmpty||childrenNames.isNotEmpty)
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
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
                                            Expanded(
                                                child: DefaultField(
                                                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                  horizontalPadding: 0,
                                                  controller: adultsNames[index+1].first,
                                                  hint: TranslationKeyManager.firstName.tr,)),
                                            SizedBox(width: 20,),
                                            Expanded(child: DefaultField(
                                              fillColor: Theme.of(context).scaffoldBackgroundColor,
                                              horizontalPadding: 0,controller: adultsNames[index+1].last, hint: TranslationKeyManager.lastName.tr,)),
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
                                              horizontalPadding: 0,controller: childrenNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
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

                      state is ProgramsBookLoadingState?
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
                                      if(HomeCubit.get(context).login) {
                                        ProgramsCubit.get(context).programBook(
                                          programModel: widget.programModel,
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


class ProgramPassengerData2 extends StatefulWidget {
  const ProgramPassengerData2(
      {Key? key, required this.programModel,  })
      : super(key: key);
  final ProgramModel programModel;
  @override
  State<ProgramPassengerData2> createState() => _ProgramPassengerData2State();
}
class _ProgramPassengerData2State extends State<ProgramPassengerData2> {
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
    for(int i=0; i<ProgramsCubit.get(context).roomsDataSearch.length;i++)
    {
      for(int j=0; j<ProgramsCubit.get(context).roomsDataSearch[i].adults;j++)
      {
        adultsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
      for(int j=0; j<ProgramsCubit.get(context).roomsDataSearch[i].infants;j++)
      {
        infantsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
      for(int j=0; j<(ProgramsCubit.get(context).roomsDataSearch[i].kidsWithNoBed+ProgramsCubit.get(context).roomsDataSearch[i].kidsWithBed);j++)
      {
        childrenNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ProgramsCubit, ProgramsStates>(
      listener: (context, state)
      {
        if(state is ProgramsBookSuccessState)
        {
          callMySnackBar(context: context, text: state.message);
        }
        if(state is ProgramsBookErrorState)
        {
          callMySnackBar(context: context, text: state.error);
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: defaultAppBar(
              context: context, text: TranslationKeyManager.passengers.tr),
          body: BasicView(
              bottomPadding: 20,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ProgramBuilder2(programModel: widget.programModel),
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
                          )),
                      SizedBox(height: 10,),
                      if(adultsNames.length>1||infantsNames.isNotEmpty||childrenNames.isNotEmpty)
                        Divider(
                          color: Colors.amber,
                          height: 2,
                          thickness: 2,
                        ),
                      if(adultsNames.length>1||infantsNames.isNotEmpty||childrenNames.isNotEmpty)
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 0),
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
                                              Expanded(
                                                  child: DefaultField(
                                                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                    horizontalPadding: 0,
                                                    controller: adultsNames[index+1].first,
                                                    hint: TranslationKeyManager.firstName.tr,)),
                                              SizedBox(width: 20,),
                                              Expanded(child: DefaultField(
                                                fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                horizontalPadding: 0,controller: adultsNames[index+1].last, hint: TranslationKeyManager.lastName.tr,)),
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
                                                horizontalPadding: 0,controller: childrenNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
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

                      state is ProgramsBookLoadingState?
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
                                      if(HomeCubit.get(context).login) {
                                        ProgramsCubit.get(context).programBook(
                                          programModel: widget.programModel,
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
