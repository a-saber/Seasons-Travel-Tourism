import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/my_tab_bar_view.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/assets_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/delay_manager.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/tab_bar_item.dart';
import 'package:seasons/features/programs_view/data/models/program_model.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_cubit.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_states.dart';
import 'package:seasons/features/programs_view/presentation/views/programs_passenger_data.dart';

class ProgramsListView extends StatefulWidget {
  const ProgramsListView({Key? key, required this.noDataMatch}) : super(key: key);

  final bool noDataMatch;
  @override
  State<ProgramsListView> createState() => _ProgramsListViewState();
}

class _ProgramsListViewState extends State<ProgramsListView> {
  bool showAll = false;
  @override
  void initState() {
    if( widget.noDataMatch )
      showAll = true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, text: TranslationKeyManager.tourismTitle.tr, elevation: 0),
      body: SafeArea(
        child: BasicView3(
            child: Column(
              children:
              [
                if(widget.noDataMatch)
                SizedBox(height: 10,),
                !widget.noDataMatch?
                Container(
                  color: ColorsManager.primaryColor,
                  child: MyTabBarView(
                    length: 2,
                    onTab: (index) {
                      if (index == 0) {
                        showAll = false;
                      } else {
                        showAll = true;
                      }
                      setState(() {});
                    },
                    tabs: [
                      TabBarItem(
                          label: CacheData.lang == CacheHelperKeys.keyEN?'Results':'النتائج'.toUpperCase()),
                      TabBarItem(
                          label:CacheData.lang == CacheHelperKeys.keyEN? 'Show All':'اعرض الكل'.toUpperCase()),
                    ],
                  ),
                ):
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.infoCircle, color: Colors.grey.withOpacity(0.5),),
                            SizedBox(width: 20,),
                            Expanded(child: Text(TranslationKeyManager.noResult.tr,style: TextStyle(color: Colors.grey,fontSize: 13,fontWeight: FontWeight.w600),)),
                          ],
                        ),
                      ),
                      Text(
                          '${CacheData.lang == CacheHelperKeys.keyEN?'all results':'كل النتائج'}'
                              .toUpperCase(),
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 13,
                              color: ColorsManager.primaryColor,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                SizedBox(height: 20,),

                showAll?
                BlocConsumer<ProgramsCubit, ProgramsStates>(
                    listener:(context, index){},
                    builder: (context, index)
                    {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView.builder(
                              itemCount: ProgramsCubit.get(context).programs.length,
                              itemBuilder: (context, index)=>
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: ProgramBuilder(programModel: ProgramsCubit.get(context).programs[index]),
                                  )
                          ),
                        ),
                      );
                    }
                ):
                BlocConsumer<ProgramsCubit, ProgramsStates>(
                    listener:(context, state){},
                    builder: (context, state)
                    {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListView.builder(
                              itemCount: ProgramsCubit.get(context).filteredPrograms.length,
                              itemBuilder: (context, index)=>
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: ProgramBuilder(programModel: ProgramsCubit.get(context).filteredPrograms[index]),
                                  )
                          ),
                        ),
                      );
                    }
                ),
                SizedBox(height: 20,),


              ],
            )
        ),
      )
    );

  }
}


class ProgramBuilder extends StatefulWidget {
  const ProgramBuilder({Key? key, required this.programModel}) : super(key: key);

  final ProgramModel programModel;

  @override
  State<ProgramBuilder> createState() => _ProgramBuilderState();
}

class _ProgramBuilderState extends State<ProgramBuilder> {
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
  @override
  void initState() {

    for(int i=0; i<ProgramsCubit.get(context).roomsData.length;i++)
    {
      print('object');
      //adultsSingle += ProgramsCubit.get(context).roomsData[i].adults;
      kidsWithBed += ProgramsCubit.get(context).roomsData[i].kidsWithBed;
      kidsWithNoBed += ProgramsCubit.get(context).roomsData[i].kidsWithNoBed;
      infants += ProgramsCubit.get(context).roomsData[i].infants;
      if(ProgramsCubit.get(context).roomsData[i].adults==1)
      {
        hasSingle = true;
        adultsSingle++;
      }
      else if(ProgramsCubit.get(context).roomsData[i].adults==2)
      {
        hasDouble = true;
        adultsDouble+=2;
      }
      else
      {
        adultsTriple+=3;
        hasTriple = true;
      }
      if(ProgramsCubit.get(context).roomsData[i].kidsWithBed >0)
      {
        hasChildBed = true;
      }
      if(ProgramsCubit.get(context).roomsData[i].kidsWithNoBed >0)
      {
        hasChildNoBed = true;
      }
      if(ProgramsCubit.get(context).roomsData[i].infants >0)
      {
        hasInfants = true;
      }
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('0000000000000');
    return  BlocConsumer<ProgramsCubit, ProgramsStates>(
        listener:(context, state) {},
        builder: (context, state) {
          print('++++');
          print(adultsSingle);
          print(adultsDouble);
          print(adultsTriple);

          double net = (infants * double.parse(widget.programModel.pricePerInfant!))+
            (adultsSingle * double.parse(widget.programModel.pricePerAdultIndividual!)) +
            (adultsDouble * double.parse(widget.programModel.pricePerAdultDouble!)) +
            (adultsTriple * double.parse(widget.programModel.pricePerAdultTriple!)) +
            (kidsWithBed * double.parse(widget.programModel.pricePerChildWithBed!)) +
            (kidsWithNoBed * double.parse(widget.programModel.pricePerChildNoBed!))
          ;
          double total = net+ (net*(double.parse(widget.programModel.tax!)/100));

          //programModel.includesFlight=0;
      return InkWell(
        onTap: ()
        {
          Get.to(()=>ProgramPassengerData(
              total: total.toString(),
              programModel: widget.programModel),
            transition: DelayManager.leftToRight,
            duration: Duration(milliseconds: 500)
          );
        },
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 5,
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
                  SizedBox(
                    // width: double.infinity,
                    // height: 150,
                    child: CachedNetworkImage(
                      imageBuilder: (context, provider)=>
                      Container(height: 150,width: double.infinity,decoration: BoxDecoration(image: DecorationImage(image: provider,fit: BoxFit.cover,),),),
                      imageUrl:
                      'https://api.seasonsge.com/images/${widget.programModel
                          .mainImage}',
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
                                image: AssetImage(AssetsManager.tourism),
                                fit: BoxFit.cover,),),),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            CacheData.lang == CacheHelperKeys.keyEN ? widget.programModel
                                .programTitleEnglish! : widget.programModel
                                .programTitleArabic!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            CacheData.lang == CacheHelperKeys.keyEN ? widget.programModel
                                .programDetailsEnglish! : widget.programModel
                                .programDetailsArabic!,
                            style: TextStyle(color: Colors.grey,
                                fontWeight: FontWeight.bold, fontSize: 12),),
                        ),
                        SizedBox(height: 5,),
                        if(widget.programModel.includesFlight==0)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text('$total \$', style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20
                          ),),
                        ),
                      ],
                    ),
                  ),
                  Text( CacheData.lang == CacheHelperKeys.keyEN ?
                    '${widget.programModel.numOfDays} days, ${widget.programModel.numOfNights} nights':
                    '${widget.programModel.numOfDays} ايام, ${widget.programModel.numOfNights} ليال',
                    style: TextStyle(color: ColorsManager.primaryColor,
                      fontWeight: FontWeight.bold, fontSize: 16
                  ),),
                  Text(
                    '${widget.programModel.fromDate} : ${widget.programModel.toDate}',
                    style: TextStyle(color: Colors.grey,
                      fontWeight: FontWeight.bold, fontSize: 12
                  ),),
                  //SizedBox(height: 5,),
                  if(widget.programModel.includesFlight==1)
                  FlightBuilder(total: total, program: widget.programModel),

                  Column(
                    children:
                    [
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children:
                          [
                            Row(
                              children:
                              [
                                Expanded(
                                  flex: 2,
                                  child:   Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Tax':'الضريبة',
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                      child:  Text(
                                        '${widget.programModel.tax!} \%',
                                        style: TextStyle(
                                            fontSize: 16,
                                            height: 1.2,
                                            color: Colors.red,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    )
                                ),
                              ],
                            ),
                            if(hasSingle)
                            Divider(),
                            if(hasSingle)
                            Row(
                              children:
                              [
                                Expanded(
                                  flex: 2,
                                  child:  Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for single adult':'السعر لشخص بمفرده',
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child:   Center(
                                    child: Text(
                                      '${widget.programModel.pricePerAdultIndividual!} \$',
                                      style: TextStyle(
                                          fontSize: 16,
                                          height: 1.2,
                                          color: Colors.red,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                  ),
                                )

                              ],
                            ),
                            if(hasDouble)
                            Divider(),
                            if(hasDouble)
                            Row(
                              children:
                              [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for double adults':'السعر لشخصين',
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                      child:   Text(
                                        '${widget.programModel.pricePerAdultDouble!} \$',
                                        style: TextStyle(
                                            fontSize: 16,
                                            height: 1.2,
                                            color: Colors.red,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    )
                                ),
                              ],
                            ),
                            if(hasTriple)
                            Divider(),
                            if(hasTriple)
                            Row(
                              children:
                              [
                                Expanded(
                                  flex: 2,
                                  child:Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for triple adults':'السعر لثلاثة اشخاص',
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                      child: Text(
                                        '${widget.programModel.pricePerAdultTriple!} \$',
                                        style: TextStyle(
                                            fontSize: 16,
                                            height: 1.2,
                                            color: Colors.red,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    )
                                ),
                              ],
                            ),
                            if(hasChildNoBed)
                            Divider(),
                            if(hasChildNoBed)
                            Row(
                              children:
                              [
                                Expanded(
                                  flex: 2,
                                  child:    Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for a child without bed':'السعر للطفل بدون سرير',
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                      child:  Text(
                                        '${widget.programModel.pricePerChildNoBed!} \$',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            height: 1.2,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    )
                                ),
                              ],
                            ),
                            if(hasChildBed)
                            Divider(),
                            if(hasChildBed)
                            Row(
                              children:
                              [
                                Expanded(
                                  flex: 2,
                                  child:Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for a child with bed':'السعر للطفل بسرير',
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                      child:  Text(
                                        '${widget.programModel.pricePerChildWithBed!} \$',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            height: 1.2,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    )
                                ),
                              ],
                            ),
                            if(hasInfants)
                            Divider(),
                            if(hasInfants)
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      CacheData.lang == CacheHelperKeys.keyEN
                                          ? 'Price for an infant'
                                          : 'السعر للرضيع',
                                      style: TextStyle(
                                          fontSize: 16,
                                          height: 1.2,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Expanded(
                                    child: Center(
                                      child: Text(
                                        '${widget.programModel.pricePerInfant!} \$',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            height: 1.2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ],
                            ),



                          ],
                        ),
                      ),
                      SizedBox(height: 10,)


                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    );
  }
}

class FlightBuilder extends StatelessWidget {
  const FlightBuilder({super.key,required this.total, required this.program});
  final double total;
  final ProgramModel program;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$ $total',
            style: TextStyle(
                fontSize: 20,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold),
          ),
          Text(
            TranslationKeyManager.allTaxes.tr,
            style: TextStyle(
                color: Colors.grey,
                height: 1.2,
                fontWeight: FontWeight.w600),
          ),
          Divider(),
          SizedBox(
            height: 5,
          ),
          if(program.flightNumber != null && program.flightNumber != 'null')
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Flight number ${program.flightNumber}',
                style: TextStyle(
                    color: ColorsManager.primaryColor,
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.bold),
              ),
            ),
          Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                    10),
                child:
                Container(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                      placeholder: (context, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      imageUrl: 'https://api.seasonsge.com/images/${program.departureAirlineModel!.image!}'),

                ),
              ),
              SizedBox(width: 15,),
              Text(
                CacheData.lang == CacheHelperKeys.keyEN?
                program.departureAirlineModel!.nameEn!:
                program.departureAirlineModel!.nameAr!,
                style: TextStyle(
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w600),
              ),
              //Spacer(),
              // Text(
              //   '${program.allowedWeightKg} KG of weight allowed',
              //   style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12,
              //       height: 1.2,
              //       fontWeight: FontWeight.w600),
              // ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   program.departureAirportModel!.englishName!,
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       height: 1.2,
                    //       fontWeight:
                    //       FontWeight.bold),
                    // ),
                    Text(
                      program.departureTime!,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.2,
                          color: Colors.grey,
                          fontWeight:
                          FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      CacheData.lang == CacheHelperKeys.keyEN ?
                      '${program.departureAirportModel!.englishName!}':
                      '${program.departureAirportModel!.arabicName!}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          height: 1.2),
                    )
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 3,
                        ),
                        Container(
                          height: 1,
                          width: 25,
                          color: Colors.grey,
                        ),
                        CircleAvatar(
                            backgroundColor:
                            Colors.grey,
                            radius: 3,
                            child: CircleAvatar(
                              backgroundColor:
                              Colors.white,
                              radius: 2,
                            )),
                        Container(
                          height: 1,
                          width: 25,
                          color: Colors.grey,
                        ),
                        Transform.rotate(
                            angle: pi * 0.5,
                            child: Icon(
                              Icons.airplanemode_active,
                              size: 12,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      program.arrivalTime!,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.2,
                          color: Colors.grey,
                          fontWeight:
                          FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      CacheData.lang == CacheHelperKeys.keyEN ?
                      '${program.arrivalAirportModel!.englishName}':
                      '${program.arrivalAirportModel!.arabicName}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.black,
                          height: 1.2),
                    )
                  ],
                ),
              ),
            ],
          ),
          if(program.allowedWeightKg!<=7)
            Column(
              children: [
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Handbag weight allowed : ${program.allowedWeightKg} KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Luggage weight allowed : 0.0 KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

          if(program.allowedWeightKg!>7)
            Column(
              children: [
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Handbag weight allowed : 7.0 KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Luggage weight allowed : ${program.allowedWeightKg!-7} KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

          Divider(),

          SizedBox(
            height: 5,
          ),
          if(program.returnFlightNumber != null && program.returnFlightNumber != 'null')
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              'Flight number ${program.returnFlightNumber}',
              style: TextStyle(
                  color: ColorsManager.primaryColor,
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.bold),
            ),
          ),
          program.returnAirlineModel ==null?
          Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                    10),
                child:
                Container(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                      placeholder: (context, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      imageUrl: 'https://api.seasonsge.com/images/${program.departureAirlineModel!.image!}'),

                ),
              ),
              SizedBox(width: 15,),
              Text(
                CacheData.lang == CacheHelperKeys.keyEN?
                program.departureAirlineModel!.nameEn!:
                program.departureAirlineModel!.nameAr!,
                style: TextStyle(
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w600),
              ),
              // Spacer(),
              // Text(
              //   '${program.returnAllowedWeightKg} KG of weight allowed',
              //   style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12,
              //       height: 1.2,
              //       fontWeight: FontWeight.w600),
              // ),
            ],
          ):
          Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                    10),
                child:
                Container(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                      placeholder: (context, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      imageUrl: 'https://api.seasonsge.com/images/${program.returnAirlineModel!.image!}'),

                ),
              ),
              SizedBox(width: 15,),
              Text(
                CacheData.lang == CacheHelperKeys.keyEN?
                program.returnAirlineModel!.nameEn!:
                program.returnAirlineModel!.nameAr!,
                style: TextStyle(
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w600),
              ),
              // Spacer(),
              // Text(
              //   '${program.returnAllowedWeightKg} KG of weight allowed',
              //   style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12,
              //       height: 1.2,
              //       fontWeight: FontWeight.w600),
              // ),
            ],
          ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   program.r!,
                          //   style: TextStyle(
                          //       fontSize: 16,
                          //       height: 1.2,
                          //       fontWeight:
                          //       FontWeight.bold),
                          // ),
                          Text(
                            program.returnDepartureTime!,
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.2,
                                color: Colors.grey,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          SizedBox(height: 5,),
                          program.returnFromAirportModel==null?
                          Text(
                            CacheData.lang == CacheHelperKeys.keyEN ?
                            '${program.departureAirportModel!.englishName}':
                            '${program.departureAirportModel!.arabicName}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                height: 1.2),
                          ):
                          Text(
                            CacheData.lang == CacheHelperKeys.keyEN ?
                            '${program.returnFromAirportModel!.englishName}':
                            '${program.returnFromAirportModel!.arabicName}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                height: 1.2),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text(
                          //   '${double.parse(FlightsCubit.get(context).flights[index].durationHours!).toInt()} h ${double.parse(FlightsCubit.get(context).flights[index].durationHours!).remainder(1)!=0?"${(double.parse(FlightsCubit.get(context).flights[index].durationHours!)-double.parse(FlightsCubit.get(context).flights[index].durationHours!).truncate()).toString().replaceFirst('.', '')} min":''}',
                          //   style: TextStyle(
                          //       color: Colors.grey,
                          //       height: 1.2,
                          //       fontSize: 10),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 3,
                              ),
                              Container(
                                height: 1,
                                width: 25,
                                color: Colors.grey,
                              ),
                              CircleAvatar(
                                  backgroundColor:
                                  Colors.grey,
                                  radius: 3,
                                  child: CircleAvatar(
                                    backgroundColor:
                                    Colors.white,
                                    radius: 2,
                                  )),
                              Container(
                                height: 1,
                                width: 25,
                                color: Colors.grey,
                              ),
                              Transform.rotate(
                                  angle: pi * 0.5,
                                  child: Icon(
                                    Icons.airplanemode_active,
                                    size: 12,
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                          // Text(
                          //   '${FlightsCubit.get(context).flights[index].numStops!} stop',
                          //   style: TextStyle(
                          //       color: Colors.grey,
                          //       height: 1.5,
                          //       fontSize: 10),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Text(
                          //   program.reA!,
                          //   style: TextStyle(
                          //       fontSize: 16,
                          //       height: 1.2,
                          //       fontWeight:
                          //       FontWeight.bold),
                          // ),
                          Text(
                            program.returnArrivalTime!,
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.2,
                                color: Colors.grey,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          SizedBox(height: 5,),
                          program.returnToAirportModel ==null?
                          Text(
                            CacheData.lang == CacheHelperKeys.keyEN ?
                            '${program.arrivalAirportModel!.englishName!}':
                            '${program.arrivalAirportModel!.arabicName!}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.black,
                                height: 1.2),
                          ) :
                          Text(
                            CacheData.lang == CacheHelperKeys.keyEN ?
                            '${program.returnToAirportModel!.englishName!}':
                            '${program.returnToAirportModel!.arabicName!}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.black,
                                height: 1.2),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

          if(program.returnAllowedWeightKg!<=7)
            Column(
              children: [
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Handbag weight allowed : ${program.returnAllowedWeightKg} KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Luggage weight allowed : 0.0 KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

          if(program.returnAllowedWeightKg!>7)
            Column(
              children: [
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Handbag weight allowed : 7.0 KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Luggage weight allowed : ${program.returnAllowedWeightKg!-7} KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),



        ],
      ),
    );
  }
}


class FlightBuilderThree extends StatelessWidget {
  const FlightBuilderThree({super.key,required this.total, required this.program});
  final double total;
  final ProgramModel program;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\$ $total',
            style: TextStyle(
                fontSize: 20,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold),
          ),
          Text(
            TranslationKeyManager.allTaxes.tr,
            style: TextStyle(
                color: Colors.grey,
                height: 1.2,
                fontWeight: FontWeight.w600),
          ),
          Divider(),
          SizedBox(
            height: 5,
          ),
          if(program.flightNumber != null && program.flightNumber != 'null')
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Flight number ${program.flightNumber}',
                style: TextStyle(
                    color: ColorsManager.primaryColor,
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.bold),
              ),
            ),
          Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                    10),
                child:
                Container(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                      placeholder: (context, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      imageUrl: 'https://api.seasonsge.com/images/${program.departureAirlineModel!.image!}'),

                ),
              ),
              SizedBox(width: 15,),
              Text(
                CacheData.lang == CacheHelperKeys.keyEN?
                program.departureAirlineModel!.nameEn!:
                program.departureAirlineModel!.nameAr!,
                style: TextStyle(
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w600),
              ),
              //Spacer(),
              // Text(
              //   '${program.allowedWeightKg} KG of weight allowed',
              //   style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12,
              //       height: 1.2,
              //       fontWeight: FontWeight.w600),
              // ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   program.departureAirportModel!.englishName!,
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       height: 1.2,
                    //       fontWeight:
                    //       FontWeight.bold),
                    // ),
                    Text(
                      program.departureTime!,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.2,
                          color: Colors.grey,
                          fontWeight:
                          FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      CacheData.lang == CacheHelperKeys.keyEN ?
                      '${program.departureAirportModel!.englishName!}':
                      '${program.departureAirportModel!.arabicName!}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          height: 1.2),
                    )
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 3,
                        ),
                        Container(
                          height: 1,
                          width: 25,
                          color: Colors.grey,
                        ),
                        CircleAvatar(
                            backgroundColor:
                            Colors.grey,
                            radius: 3,
                            child: CircleAvatar(
                              backgroundColor:
                              Colors.white,
                              radius: 2,
                            )),
                        Container(
                          height: 1,
                          width: 25,
                          color: Colors.grey,
                        ),
                        Transform.rotate(
                            angle: pi * 0.5,
                            child: Icon(
                              Icons.airplanemode_active,
                              size: 12,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      program.arrivalTime!,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.2,
                          color: Colors.grey,
                          fontWeight:
                          FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      CacheData.lang == CacheHelperKeys.keyEN ?
                      '${program.arrivalAirportModel!.englishName}':
                      '${program.arrivalAirportModel!.arabicName}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.black,
                          height: 1.2),
                    )
                  ],
                ),
              ),
            ],
          ),
          if(double.parse(program.allowedWeightKg)<=7)
            Column(
              children: [
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Handbag weight allowed : ${program.allowedWeightKg} KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Luggage weight allowed : 0.0 KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

          if(double.parse(program.allowedWeightKg)>7)
            Column(
              children: [
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Handbag weight allowed : 7.0 KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Luggage weight allowed : ${double.parse(program.allowedWeightKg)-7} KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

          Divider(),

          SizedBox(
            height: 5,
          ),
          if(program.returnFlightNumber != null && program.returnFlightNumber != 'null')
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                'Flight number ${program.returnFlightNumber}',
                style: TextStyle(
                    color: ColorsManager.primaryColor,
                    fontSize: 12,
                    height: 1.2,
                    fontWeight: FontWeight.bold),
              ),
            ),
          program.returnAirlineModel ==null?
          Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                    10),
                child:
                Container(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                      placeholder: (context, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      imageUrl: 'https://api.seasonsge.com/images/${program.departureAirlineModel!.image!}'),

                ),
              ),
              SizedBox(width: 15,),
              Text(
                CacheData.lang == CacheHelperKeys.keyEN?
                program.departureAirlineModel!.nameEn!:
                program.departureAirlineModel!.nameAr!,
                style: TextStyle(
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w600),
              ),
              // Spacer(),
              // Text(
              //   '${program.returnAllowedWeightKg} KG of weight allowed',
              //   style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12,
              //       height: 1.2,
              //       fontWeight: FontWeight.w600),
              // ),
            ],
          ):
          Row(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                    10),
                child:
                Container(
                  height: 50,
                  width: 50,
                  child: CachedNetworkImage(
                      placeholder: (context, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                      ),
                      imageUrl: 'https://api.seasonsge.com/images/${program.returnAirlineModel!.image!}'),

                ),
              ),
              SizedBox(width: 15,),
              Text(
                CacheData.lang == CacheHelperKeys.keyEN?
                program.returnAirlineModel!.nameEn!:
                program.returnAirlineModel!.nameAr!,
                style: TextStyle(
                    color: Colors.black,
                    height: 1.2,
                    fontWeight: FontWeight.w600),
              ),
              // Spacer(),
              // Text(
              //   '${program.returnAllowedWeightKg} KG of weight allowed',
              //   style: TextStyle(
              //       color: Colors.grey,
              //       fontSize: 12,
              //       height: 1.2,
              //       fontWeight: FontWeight.w600),
              // ),
            ],
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   program.r!,
                        //   style: TextStyle(
                        //       fontSize: 16,
                        //       height: 1.2,
                        //       fontWeight:
                        //       FontWeight.bold),
                        // ),
                        Text(
                          program.returnDepartureTime!,
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.2,
                              color: Colors.grey,
                              fontWeight:
                              FontWeight.bold),
                        ),
                        SizedBox(height: 5,),
                        program.returnFromAirportModel==null?
                        Text(
                          CacheData.lang == CacheHelperKeys.keyEN ?
                          '${program.departureAirportModel!.englishName}':
                          '${program.departureAirportModel!.arabicName}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black,
                              height: 1.2),
                        ):
                        Text(
                          CacheData.lang == CacheHelperKeys.keyEN ?
                          '${program.returnFromAirportModel!.englishName}':
                          '${program.returnFromAirportModel!.arabicName}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black,
                              height: 1.2),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text(
                        //   '${double.parse(FlightsCubit.get(context).flights[index].durationHours!).toInt()} h ${double.parse(FlightsCubit.get(context).flights[index].durationHours!).remainder(1)!=0?"${(double.parse(FlightsCubit.get(context).flights[index].durationHours!)-double.parse(FlightsCubit.get(context).flights[index].durationHours!).truncate()).toString().replaceFirst('.', '')} min":''}',
                        //   style: TextStyle(
                        //       color: Colors.grey,
                        //       height: 1.2,
                        //       fontSize: 10),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 3,
                            ),
                            Container(
                              height: 1,
                              width: 25,
                              color: Colors.grey,
                            ),
                            CircleAvatar(
                                backgroundColor:
                                Colors.grey,
                                radius: 3,
                                child: CircleAvatar(
                                  backgroundColor:
                                  Colors.white,
                                  radius: 2,
                                )),
                            Container(
                              height: 1,
                              width: 25,
                              color: Colors.grey,
                            ),
                            Transform.rotate(
                                angle: pi * 0.5,
                                child: Icon(
                                  Icons.airplanemode_active,
                                  size: 12,
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                        // Text(
                        //   '${FlightsCubit.get(context).flights[index].numStops!} stop',
                        //   style: TextStyle(
                        //       color: Colors.grey,
                        //       height: 1.5,
                        //       fontSize: 10),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Text(
                        //   program.reA!,
                        //   style: TextStyle(
                        //       fontSize: 16,
                        //       height: 1.2,
                        //       fontWeight:
                        //       FontWeight.bold),
                        // ),
                        Text(
                          program.returnArrivalTime!,
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.2,
                              color: Colors.grey,
                              fontWeight:
                              FontWeight.bold),
                        ),
                        SizedBox(height: 5,),
                        program.returnToAirportModel ==null?
                        Text(
                          CacheData.lang == CacheHelperKeys.keyEN ?
                          '${program.arrivalAirportModel!.englishName!}':
                          '${program.arrivalAirportModel!.arabicName!}',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.black,
                              height: 1.2),
                        ) :
                        Text(
                          CacheData.lang == CacheHelperKeys.keyEN ?
                          '${program.returnToAirportModel!.englishName!}':
                          '${program.returnToAirportModel!.arabicName!}',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.black,
                              height: 1.2),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          if(double.parse(program.returnAllowedWeightKg)<=7)
            Column(
              children: [
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Handbag weight allowed : ${program.returnAllowedWeightKg} KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Luggage weight allowed : 0.0 KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

          if(double.parse(program.returnAllowedWeightKg)>7)
            Column(
              children: [
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Handbag weight allowed : 7.0 KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Luggage weight allowed : ${double.parse(program.returnAllowedWeightKg)-7} KG',
                    style: TextStyle(
                        color: Colors.grey,
                        height: 1.2,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),



        ],
      ),
    );
  }
}


class ProgramBuilder2 extends StatefulWidget {
  const ProgramBuilder2({Key? key, required this.programModel,}) : super(key: key);


  final ProgramModel programModel;

  @override
  State<ProgramBuilder2> createState() => _ProgramBuilder2State();
}

class _ProgramBuilder2State extends State<ProgramBuilder2> {
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
  @override
  void initState() {

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

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('0000000000000');
    return  BlocConsumer<ProgramsCubit, ProgramsStates>(
        listener:(context, state) {},
        builder: (context, state) {
          print('++++');
          print(adultsSingle);
          print(adultsDouble);
          print(adultsTriple);

          double net = (infants * double.parse(widget.programModel.pricePerInfant!))+
              (adultsSingle * double.parse(widget.programModel.pricePerAdultIndividual!)) +
              (adultsDouble * double.parse(widget.programModel.pricePerAdultDouble!)) +
              (adultsTriple * double.parse(widget.programModel.pricePerAdultTriple!)) +
              (kidsWithBed * double.parse(widget.programModel.pricePerChildWithBed!)) +
              (kidsWithNoBed * double.parse(widget.programModel.pricePerChildNoBed!))
          ;
          double total = net+ (net*(double.parse(widget.programModel.tax!)/100));

          //programModel.includesFlight=0;
          return InkWell(
            onTap: ()
            {
              // Get.to(()=>ProgramPassengerData(
              //     total: total.toString(),
              //     programModel: widget.programModel),
              //     transition: DelayManager.leftToRight,
              //     duration: Duration(milliseconds: 500)
              // );
            },
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
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
                      SizedBox(
                        // width: double.infinity,
                        // height: 150,
                        child: CachedNetworkImage(
                          imageBuilder: (context, provider)=>
                              Container(height: 150,width: double.infinity,decoration: BoxDecoration(image: DecorationImage(image: provider,fit: BoxFit.cover,),),),
                          imageUrl:
                          'https://api.seasonsge.com/images/${widget.programModel
                              .mainImage}',
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
                                    image: AssetImage(AssetsManager.tourism),
                                    fit: BoxFit.cover,),),),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                CacheData.lang == CacheHelperKeys.keyEN ? widget.programModel
                                    .programTitleEnglish! : widget.programModel
                                    .programTitleArabic!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),),
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                CacheData.lang == CacheHelperKeys.keyEN ? widget.programModel
                                    .programDetailsEnglish! : widget.programModel
                                    .programDetailsArabic!,
                                style: TextStyle(color: Colors.grey,
                                    fontWeight: FontWeight.bold, fontSize: 12),),
                            ),
                            SizedBox(height: 5,),
                            if(widget.programModel.includesFlight==0)
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text('$total \$', style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20
                                ),),
                              ),
                          ],
                        ),
                      ),
                      Text( CacheData.lang == CacheHelperKeys.keyEN ?
                      '${widget.programModel.numOfDays} days, ${widget.programModel.numOfNights} nights':
                      '${widget.programModel.numOfDays} ايام, ${widget.programModel.numOfNights} ليال',
                        style: TextStyle(color: ColorsManager.primaryColor,
                            fontWeight: FontWeight.bold, fontSize: 16
                        ),),
                      Text(
                        '${widget.programModel.fromDate} : ${widget.programModel.toDate}',
                        style: TextStyle(color: Colors.grey,
                            fontWeight: FontWeight.bold, fontSize: 12
                        ),),
                      //SizedBox(height: 5,),
                      if(widget.programModel.includesFlight.toString()=='1')
                        FlightBuilderThree(total: total, program: widget.programModel),

                      Column(
                        children:
                        [
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children:
                              [
                                Row(
                                  children:
                                  [
                                    Expanded(
                                      flex: 2,
                                      child:   Text(
                                        CacheData.lang==CacheHelperKeys.keyEN?'Tax':'الضريبة',
                                        style: TextStyle(
                                            fontSize: 16,
                                            height: 1.2,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                        child: Center(
                                          child:  Text(
                                            '${widget.programModel.tax!} \%',
                                            style: TextStyle(
                                                fontSize: 16,
                                                height: 1.2,
                                                color: Colors.red,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                                if(hasSingle)
                                  Divider(),
                                if(hasSingle)
                                  Row(
                                    children:
                                    [
                                      Expanded(
                                        flex: 2,
                                        child:  Text(
                                          CacheData.lang==CacheHelperKeys.keyEN?'Price for single adult':'السعر لشخص بمفرده',
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1.2,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child:   Center(
                                          child: Text(
                                            '${widget.programModel.pricePerAdultIndividual!} \$',
                                            style: TextStyle(
                                                fontSize: 16,
                                                height: 1.2,
                                                color: Colors.red,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                if(hasDouble)
                                  Divider(),
                                if(hasDouble)
                                  Row(
                                    children:
                                    [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          CacheData.lang==CacheHelperKeys.keyEN?'Price for double adults':'السعر لشخصين',
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1.2,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                            child:   Text(
                                              '${widget.programModel.pricePerAdultDouble!} \$',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  height: 1.2,
                                                  color: Colors.red,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                if(hasTriple)
                                  Divider(),
                                if(hasTriple)
                                  Row(
                                    children:
                                    [
                                      Expanded(
                                        flex: 2,
                                        child:Text(
                                          CacheData.lang==CacheHelperKeys.keyEN?'Price for triple adults':'السعر لثلاثة اشخاص',
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1.2,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                            child: Text(
                                              '${widget.programModel.pricePerAdultTriple!} \$',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  height: 1.2,
                                                  color: Colors.red,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                if(hasChildNoBed)
                                  Divider(),
                                if(hasChildNoBed)
                                  Row(
                                    children:
                                    [
                                      Expanded(
                                        flex: 2,
                                        child:    Text(
                                          CacheData.lang==CacheHelperKeys.keyEN?'Price for a child without bed':'السعر للطفل بدون سرير',
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1.2,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                            child:  Text(
                                              '${widget.programModel.pricePerChildNoBed!} \$',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                  height: 1.2,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                if(hasChildBed)
                                  Divider(),
                                if(hasChildBed)
                                  Row(
                                    children:
                                    [
                                      Expanded(
                                        flex: 2,
                                        child:Text(
                                          CacheData.lang==CacheHelperKeys.keyEN?'Price for a child with bed':'السعر للطفل بسرير',
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1.2,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                          child: Center(
                                            child:  Text(
                                              '${widget.programModel.pricePerChildWithBed!} \$',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                  height: 1.2,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                if(hasInfants)
                                  Divider(),
                                if(hasInfants)
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            CacheData.lang == CacheHelperKeys.keyEN
                                                ? 'Price for an infant'
                                                : 'السعر للرضيع',
                                            style: TextStyle(
                                                fontSize: 16,
                                                height: 1.2,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          child: Center(
                                            child: Text(
                                              '${widget.programModel.pricePerInfant!} \$',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                  height: 1.2,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ],
                                  ),



                              ],
                            ),
                          ),
                          SizedBox(height: 10,)


                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
