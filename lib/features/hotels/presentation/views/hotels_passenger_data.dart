import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:seasons/features/flights/presentation/views/flight_passenger_data.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/home/cubit/home_states.dart';
import 'package:seasons/features/hotels/data/models/hotel_model.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_cubit.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_states.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/hotels_list_item.dart';
import 'package:seasons/features/sign_in/presentaion/views/sign_in_screen.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';


class HotelPassengerData extends StatefulWidget {
  const HotelPassengerData(
      {Key? key, required this.total,required this.net, required this.hotelModel})
      : super(key: key);
  final double total;
  final double net;
  final HotelModel hotelModel;
  @override
  State<HotelPassengerData> createState() => _HotelPassengerDataState();
}
class _HotelPassengerDataState extends State<HotelPassengerData> {
  List<PersonName> adultsNames=[];
  List<PersonName> childrenNames=[];
  List<PersonName> infantsNames=[];
  final formKey = GlobalKey<FormState>();

  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  String? female ;
  @override
  void initState() {
    adultsNames=[];
    infantsNames=[];
    childrenNames=[];
    for(int i=0; i<HotelsCubit.get(context).roomsData.length;i++)
    {
      for(int j=0; j<HotelsCubit.get(context).roomsData[i].adults;j++)
      {
        adultsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
      for(int j=0; j<HotelsCubit.get(context).roomsData[i].infants;j++)
      {
        infantsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
      for(int j=0; j<(HotelsCubit.get(context).roomsData[i].kidsWithNoBed+HotelsCubit.get(context).roomsData[i].kidsWithBed);j++)
      {
        childrenNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HotelsCubit, HotelsStates>(
      listener: (context, state)
      {
        if(state is ViewBookHotelsSuccessState)
        {
          callMySnackBar(context: context, text: state.message);
        }
        if(state is ViewHotelsErrorState)
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
                        child: HotelsListItem2(
                          hotel: widget.hotelModel,
                          total: widget.total,
                        ),
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
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //SizedBox(height: 20,),
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
                                              horizontalPadding: 0,controller: adultsNames[index+1].first, hint: TranslationKeyManager.firstName.tr,)),
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

                      state is ViewBookHotelsLoadingState?
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
                                        HotelsCubit.get(context).bookHotel(
                                          context: context,
                                          hotel: widget.hotelModel,
                                          firstName: firstName.text,
                                          lastName: lastName.text,
                                          email: email.text,
                                          phone: phone.text,
                                          accountName: CacheData.email!,
                                          startDate: DateFormat('dd/MM/yyyy').format(HotelsCubit.get(context).startDate),
                                          endDate: DateFormat('dd/MM/yyyy').format(HotelsCubit.get(context).endDate),
                                          total: widget.total.toString(),
                                          childRoomType: HotelsCubit.get(context).roomsData[0].kidsWithBed>0?'with': 'without',
                                          roomType: HotelsCubit.get(context).roomsData[0].adults==1?'single':HotelsCubit.get(context).roomsData[0].adults==2?'double':'triple',
                                          numberOdDays: '${HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays==0?1:HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays}',
                                          net: widget.net.toString(),
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


class HotelPassengerData2 extends StatefulWidget {
  const HotelPassengerData2(
      {Key? key, required this.total,required this.net, required this.hotelModel,required this.startDateOfficial,required this.endDateOfficial})
      : super(key: key);
  final double total;
  final double net;
  final HotelModel hotelModel;
  final DateTime? startDateOfficial;
  final DateTime? endDateOfficial;
  @override
  State<HotelPassengerData2> createState() => _HotelPassengerData2State();
}
class _HotelPassengerData2State extends State<HotelPassengerData2> {
  List<PersonName> adultsNames=[];
  List<PersonName> childrenNames=[];
  List<PersonName> infantsNames=[];
  final formKey = GlobalKey<FormState>();

  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  String? female ;
  @override
  void initState() {
    adultsNames=[];
    infantsNames=[];
    childrenNames=[];
    for(int i=0; i<HotelsCubit.get(context).roomsDataSearch.length;i++)
    {
      for(int j=0; j<HotelsCubit.get(context).roomsDataSearch[i].adults;j++)
      {
        adultsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
      for(int j=0; j<HotelsCubit.get(context).roomsDataSearch[i].infants;j++)
      {
        infantsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
      for(int j=0; j<(HotelsCubit.get(context).roomsDataSearch[i].kidsWithNoBed+HotelsCubit.get(context).roomsDataSearch[i].kidsWithBed);j++)
      {
        childrenNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
      }
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HotelsCubit, HotelsStates>(
      listener: (context, state)
      {
        if(state is ViewBookHotelsSuccessState)
        {
          callMySnackBar(context: context, text: state.message);
        }
        if(state is ViewHotelsErrorState)
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
                        child: HotelsListItem3(
                          hotel: widget.hotelModel,
                          total: widget.total,
                          endDateOfficial: widget.endDateOfficial,
                          startDateOfficial: widget.startDateOfficial,

                        )
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
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(0)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //SizedBox(height: 20,),
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
                                                horizontalPadding: 0,controller: adultsNames[index+1].first, hint: TranslationKeyManager.firstName.tr,)),
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

                      state is ViewBookHotelsLoadingState?
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
                                        HotelsCubit.get(context).bookHotel(
                                          context: context,
                                          hotel: widget.hotelModel,
                                          firstName: firstName.text,
                                          lastName: lastName.text,
                                          email: email.text,
                                          phone: phone.text,
                                          accountName: CacheData.email!,
                                          startDate: DateFormat('dd/MM/yyyy').format(HotelsCubit.get(context).startDate),
                                          endDate: DateFormat('dd/MM/yyyy').format(HotelsCubit.get(context).endDate),
                                          total: widget.total.toString(),
                                          childRoomType: HotelsCubit.get(context).roomsDataSearch[0].kidsWithBed>0?'with': 'without',
                                          roomType: HotelsCubit.get(context).roomsDataSearch[0].adults==1?'single':HotelsCubit.get(context).roomsDataSearch[0].adults==2?'double':'triple',
                                          numberOdDays: '${HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays==0?1:HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays}',
                                          net: widget.net.toString(),
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