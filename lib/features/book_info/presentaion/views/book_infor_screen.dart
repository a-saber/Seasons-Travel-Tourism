import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/defaultrating.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/assets_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/book_info/presentaion/book_info_cubit/book_info_cubit.dart';
import 'package:seasons/features/book_info/presentaion/book_info_cubit/book_info_states.dart';
import 'package:seasons/features/book_info/presentaion/views/widgets/action_icon.dart';
import 'package:seasons/features/book_info/presentaion/views/widgets/book_info_screen_body.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/hotels_list_item.dart';
import 'package:seasons/features/settings/presentation/cubit/info_cubit/info_cubit.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';


class BookInfoScreen extends StatefulWidget {
  const BookInfoScreen({Key? key}) : super(key: key);

  @override
  State<BookInfoScreen> createState() => _BookInfoScreenState();
}

class _BookInfoScreenState extends State<BookInfoScreen> {
  var code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, text: TranslationKeyManager.booksInquiry.tr,),
      body: SingleChildScrollView(
        child: Column(
          children:
          [
            SizedBox(height: 2,),
            Divider(
              color: Colors.amber,
              thickness: 2,
              height: 0,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(TranslationKeyManager.bookSearchCodeBtn.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22
                      ),
                    ),
                  ),
                  SizedBox(height: 60,),
                  DefaultField(
                    hint: 'Code',
                    controller: code,
                    onChange: (String? val){setState((){});},
                  ),
                  SizedBox(height: 40,),
                  InkWell(
                    onTap: code.text.isNotEmpty? (){
                      BookInfoCubit.get(context).getBookInfo(code: code.text);
                    //  callMySnackBar(context: context, text: 'no data');
                    } : null,
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: code.text.isNotEmpty ? ColorsManager.primaryColor:Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          TranslationKeyManager.bookInquiryBtn.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Cairo",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            BlocConsumer<BookInfoCubit, BookInfoStates>(
              builder: (context, state)
              {
                if(state is GetBookLoadingState)
                  return Center(child: CircularProgressIndicator(),);
                else if(state is GetBookErrorState)
                  return Center(child: Text(state.error),);
                else if(state is GetBookSuccessState)
                  return Builder( builder: (context)
                  {
                    if(state.data['bookings'].isNotEmpty) // car
                    {
                      return Column(
                        children:
                        [
                          Text(state.data['bookings'][0]['with_driver']==0?'Without driver': 'With driver'),
                          Text('First name : ${state.data['bookings'][0]['first_name']}'),
                          Text('Last name : ${state.data['bookings'][0]['last_name']}'),
                          Text('Phone number : ${state.data['bookings'][0]['phone_number']}'),
                          Text('Email : ${state.data['bookings'][0]['email']}'),
                          Text('Start date : ${state.data['bookings'][0]['start_date']}'),
                          Text('End date : ${state.data['bookings'][0]['end_date']}'),
                          Text('Total : ${state.data['bookings'][0]['total']}'),
                          Text('Net amount : ${state.data['bookings'][0]['net_amount']}'),
                          Text('Tax : ${state.data['bookings'][0]['tax']}'),
                          Text('Notes : ${state.data['bookings'][0]['notes']}'),
                          Text('Random code : ${state.data['bookings'][0]['random_code']}'),
                          Text('Account owner : ${state.data['bookings'][0]['account_owner']}'),

                        ],
                      );
                    }
                    else if(state.data['bookingss'].isNotEmpty) // flight
                    {
                      return Column(
                        children:
                        [
                          Text(state.data['bookingss'][0]['with_driver']==0?'Without driver': 'With driver'),
                          Text('Flight number : ${state.data['bookingss'][0]['flight_number']}'),
                          Text('First name : ${state.data['bookingss'][0]['first_name']}'),
                          Text('Last name : ${state.data['bookingss'][0]['last_name']}'),
                          Text('Phone number : ${state.data['bookingss'][0]['phone_number']}'),
                          Text('Email : ${state.data['bookingss'][0]['email']}'),
                          Text('Nationality : ${state.data['bookingss'][0]['nationality']}'),
                          Text('Passport number : ${state.data['bookingss'][0]['passport_number']}'),
                          Text('Registration date : ${state.data['bookingss'][0]['registration_date']}'),
                          Text('Total : ${state.data['bookingss'][0]['total']}'),
                          Text('Net total : ${state.data['bookingss'][0]['net_total']}'),
                          Text('Code : ${state.data['bookingss'][0]['booking_id']}'),
                          Text('Account owner : ${state.data['bookingss'][0]['account_owner']}'),
                          Text('Number of adults : ${state.data['bookingss'][0]['number_of_adults']}'),
                          Text('Number of children : ${state.data['bookingss'][0]['number_of_children']}'),
                          Text('Number of infants : ${state.data['bookingss'][0]['number_of_infants']}'),
                          for(int i=0;i<state.data['bookingss'][0]['number_of_adults']-1+state.data['bookingss'][0]['number_of_children']+state.data['bookingss'][0]['number_of_infants'];i++)
                          Text('Person : ${state.data['bookingss'][0]['person${i+2}']}'),


                        ],
                      );
                    }
                    else if(state.data['hotel_reservations'].isNotEmpty) // hotel
                    {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Text('Ordered By : ${state.data['hotel_reservations'][0]['account_name']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                Text('Order date : ${state.data['hotel_reservations'][0]['date_order']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),
                                SizedBox(height: 10,),

                                Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children:
                                        [
                                          CachedNetworkImage(
                                            imageBuilder: (context, provider)=>
                                                Container(height: 150,width: double.infinity,decoration: BoxDecoration(image: DecorationImage(image: provider,fit: BoxFit.cover,),),),
                                            imageUrl:
                                            'https://api.seasonsge.com/${BookInfoCubit.get(context).hotel!.mainImage}',
                                            placeholder: (context, error) =>
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 70.0),
                                                  child: CircularProgressIndicator(),
                                                ),
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) =>
                                                Container(
                                                  height: 150,width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(AssetsManager.hotel),
                                                      fit: BoxFit.cover,),),),
                                          ),
                                          SizedBox(height: 5,),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: AlignmentDirectional.centerStart,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          CacheData.lang == CacheHelperKeys.keyEN ?
                                                          BookInfoCubit.get(context).hotel!.nameEn! :
                                                          BookInfoCubit.get(context).hotel!.nameEn!,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold, fontSize: 15),),
                                                      ),
                                                      DefaultRating(rate: double.parse(state.data['hotel_reservations'][0]['rating']))

                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: AlignmentDirectional.centerStart,
                                                  child: Text(
                                                    CacheData.lang == CacheHelperKeys.keyEN ?
                                                    BookInfoCubit.get(context).hotel!.detailsEn! :
                                                    BookInfoCubit.get(context).hotel!.details!,
                                                    style: TextStyle(color: Colors.grey,
                                                        fontWeight: FontWeight.bold, fontSize: 12),),
                                                ),
                                                Align(
                                                  alignment: AlignmentDirectional.centerStart,
                                                  child: Text(
                                                    'Hotel type : ${BookInfoCubit.get(context).hotel!.hotelType!}' ,
                                                    style: TextStyle(color: ColorsManager.primaryColor,
                                                        fontWeight: FontWeight.bold, fontSize: 12),),
                                                ),
                                                SizedBox(height: 5,),
                                                Align(
                                                  alignment: AlignmentDirectional.centerStart,
                                                  child: Text('${state.data['hotel_reservations'][0]['total']} \$', style: TextStyle(color: Colors.redAccent,
                                                      fontWeight: FontWeight.bold, fontSize: 20
                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text( CacheData.lang == CacheHelperKeys.keyEN ?
                                          '${state.data['hotel_reservations'][0]['number_of_days']} days':
                                          '${state.data['hotel_reservations'][0]['number_of_days']} ايام',
                                            style: TextStyle(color: ColorsManager.primaryColor,
                                                fontWeight: FontWeight.bold, fontSize: 16
                                            ),),
                                          Text(
                                            '${state.data['hotel_reservations'][0]['start_date']} : ${state.data['hotel_reservations'][0]['end_date']}',
                                            style: TextStyle(color: Colors.black,
                                                fontWeight: FontWeight.bold, fontSize: 12
                                            ),),
                                          SizedBox(height: 10,),
                                          Text('Room type : ${state.data['hotel_reservations'][0]['room_type']}',style: TextStyle(color: Colors.grey,
                                              fontWeight: FontWeight.bold, fontSize: 12
                                          )),
                                          Text('Child room type : ${state.data['hotel_reservations'][0]['child_room_type']}',style: TextStyle(color: Colors.grey,
                                              fontWeight: FontWeight.bold, fontSize: 12
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),

                          DefaultField2(enabled: false,hint: TranslationKeyManager.firstName.tr, controller: TextEditingController(text: '${state.data['hotel_reservations'][0]['first_name']}')),
                          SizedBox(height: 10,),
                          DefaultField2(enabled: false,hint: TranslationKeyManager.lastName.tr, controller: TextEditingController(text: '${state.data['hotel_reservations'][0]['last_name']}')),
                          SizedBox(height: 10,),
                          DefaultField2(enabled: false,hint: TranslationKeyManager.phoneNumber.tr, controller: TextEditingController(text: '${state.data['hotel_reservations'][0]['phone']}')),
                          SizedBox(height: 10,),
                          DefaultField2(enabled: false,hint: TranslationKeyManager.email.tr, controller: TextEditingController(text: '${state.data['hotel_reservations'][0]['email']}')),
                          SizedBox(height: 10,),

                        ],
                      );
                    }
                    return SizedBox();
                  });
                else return SizedBox();
              },
              listener: (context, state){}),


          ],
        ),
      ),
    );
    return BasicView2(
      appbarTitle: TranslationKeyManager.booksInquiry.tr,
      buttonText: TranslationKeyManager.bookInquiryBtn.tr,
      onTap: (){callMySnackBar(context: context, text: 'no data');},
      enableCondition: code.text.isNotEmpty,
      children: [

      ],
    );

  }
}

/*
Scaffold(
      appBar: defaultAppBar(
        context: context,
        text: TranslationKeyManager.booksInquiry.tr,
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),

                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors:
                          [
                            ColorsManager.primaryColor,
                            Color(0xff604fb4),
                            Color(0xff604fb4)

                          ])
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0,left:20,bottom: 75),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(TranslationKeyManager.bookSearchCodeBtn.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22
                                  ),
                                ),
                              ),
                              SizedBox(height: 60,),
                              DefaultField(
                                hint: 'Code',
                                controller: code,
                                onChange: (String? val){setState((){});},
                              ),
                              SizedBox(height: 40,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: code.text.isEmpty?null:
                            ()
                        {
                          callMySnackBar(context: context, text: 'no data');
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                              color: code.text.isEmpty?
                              Colors.grey: ColorsManager.primaryColor,
                              gradient: LinearGradient(colors: [ColorsManager.primaryColor, ColorsManager.primaryTwoColor]),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              TranslationKeyManager.bookInquiryBtn.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Cairo",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
 */

/*
 return SafeArea(
      child: Scaffold(
        appBar: defaultAppBar(
            context: context,
            text: TranslationKeyManager.booksInquiry.tr,
        ),
        body: const BookInfoScreenBody(),
      ),
    );
 */