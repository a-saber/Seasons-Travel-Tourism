import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seasons/core/core_widgets/defaultrating.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/assets_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';
import 'package:seasons/features/flights/presentation/views/flight_passenger_data.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_cubit.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_states.dart';

import '../../../../../core/core_widgets/list_item_image.dart';
import '../../../../../core/local_database/cache_data.dart';
import '../../../../../core/localization/translation_key_manager.dart';
import '../../../data/models/hotel_model.dart';

class HotelsListItem extends StatelessWidget {
  const HotelsListItem({Key? key, required this.hotel, required this.daysCount}) : super(key: key);
  final HotelModel hotel;
  final int daysCount;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HotelsCubit, HotelsStates>(
      listener:  (context, state){},
      builder: (context, state)
      {
        //double total =hotel();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          decoration:
          BoxDecoration(border: Border.all(color: Colors.black54, width: .3)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListItemImage(
                  image: 'https://api.seasonsge.com/${hotel.mainImage!}',
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      CacheData.lang == TranslationKeyManager.localeAR.toString()
                          ? hotel.name!
                          : hotel.nameEn!,
                      style: StyleManager.hotelItemTitle,
                    ),
                    DefaultRating(rate: double.parse(hotel.rating!)),
                    Text(hotel.city!, style: StyleManager.hotelItemTitle),
                    Text(
                      '${hotel.rating!} ${TranslationKeyManager.stars.tr}',
                      style: StyleManager.hotelItemExtraTitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    /*Column(
      children: [
        Expanded(
            child: ListItemImage(
          image:
              "https://imgcy.trivago.com/c_limit,d_dummy.jpeg,f_auto,h_600,q_auto,w_600//itemimages/29/25/2925620_v2.jpeg",
        )),
        SizedBox(
          height: 5,
        ),
        Text(
          'Green Tower',
          style:
              StyleManager.hotelItemTitle.copyWith(color: Colors.blue.shade700),
        ),
        DefaultRating(rate: 5),
        Text('تبليسي || جورجيا',
            style: StyleManager.hotelItemTitle
                .copyWith(color: Colors.blue.shade700)),
        Text(
          'نجمة 4',
          style: StyleManager.hotelItemExtraTitle,
        ),
      ],
    );*/
  }
}


class HotelsListItem2 extends StatefulWidget {
  const HotelsListItem2({Key? key, required this.hotel, required this.total}) : super(key: key);
  final double total;
  final HotelModel hotel;



  @override
  State<HotelsListItem2> createState() => _HotelsListItem2State();
}

class _HotelsListItem2State extends State<HotelsListItem2> {

  bool hasSingle = false;
  bool hasDouble = false;
  bool hasTriple = false;
  bool hasChildBed = false;
  bool hasChildNoBed = false;
  bool hasInfants = false;
  @override
  void initState() {

    for(int i=0; i<HotelsCubit.get(context).roomsData.length;i++)
    {
      if(HotelsCubit.get(context).roomsData[i].adults==1)
      {
        hasSingle = true;
      }
      else if(HotelsCubit.get(context).roomsData[i].adults==2)
      {
        hasDouble = true;
      }
      else
      {
        hasTriple = true;
      }
      if(HotelsCubit.get(context).roomsData[i].kidsWithBed >0)
      {
        hasChildBed = true;
      }
      if(HotelsCubit.get(context).roomsData[i].kidsWithNoBed >0)
      {
        hasChildNoBed = true;
      }
      if(HotelsCubit.get(context).roomsData[i].infants >0)
      {
        hasInfants = true;
      }
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return  BlocConsumer<HotelsCubit, HotelsStates>(
        listener:(context, state) {},
        builder: (context, state) {
          return Material(
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
                    SizedBox(
                      // width: double.infinity,
                      // height: 150,
                      child: CachedNetworkImage(
                        imageBuilder: (context, provider)=>
                            Container(height: 200,width: double.infinity,decoration: BoxDecoration(image: DecorationImage(image: provider,fit: BoxFit.fill,),),),
                        imageUrl:
                        'https://api.seasonsge.com/images/${widget.hotel.mainImage}',
                        placeholder: (context, error) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 70.0),
                              child: CircularProgressIndicator(),
                            ),
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) =>
                            Container(
                              height: 200,width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetsManager.hotel),
                                  fit: BoxFit.fill,),),),
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
                              CacheData.lang == CacheHelperKeys.keyEN ?
                              widget.hotel.nameEn! :
                              widget.hotel.nameEn!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              CacheData.lang == CacheHelperKeys.keyEN ?
                              widget.hotel.detailsEn! :
                              widget.hotel.details!,
                              style: TextStyle(color: Colors.grey,
                                  fontWeight: FontWeight.bold, fontSize: 12),),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Meal type : ${widget.hotel.hotelType!}' ,
                              style: TextStyle(color: ColorsManager.primaryColor,
                                  fontWeight: FontWeight.bold, fontSize: 12),),
                          ),
                          SizedBox(height: 5,),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text('${widget.total} \$', style: TextStyle(color: Colors.redAccent,
                                fontWeight: FontWeight.bold, fontSize: 20
                            ),),
                          ),
                        ],
                      ),
                    ),
                    Text( CacheData.lang == CacheHelperKeys.keyEN ?
                    '${HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays==0?1:HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays} days':
                    '${HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays==0?1:HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays} ايام',
                      style: TextStyle(color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.bold, fontSize: 16
                      ),),
                    Text(
                      '${HotelsCubit.get(context).endDate.difference(HotelsCubit.get(context).startDate).inDays==0?DateFormat('dd/MM/yyyy').format(HotelsCubit.get(context).startDate):'${'${DateFormat('dd/MM/yyyy').format(HotelsCubit.get(context).startDate)}' ' : ' '${DateFormat('dd/MM/yyyy').format(HotelsCubit.get(context).endDate)}'}' }',
                      style: TextStyle(color: Colors.grey,
                          fontWeight: FontWeight.bold, fontSize: 12
                      ),),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                      '${widget.hotel.tax!} \%',
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
                                child:   Text(
                                  CacheData.lang==CacheHelperKeys.keyEN?'Price for single room':'سعر غرفة لشخص',
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
                                      '${widget.hotel.singlePrice} \$',
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

                          if(hasDouble)
                            Divider(),
                          if(hasDouble)
                            Row(
                              children:
                              [
                                Expanded(
                                  flex: 2,
                                  child:   Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for double room':'سعر غرفة لشخصين',
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
                                        '${widget.hotel.doublePrice} \$',
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
                                  child:   Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for triple room':'سعر غرفة لثلاثة اشخاص',
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
                                        '${widget.hotel.triplePrice} \$',
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
                                  child:  Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for a child without bed':'السعر لطفل بدون سرير',
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
                                        '${widget.hotel.childNoBedPrice} \$',
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
                                  child:  Text(
                                    CacheData.lang==CacheHelperKeys.keyEN?'Price for a child with bed':'السعر لطفل بسرير',
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
                                        '${widget.hotel.childWithBedPrice} \$',
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
                    ),
                    SizedBox(height: 10,),

                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}