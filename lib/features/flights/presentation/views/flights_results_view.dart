import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/airports/data/models/airport_model.dart';
import 'package:seasons/features/flights/data/models/flight_model.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_cubit.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_states.dart';

import '../../../../core/localization/translation_key_manager.dart';
import 'flight_passenger_data.dart';

class FlightResultsView extends StatefulWidget {
  const FlightResultsView({
    Key? key,
    required this.roundTrip,
    this.noData=false,
    required this.fromAirport,
    required this.toAirport,
    required this.startDateOfficial,
    this.endDateOfficial,
  }) : super(key: key);

  final bool roundTrip;
  final bool noData;
  final AirportModel fromAirport;
  final AirportModel toAirport;
  final String startDateOfficial;
  final String? endDateOfficial;

  @override
  State<FlightResultsView> createState() => _FlightResultsViewState();
}

class _FlightResultsViewState extends State<FlightResultsView> {
  @override
  void initState() {
    if(widget.noData)
    {
      allFlights = true;
    }
    setState(() {});
    super.initState();
  }
  bool allFlights = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlightsCubit, FlightsStates>(
      listener: (context, state) {},
      builder: (context, state) {
       // FlightsCubit.get(context).flights[0].durationHours = "2.5";
        print(widget.roundTrip);
        return Scaffold(
          appBar: defaultAppBar(context: context, text: (widget.noData)?TranslationKeyManager.availableFlights.tr :TranslationKeyManager.results.tr),
          body: BasicView3(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0)
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Center(
                                  child: Text(
                                    CacheData.lang == CacheHelperKeys.keyEN?
                                    widget.fromAirport.englishName!:
                                    widget.fromAirport.arabicName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: widget.roundTrip
                                  ? Icon(Icons.compare_arrows_outlined)
                                  : Icon(Icons.arrow_right_alt),
                            ),
                            Expanded(
                                child: Center(
                                  child: Text(
                                    CacheData.lang == CacheHelperKeys.keyEN?
                                    widget.toAirport.englishName!:
                                    widget.toAirport.arabicName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.endDateOfficial == null
                                  ? widget.startDateOfficial
                                  : '${widget.startDateOfficial} - ${widget.endDateOfficial}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 17,
                            ),
                            Text(
                                '${FlightsCubit.get(context).infants + FlightsCubit.get(context).adults + FlightsCubit.get(context).kids}',
                                style: TextStyle(color: Colors.grey))
                          ],
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              if(widget.noData)
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
              SizedBox(
                height: 5,
              ),
              if(!widget.noData)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(!widget.noData)
                      TextButton(
                          onPressed: () {
                            setState(() {
                              allFlights = false;
                            });
                          },
                          child: Text(
                              '${FlightsCubit.get(context).flightsFiltered.length} ${CacheData.lang == CacheHelperKeys.keyEN?'results':'نتائج'}'
                                  .toUpperCase(),
                              style: TextStyle(
                                  height: 1.2,
                                  fontSize: 13,
                                  color: ColorsManager.primaryColor,
                                  fontWeight: FontWeight.bold))),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            allFlights = true;
                          });
                        },
                        child: Text(
                          TranslationKeyManager.availableFlights.tr
                              .toUpperCase(),
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 13,
                              color: ColorsManager.primaryColor,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),

              if (allFlights)
                Expanded(
                  child: ListView.builder(
                      itemCount: FlightsCubit.get(context).flightsNotMatch.length,
                      itemBuilder: (context, index) =>
                          FlightBuilder2(
                              flightModel: FlightsCubit.get(context).flightsNotMatch[index],
                              roundTrip: widget.roundTrip,
                              fromAirport: widget.fromAirport,
                              toAirport: widget.toAirport,
                          //    startDateOfficial: widget.startDateOfficial
                          ),
                  ),
                ),

              if (!allFlights)
                Expanded(
                  child: ListView.builder(
                      itemCount: FlightsCubit.get(context).flightsFiltered.length,
                      itemBuilder: (context, index) => FlightBuilder2(
                        flightModel: FlightsCubit.get(context).flightsFiltered[index],
                        roundTrip: widget.roundTrip,
                        fromAirport: widget.fromAirport,
                        toAirport: widget.toAirport,
                      //  startDateOfficial: widget.startDateOfficial
                      ),
                  ),
                )
            ],
          )),
        );
      },
    );
  }
}

class FlightBuilder2 extends StatelessWidget {
  const FlightBuilder2({
    super.key,
    required this.flightModel,
    required this.roundTrip,
    this.noData=false,
    required this.fromAirport,
    required this.toAirport,
    //required this.startDateOfficial,
    this.enabled = true,
    //this.endDateOfficial,
  });

  final FlightModel flightModel;
  final bool? roundTrip;
  final bool? noData;
  final AirportModel? fromAirport;
  final AirportModel? toAirport;
  // final String startDateOfficial;
  // final String? endDateOfficial;
  final bool enabled;


  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context)
        {
          double net =
              (FlightsCubit.get(context).infants * double.parse(flightModel.infantPrice!)) +
              (FlightsCubit.get(context).adults * double.parse(flightModel.adultPrice!)) +
              (FlightsCubit.get(context).kids * double.parse(flightModel.childPrice!));

          double total = net+(net* double.parse(flightModel.tax!)/100);

          print('object');
          print(flightModel.allowReturn.toString());
          print(flightModel.allowReturn.toString()=='1');
          return InkWell(
            onTap: !enabled?null:() {
              Get.to(() => FlightPassengerData(
                  roundTrip: roundTrip!,
                  fromAirport: fromAirport!,
                 // startDateOfficial: startDateOfficial,
                  toAirport:  toAirport!,
                  noData:  noData!,
                  //endDateOfficial:  endDateOfficial,
                  total: total.toString(),
                  flightModel: flightModel));
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
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
                                  imageUrl: 'https://api.seasonsge.com/images/${flightModel.airlineModel!.image!}'),

                            ),
                          ),
                          SizedBox(width: 15,),
                          Text(
                            CacheData.lang == CacheHelperKeys.keyEN?
                            flightModel.airlineModel!.nameEn!:
                            flightModel.airlineModel!.nameAr!,
                            style: TextStyle(
                                color: Colors.black,
                                height: 1.2,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    flightModel
                                        .departureDate!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                  Text(
                                    flightModel.departureTime!,
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
                                    '${flightModel.from!.englishName!}':
                                    '${flightModel.from!.arabicName!}',
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
                                  Text(
                                    '${double.parse(flightModel.durationHours!).toInt()} h ${double.parse(flightModel.durationHours!).remainder(1)!=0?"${(double.parse(flightModel.durationHours!)-double.parse(flightModel.durationHours!).truncate()).toString().replaceFirst('.', '')} min":''}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        height: 1.2,
                                        fontSize: 10),
                                  ),
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
                                  Text(
                                    '${flightModel.numStops!} stop',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        height: 1.5,
                                        fontSize: 10),
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
                                    flightModel.arrivDate22!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                  Text(
                                    flightModel.arrivalTime!,
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
                                    '${flightModel.to!.englishName}':
                                    '${flightModel.to!.arabicName}',
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
                      ),
                      if(double.parse(flightModel.allowedWeight!)<=7)
                      Column(
                        children: [
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Handbag weight allowed : ${flightModel.allowedWeight} KG',
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

                      if(double.parse(flightModel.allowedWeight!)>7)
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
                                'Luggage weight allowed : ${double.parse(flightModel.allowedWeight!)-7} KG',
                                style: TextStyle(
                                    color: Colors.grey,
                                    height: 1.2,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),

                  if(flightModel.allowReturn.toString()=='1')
                    Column(
                      children: [
                        Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flightModel.returnStartDate!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          height: 1.2,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(
                                      flightModel.returnEndDate1!,
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
                                      '${flightModel.to!.englishName}':
                                      '${flightModel.to!.arabicName}',
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
                                    Text(
                                      '${double.parse(flightModel.durationHours!).toInt()} h ${double.parse(flightModel.durationHours!).remainder(1)!=0?"${(double.parse(flightModel.durationHours!)-double.parse(flightModel.durationHours!).truncate()).toString().replaceFirst('.', '')} min":''}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          height: 1.2,
                                          fontSize: 10),
                                    ),
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
                                    Text(
                                      '${flightModel.numStops!} stop',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          height: 1.5,
                                          fontSize: 10),
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
                                      flightModel.returnEndDate!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          height: 1.2,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(
                                      flightModel.returnEndDate2!,
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
                                      '${flightModel.from!.englishName!}':
                                      '${flightModel.from!.arabicName!}',
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
                        ),
                        if(double.parse(flightModel.allowedWeightReturn!)<=7)
                          Column(
                            children: [
                              SizedBox(height: 5,),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Handbag weight allowed : ${flightModel.allowedWeightReturn} KG',
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

                        if(double.parse(flightModel.allowedWeightReturn!)>7)
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
                                  'Luggage weight allowed : ${double.parse(flightModel.allowedWeightReturn!)-7} KG',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      height: 1.2,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),

                  Divider(),
                  Column(
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
                                  '${flightModel.tax!} \%',
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
                      Divider(),
                      Row(
                        children:
                        [
                          Expanded(
                            flex: 2,
                            child:   Text(
                              CacheData.lang==CacheHelperKeys.keyEN?'Price for an adult':'السعر للشخص البالغ',
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
                                  '${flightModel.adultPrice!} \$',
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
                      if(FlightsCubit.get(context).kids !=0)
                      Divider(),
                      if(FlightsCubit.get(context).kids !=0)
                      Row(
                        children:
                        [
                          Expanded(
                            flex: 2,
                            child:  Text(
                              CacheData.lang==CacheHelperKeys.keyEN?'Price for a child':'السعر للطفل',
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
                                  '${flightModel.childPrice!} \$',
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
                      if(FlightsCubit.get(context).infants !=0)
                      Divider(),
                      if(FlightsCubit.get(context).infants !=0)
                      Row(
                        children:
                        [
                          Expanded(
                            flex: 2,
                            child:  Text(
                              CacheData.lang==CacheHelperKeys.keyEN?'Price for an infant':'السعر للرضيع',
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1.2,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                          ),
                          Expanded(
                              child: Center(
                                child:     Text('${flightModel.infantPrice!} \$',
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
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}

class FlightBuilder3 extends StatelessWidget {
  const FlightBuilder3({
    super.key,
    required this.flightModel, required this.adults, required this.kids, required this.infants,

  });

  final FlightModel flightModel;
  final int adults;
  final int kids;
  final int infants;

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context)
        {
          double net =
              (infants * double.parse(flightModel.infantPrice!)) +
              (adults * double.parse(flightModel.adultPrice!)) +
              (kids * double.parse(flightModel.childPrice!));

          double total = net+(net* double.parse(flightModel.tax!)/100);

          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
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
                                  imageUrl: 'https://api.seasonsge.com/images/${flightModel.airlineModel!.image!}'),

                            ),
                          ),
                          SizedBox(width: 15,),
                          Text(
                            CacheData.lang == CacheHelperKeys.keyEN?
                            flightModel.airlineModel!.nameEn!:
                            flightModel.airlineModel!.nameAr!,
                            style: TextStyle(
                                color: Colors.black,
                                height: 1.2,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    flightModel
                                        .departureDate!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                  Text(
                                    flightModel.departureTime!,
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
                                    '${flightModel.from!.englishName!}':
                                    '${flightModel.from!.arabicName!}',
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
                                  Text(
                                    '${double.parse(flightModel.durationHours!).toInt()} h ${double.parse(flightModel.durationHours!).remainder(1)!=0?"${(double.parse(flightModel.durationHours!)-double.parse(flightModel.durationHours!).truncate()).toString().replaceFirst('.', '')} min":''}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        height: 1.2,
                                        fontSize: 10),
                                  ),
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
                                  Text(
                                    '${flightModel.numStops!} stop',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        height: 1.5,
                                        fontSize: 10),
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
                                    flightModel.arrivDate22!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.2,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                  Text(
                                    flightModel.arrivalTime!,
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
                                    '${flightModel.to!.englishName}':
                                    '${flightModel.to!.arabicName}',
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
                      ),
                      if(double.parse(flightModel.allowedWeight!)<=7)
                      Column(
                        children: [
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Handbag weight allowed : ${flightModel.allowedWeight} KG',
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

                      if(double.parse(flightModel.allowedWeight!)>7)
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
                                'Luggage weight allowed : ${double.parse(flightModel.allowedWeight!)-7} KG',
                                style: TextStyle(
                                    color: Colors.grey,
                                    height: 1.2,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),

                  if(flightModel.allowReturn==1)
                    Column(
                      children: [
                        Divider(),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flightModel.returnStartDate!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          height: 1.2,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(
                                      flightModel.returnEndDate1!,
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
                                      '${flightModel.to!.englishName}':
                                      '${flightModel.to!.arabicName}',
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
                                    Text(
                                      '${double.parse(flightModel.durationHours!).toInt()} h ${double.parse(flightModel.durationHours!).remainder(1)!=0?"${(double.parse(flightModel.durationHours!)-double.parse(flightModel.durationHours!).truncate()).toString().replaceFirst('.', '')} min":''}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          height: 1.2,
                                          fontSize: 10),
                                    ),
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
                                    Text(
                                      '${flightModel.numStops!} stop',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          height: 1.5,
                                          fontSize: 10),
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
                                      flightModel.returnEndDate!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          height: 1.2,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    Text(
                                      flightModel.returnEndDate2!,
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
                                      '${flightModel.from!.englishName!}':
                                      '${flightModel.from!.arabicName!}',
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
                        ),
                        if(double.parse(flightModel.allowedWeightReturn!)<=7)
                          Column(
                            children: [
                              SizedBox(height: 5,),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Handbag weight allowed : ${flightModel.allowedWeightReturn} KG',
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

                        if(double.parse(flightModel.allowedWeightReturn!)>7)
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
                                  'Luggage weight allowed : ${double.parse(flightModel.allowedWeightReturn!)-7} KG',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      height: 1.2,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),

                  Divider(),
                  Column(
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
                                  '${flightModel.tax!} \%',
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
                      Divider(),
                      Row(
                        children:
                        [
                          Expanded(
                            flex: 2,
                            child:   Text(
                              CacheData.lang==CacheHelperKeys.keyEN?'Price for an adult':'السعر للشخص البالغ',
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
                                  '${flightModel.adultPrice!} \$',
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
                      if(kids !=0)
                      Divider(),
                      if(kids !=0)
                      Row(
                        children:
                        [
                          Expanded(
                            flex: 2,
                            child:  Text(
                              CacheData.lang==CacheHelperKeys.keyEN?'Price for a child':'السعر للطفل',
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
                                  '${flightModel.childPrice!} \$',
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
                      if(infants !=0)
                      Divider(),
                      if(infants !=0)
                      Row(
                        children:
                        [
                          Expanded(
                            flex: 2,
                            child:  Text(
                              CacheData.lang==CacheHelperKeys.keyEN?'Price for an infant':'السعر للرضيع',
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1.2,
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                          ),
                          Expanded(
                              child: Center(
                                child:     Text('${flightModel.infantPrice!} \$',
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
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
