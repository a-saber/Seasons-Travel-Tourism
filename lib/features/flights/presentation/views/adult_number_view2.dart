import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/default_form_field.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';
import 'package:seasons/features/flights/data/models/flight_model.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_cubit.dart';
import 'package:seasons/features/flights/presentation/views/flight_passenger_data.dart';


class AdultNumberView2 extends StatefulWidget {
  const AdultNumberView2({Key? key, this.flightModel, this.fromOffer = false, required this.adults, required this.infants, required this.kids}) : super(key: key);

  final FlightModel? flightModel ;
  final bool fromOffer ;
  final int adults ;
  final int infants ;
  final int kids ;
  @override
  State<AdultNumberView2> createState() => _AdultNumberView2State();
}


class _AdultNumberView2State extends State<AdultNumberView2> {
  int adults = 1;
  int infants = 0;
  int kids = 0;
  int total=1;
  @override
  void initState() {
    adults = widget.adults;
    infants = widget.infants;
    kids = widget.kids;
    total = adults+infants+kids;
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    total = adults+infants+kids;
    return BasicView2(
        appbarTitle: TranslationKeyManager.passengers.tr,
        action:  IconButton(onPressed: ()
        {
          if(widget.fromOffer)
          {
            Get.to(()=>FlightPassengerData2(
              flightModel: widget.flightModel!,
                adults: adults, infants: infants, kids: kids
            ));
          }
          else {
            FlightsCubit.get(context).passengersSetter(
                adults: adults, infants: infants, kids: kids);
            Navigator.pop(context);
          }

        }, icon: Icon(Icons.check,color: Colors.white,)),
        button: SizedBox(),
        children:
        [
          Divider(
            color: Colors.amber,
            height: 2,
            thickness: 2,
          ),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:
              [

                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.only(right: 20, left: 20,top: 20, bottom: 20),
                  child: Row(
                    children:
                    [
                      Icon(Icons.man),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(CacheData.lang == CacheHelperKeys.keyEN?'Adults':'البالغين', style: TextStyle(height: 1.2,color: Colors.black,),),
                          SizedBox(height: 5,),
                          Text('12+ ${CacheData.lang == CacheHelperKeys.keyEN?'years':'سنة'}', style: TextStyle(color: Colors.grey,height: 1.2,),),
                        ],
                      ),
                      Spacer(),
                      if(adults>1)
                        ActiveIconBody(
                          onTap: ()
                          {
                            setState(() {
                              adults--;
                              // adultsNames.removeLast();
                            });
                          },
                          child: Icon(Icons.remove, size: 15, color: Colors.white,),
                        ),

                      if(adults<=1)
                        InActiveIconBody(
                          child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                        ),

                      SizedBox(width: 10,),
                      Text('${adults}'),
                      SizedBox(width: 10,),


                      adults<10 && total <10?
                      ActiveIconBody(
                        onTap: ()
                        {
                          setState(() {
                            adults++;
                            //   adultsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
                          });
                        },
                        child: Icon(Icons.add, size: 15, color: Colors.white,),
                      ):

                      //if(adults==10)
                      InActiveIconBody(
                        child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                      ),

                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.only(right: 20, left: 20,top: 20, bottom: 20),
                  child: Row(
                    children:
                    [
                      Icon(Icons.child_care),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(CacheData.lang == CacheHelperKeys.keyEN?'Children':'الاطفال', style: TextStyle(height: 1.2,color: Colors.black,),),
                          SizedBox(height: 5,),
                          Text('2-11 ${CacheData.lang == CacheHelperKeys.keyEN?'years':'سنة'}', style: TextStyle(color: Colors.grey,height: 1.2,),),
                        ],
                      ),
                      Spacer(),

                      if(kids>0)
                        ActiveIconBody(
                          onTap: ()
                          {
                            setState(() {
                              kids--;
                              //childrenNames.removeLast();
                            });
                          },
                          child: Icon(Icons.remove, size: 15, color: Colors.white,),
                        ),

                      if(kids<=0)
                        InActiveIconBody(
                          child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                        ),

                      SizedBox(width: 10,),
                      Text('${kids}'),
                      SizedBox(width: 10,),


                      (kids<10&& total <10)?
                      ActiveIconBody(
                        onTap: ()
                        {
                          setState(() {
                            kids++;
                            //childrenNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
                          });
                        },
                        child: Icon(Icons.add, size: 15, color: Colors.white,),
                      ):

                      InActiveIconBody(
                        child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                      ),

                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.only(right: 20, left: 20,top: 20, bottom: 20),
                  child: Row(
                    children:
                    [
                      Icon(Icons.baby_changing_station),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${CacheData.lang == CacheHelperKeys.keyEN?'Infants':'الرضع'}', style: TextStyle(color: Colors.black,height: 1.2,),),
                          SizedBox(height: 5,),
                          Text('0-2 ${CacheData.lang == CacheHelperKeys.keyEN?'years':'سنة'}', style: TextStyle(height: 1.2,color: Colors.grey,),),
                        ],
                      ),
                      Spacer(),

                      if(infants>0)
                        ActiveIconBody(
                          onTap: ()
                          {
                            setState(() {
                              infants--;
                              //    infantsNames.removeLast();
                            });
                          },
                          child: Icon(Icons.remove, size: 15, color: Colors.white,),
                        ),

                      if(infants<=0)
                        InActiveIconBody(
                          child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                        ),

                      SizedBox(width: 10,),
                      Text('${infants}'),
                      SizedBox(width: 10,),


                      (infants<10&& total <10 )?
                      ActiveIconBody(
                        onTap: ()
                        {
                          setState(() {
                            infants++;
                            //infantsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
                          });
                        },
                        child: Icon(Icons.add, size: 15, color: Colors.white,),
                      ):

                      InActiveIconBody(
                        child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                      ),

                    ],
                  ),
                ),

                // SizedBox(height: 15,),
                // Divider(color: Colors.amber, height: 0,thickness: 2),
                // Container(
                //   //height: 300,
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(20)
                //   ),
                //   margin: EdgeInsets.symmetric(horizontal: 20),
                //   padding: EdgeInsets.only(right: 20, left: 20,top: 20, bottom: 20),
                //   //color: Colors.white,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children:
                //     [
                //       SizedBox(height: 15,),
                //       Row(
                //         children:
                //         [
                //           Icon(Icons.man),
                //           SizedBox(width: 10,),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(CacheData.lang == CacheHelperKeys.keyEN?'Adults':'البالغين', style: TextStyle(height: 1.2,color: Colors.black,),),
                //               SizedBox(height: 5,),
                //               Text('12+ ${CacheData.lang == CacheHelperKeys.keyEN?'years':'سنة'}', style: TextStyle(color: Colors.grey,height: 1.2,),),
                //             ],
                //           ),
                //           Spacer(),
                //           if(adults>1)
                //             ActiveIconBody(
                //               onTap: ()
                //               {
                //                 setState(() {
                //                   adults--;
                //                   // adultsNames.removeLast();
                //                 });
                //               },
                //               child: Icon(Icons.remove, size: 15, color: Colors.white,),
                //             ),
                //
                //           if(adults<=1)
                //             InActiveIconBody(
                //               child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                //             ),
                //
                //           SizedBox(width: 10,),
                //           Text('${adults}'),
                //           SizedBox(width: 10,),
                //
                //
                //           adults<10 && total <10?
                //           ActiveIconBody(
                //             onTap: ()
                //             {
                //               setState(() {
                //                 adults++;
                //                 //   adultsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
                //               });
                //             },
                //             child: Icon(Icons.add, size: 15, color: Colors.white,),
                //           ):
                //
                //           //if(adults==10)
                //           InActiveIconBody(
                //             child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                //           ),
                //
                //         ],
                //       ),
                //       Divider(),
                //       SizedBox(height: 15,),
                //       Row(
                //         children:
                //         [
                //           Icon(Icons.child_care),
                //           SizedBox(width: 10,),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(CacheData.lang == CacheHelperKeys.keyEN?'Children':'الاطفال', style: TextStyle(height: 1.2,color: Colors.black,),),
                //               SizedBox(height: 5,),
                //               Text('2-11 ${CacheData.lang == CacheHelperKeys.keyEN?'years':'سنة'}', style: TextStyle(color: Colors.grey,height: 1.2,),),
                //             ],
                //           ),
                //           Spacer(),
                //
                //           if(kids>0)
                //             ActiveIconBody(
                //               onTap: ()
                //               {
                //                 setState(() {
                //                   kids--;
                //                   //childrenNames.removeLast();
                //                 });
                //               },
                //               child: Icon(Icons.remove, size: 15, color: Colors.white,),
                //             ),
                //
                //           if(kids<=0)
                //             InActiveIconBody(
                //               child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                //             ),
                //
                //           SizedBox(width: 10,),
                //           Text('${kids}'),
                //           SizedBox(width: 10,),
                //
                //
                //           (kids<10&& total <10)?
                //           ActiveIconBody(
                //             onTap: ()
                //             {
                //               setState(() {
                //                 kids++;
                //                 //childrenNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
                //               });
                //             },
                //             child: Icon(Icons.add, size: 15, color: Colors.white,),
                //           ):
                //
                //           InActiveIconBody(
                //             child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                //           ),
                //
                //         ],
                //       ),
                //       Divider(),
                //       SizedBox(height: 10,),
                //       Row(
                //         children:
                //         [
                //           Icon(Icons.baby_changing_station),
                //           SizedBox(width: 10,),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text('${CacheData.lang == CacheHelperKeys.keyEN?'Infants':'الرضع'}', style: TextStyle(color: Colors.black,height: 1.2,),),
                //               SizedBox(height: 5,),
                //               Text('0-2 ${CacheData.lang == CacheHelperKeys.keyEN?'years':'سنة'}', style: TextStyle(height: 1.2,color: Colors.grey,),),
                //             ],
                //           ),
                //           Spacer(),
                //
                //           if(infants>0)
                //             ActiveIconBody(
                //               onTap: ()
                //               {
                //                 setState(() {
                //                   infants--;
                //                   //    infantsNames.removeLast();
                //                 });
                //               },
                //               child: Icon(Icons.remove, size: 15, color: Colors.white,),
                //             ),
                //
                //           if(infants<=0)
                //             InActiveIconBody(
                //               child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                //             ),
                //
                //           SizedBox(width: 10,),
                //           Text('${infants}'),
                //           SizedBox(width: 10,),
                //
                //
                //           (infants<10&& total <10 )?
                //           ActiveIconBody(
                //             onTap: ()
                //             {
                //               setState(() {
                //                 infants++;
                //                 //infantsNames.add(PersonName(first: TextEditingController(), last: TextEditingController()));
                //               });
                //             },
                //             child: Icon(Icons.add, size: 15, color: Colors.white,),
                //           ):
                //
                //           InActiveIconBody(
                //             child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                //           ),
                //
                //         ],
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(top: 8.0),
                //         child: Divider(height: 0,),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        ]
    );
  }
}

/*
// SizedBox(height: 20,),
                // Divider(color: Colors.amber, height: 0,thickness: 2),
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.only(right: 20, left: 20,top: 20),
                //   color: Colors.white,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children:
                //     [
                //       Text('Class',
                //         style: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.bold),
                //       ),
                //       SizedBox(height: 15,),
                //       ListView.separated(
                //         shrinkWrap: true,
                //           physics: NeverScrollableScrollPhysics(),
                //           itemBuilder: (context, index)=> InkWell(
                //             onTap: ()
                //             {
                //               setState(() {
                //                 chosenIndex = index;
                //               });
                //             },
                //             child: Row(
                //               children: [
                //                 Text(classTypes[index]),
                //                 Spacer(),
                //                 if(chosenIndex == index)
                //                 Icon(Icons.check,color: ColorsManager.primaryColor)
                //               ],
                //             ),
                //           ),
                //           separatorBuilder: (context, index)=>Divider(),
                //           itemCount: 4
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(top: 8.0),
                //         child: Divider(height: 0,),
                //       )
                //     ],
                //   ),
                // )
 */

/*
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
                          Text('${CacheData.lang == CacheHelperKeys.keyEN?'Adults':'البالغين'} ${index+2}' ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Expanded(child: DefaultFormField(controller: adultsNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
                              SizedBox(width: 20,),
                              Expanded(child: DefaultFormField(controller: adultsNames[index].last, hint: TranslationKeyManager.lastName.tr,)),
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
                              Expanded(child: DefaultFormField(controller: childrenNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
                              SizedBox(width: 20,),
                              Expanded(child: DefaultFormField(controller: childrenNames[index].last, hint: TranslationKeyManager.lastName.tr,)),
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
                              Expanded(child: DefaultFormField(controller: infantsNames[index].first, hint: TranslationKeyManager.firstName.tr,)),
                              SizedBox(width: 20,),
                              Expanded(child: DefaultFormField(controller: infantsNames[index].last, hint: TranslationKeyManager.lastName.tr,)),
                            ],
                          )
                        ],
                      ),
                      separatorBuilder: (context, index)=> SizedBox(height: 10,),
                      itemCount: infantsNames.length
                  ),
                )
 */


class ActiveIconBody extends StatelessWidget {
  const ActiveIconBody({Key? key, required this.child, required this.onTap}) : super(key: key);

  final Widget child;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: ColorsManager.primaryColor,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: EdgeInsets.all(3),
        child: child,
      ),
    );
  }
}

class InActiveIconBody extends StatelessWidget {
  const InActiveIconBody({Key? key, required this.child}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: ColorsManager.iconColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: EdgeInsets.all(3),
      child: child,
    );
  }
}
