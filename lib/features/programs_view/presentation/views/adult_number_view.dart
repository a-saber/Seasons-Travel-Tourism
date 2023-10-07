import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/programs_view/data/models/program_model.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_cubit.dart';

import 'program_dates_search.dart';
import 'programs_passenger_data.dart';

class RoomData
{
  int adults ;
  int kidsWithNoBed ;
  int kidsWithBed ;
  int infants ;

  RoomData({this.adults = 1, this.kidsWithNoBed=0, this.kidsWithBed=0,this.infants=0});
}

class AdultNumberView extends StatefulWidget {
  const AdultNumberView({Key? key, required this.roomsData}) : super(key: key);
  final List<RoomData> roomsData ;

  @override
  State<AdultNumberView> createState() => _AdultNumberViewState();
}

class _AdultNumberViewState extends State<AdultNumberView> {
  int adults =0;
  List<RoomData> roomsData=[] ;
  @override
  void initState() {
    widget.roomsData.forEach((element)
    {
      adults+=element.adults;
      roomsData.add(RoomData(adults: element.adults, kidsWithNoBed: element.kidsWithNoBed, kidsWithBed: element.kidsWithBed, infants: element.infants));
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, text: CacheData.lang == CacheHelperKeys.keyEN?'Rooms Details':'تفاصيل الغرف',
          action: IconButton(
              onPressed: ()
              {
                ProgramsCubit.get(context).roomsDataSetter(roomsData);
                Navigator.pop(context);
              }, icon: Icon(Icons.check))),
      body: SafeArea(
        child: Column(
          children:
          [
            Expanded(
              child: ListView.builder(
                  itemCount: roomsData.length,
                  itemBuilder: (context, index)=>
                      Column(
                        children: [
                          Divider(
                            color: Colors.amber,
                            height: 2,
                            thickness: 2,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            margin: EdgeInsets.only(bottom: 15),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              [
                                Row(
                                  children: [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Room':'غرفة'} ${index+1}',
                                      style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    if(index!=0)
                                    IconButton(onPressed: ()
                                    {
                                      setState(() {
                                        adults-=roomsData[index].adults;
                                        roomsData.removeAt(index);
                                      });
                                    }, icon: Icon(Icons.close, color: ColorsManager.iconColor))
                                  ],
                                ),
                                Divider(),
                                SizedBox(height: 10,),
                                Row(
                                  children:
                                  [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Adults':'بالغين'} (+12)', style: TextStyle(color: Colors.black,),),
                                    Spacer(),

                                    if(roomsData[index].adults>1)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].adults--;
                                            adults--;
                                          });
                                        },
                                        child: Icon(Icons.remove, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].adults<=1)
                                      InActiveIconBody(
                                        child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                    SizedBox(width: 10,),
                                    Text('${roomsData[index].adults}'),
                                    SizedBox(width: 10,),


                                    if(roomsData[index].adults<3&& adults<10)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].adults++;
                                            adults++;
                                          });
                                        },
                                        child: Icon(Icons.add, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].adults==3|| adults==10)
                                      InActiveIconBody(
                                        child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children:
                                  [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Children With Bed':'اطفال بسرير'} (2-11)', style: TextStyle(color: Colors.black,),),
                                    Spacer(),

                                    if(roomsData[index].kidsWithBed>0)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].kidsWithBed--;
                                          });
                                        },
                                        child: Icon(Icons.remove, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].kidsWithBed<=0)
                                      InActiveIconBody(
                                        child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                    SizedBox(width: 10,),
                                    Text('${roomsData[index].kidsWithBed}'),
                                    SizedBox(width: 10,),


                                    (roomsData[index].kidsWithBed + roomsData[index].kidsWithNoBed < 3)?
                                    ActiveIconBody(
                                      onTap: ()
                                      {
                                        setState(() {
                                          roomsData[index].kidsWithBed++;
                                        });
                                      },
                                      child: Icon(Icons.add, size: 15, color: ColorsManager.primaryColor,),
                                    ):

                                    InActiveIconBody(
                                      child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children:
                                  [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Children without bed':'اطفال بدون سرير'} (2-11)', style: TextStyle(color: Colors.black,),),
                                    Spacer(),

                                    if(roomsData[index].kidsWithNoBed>0)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].kidsWithNoBed--;
                                          });
                                        },
                                        child: Icon(Icons.remove, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].kidsWithNoBed<=0)
                                      InActiveIconBody(
                                        child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                    SizedBox(width: 10,),
                                    Text('${roomsData[index].kidsWithNoBed}'),
                                    SizedBox(width: 10,),


                                    (roomsData[index].kidsWithBed + roomsData[index].kidsWithNoBed <3 )?
                                    ActiveIconBody(
                                      onTap: ()
                                      {
                                        setState(() {
                                          roomsData[index].kidsWithNoBed++;
                                        });
                                      },
                                      child: Icon(Icons.add, size: 15, color: ColorsManager.primaryColor,),
                                    ):

                                    InActiveIconBody(
                                      child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children:
                                  [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Infants':'رضع'} (0-2)', style: TextStyle(color: Colors.black,),),
                                    Spacer(),

                                    if(roomsData[index].infants>0)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].infants--;
                                          });
                                        },
                                        child: Icon(Icons.remove, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].infants<=0)
                                      InActiveIconBody(
                                        child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                    SizedBox(width: 10,),
                                    Text('${roomsData[index].infants}'),
                                    SizedBox(width: 10,),


                                    (roomsData[index].infants<3)?
                                    ActiveIconBody(
                                      onTap: ()
                                      {
                                        setState(() {
                                          roomsData[index].infants++;
                                        });
                                      },
                                      child: Icon(Icons.add, size: 15, color: ColorsManager.primaryColor,),
                                    ):

                                    InActiveIconBody(
                                      child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 10,),



                                Divider(),
                                if(index == roomsData.length-1&& adults <10)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        setState(() {
                                          adults++;
                                          roomsData.add(RoomData());
                                        });
                                      },
                                      child: Row(
                                        children:
                                        [
                                          Icon(Icons.add, color: ColorsManager.primaryColor,size: 18,),
                                          SizedBox(width: 15,),
                                          Text(
                                            CacheData.lang == CacheHelperKeys.keyEN?
                                            'Add a room':
                                            'إضافة غرفة',
                                            style: TextStyle(color: ColorsManager.primaryColor),)
                                        ],
                                      ),
                                    ),
                                  )



                              ],
                            ),
                          ),
                        ],
                      )
              ),
            ),



          ],
        ),
      ),
    );
  }
}


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
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(3),
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
        color: Colors.grey.withOpacity(0.25),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      padding: EdgeInsets.all(3),
      child: child,
    );
  }
}



class AdultNumberView3 extends StatefulWidget {
  const AdultNumberView3({Key? key, required this.roomsData, required this.programModel}) : super(key: key);
  final List<RoomData> roomsData ;
  final ProgramModel programModel;

  @override
  State<AdultNumberView3> createState() => _AdultNumberView3State();
}

class _AdultNumberView3State extends State<AdultNumberView3> {
  int adults =0;
  List<RoomData> roomsData=[] ;
  @override
  void initState() {
    widget.roomsData.forEach((element)
    {
      adults+=element.adults;
      roomsData.add(RoomData(adults: element.adults, kidsWithNoBed: element.kidsWithNoBed, kidsWithBed: element.kidsWithBed, infants: element.infants));
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, text: CacheData.lang == CacheHelperKeys.keyEN?'Rooms Details':'تفاصيل الغرف',
          action: IconButton(
              onPressed: ()
              {
                ProgramsCubit.get(context).roomsDataSetterSearch(roomsData);
                Get.to(()=>ProgramPassengerData2(
                    programModel: widget.programModel
                ));
               // Get.to(()=>ProgramSearchDates(programModel: widget.programModel,));
                //Navigator.pop(context);
              }, icon: Icon(Icons.check))),
      body: SafeArea(
        child: Column(
          children:
          [
            Expanded(
              child: ListView.builder(
                  itemCount: roomsData.length,
                  itemBuilder: (context, index)=>
                      Column(
                        children: [
                          Divider(
                            color: Colors.amber,
                            height: 2,
                            thickness: 2,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            margin: EdgeInsets.only(bottom: 15),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              [
                                Row(
                                  children: [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Room':'غرفة'} ${index+1}',
                                      style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    if(index!=0)
                                      IconButton(onPressed: ()
                                      {
                                        setState(() {
                                          adults-=roomsData[index].adults;
                                          roomsData.removeAt(index);
                                        });
                                      }, icon: Icon(Icons.close, color: ColorsManager.iconColor))
                                  ],
                                ),
                                Divider(),
                                SizedBox(height: 10,),
                                Row(
                                  children:
                                  [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Adults':'بالغين'} (+12)', style: TextStyle(color: Colors.black,),),
                                    Spacer(),

                                    if(roomsData[index].adults>1)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].adults--;
                                            adults--;
                                          });
                                        },
                                        child: Icon(Icons.remove, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].adults<=1)
                                      InActiveIconBody(
                                        child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                    SizedBox(width: 10,),
                                    Text('${roomsData[index].adults}'),
                                    SizedBox(width: 10,),


                                    if(roomsData[index].adults<3&& adults<10)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].adults++;
                                            adults++;
                                          });
                                        },
                                        child: Icon(Icons.add, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].adults==3|| adults==10)
                                      InActiveIconBody(
                                        child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children:
                                  [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Children With Bed':'اطفال بسرير'} (2-11)', style: TextStyle(color: Colors.black,),),
                                    Spacer(),

                                    if(roomsData[index].kidsWithBed>0)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].kidsWithBed--;
                                          });
                                        },
                                        child: Icon(Icons.remove, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].kidsWithBed<=0)
                                      InActiveIconBody(
                                        child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                    SizedBox(width: 10,),
                                    Text('${roomsData[index].kidsWithBed}'),
                                    SizedBox(width: 10,),


                                    (roomsData[index].kidsWithBed + roomsData[index].kidsWithNoBed < 3)?
                                    ActiveIconBody(
                                      onTap: ()
                                      {
                                        setState(() {
                                          roomsData[index].kidsWithBed++;
                                        });
                                      },
                                      child: Icon(Icons.add, size: 15, color: ColorsManager.primaryColor,),
                                    ):

                                    InActiveIconBody(
                                      child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children:
                                  [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Children without bed':'اطفال بدون سرير'} (2-11)', style: TextStyle(color: Colors.black,),),
                                    Spacer(),

                                    if(roomsData[index].kidsWithNoBed>0)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].kidsWithNoBed--;
                                          });
                                        },
                                        child: Icon(Icons.remove, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].kidsWithNoBed<=0)
                                      InActiveIconBody(
                                        child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                    SizedBox(width: 10,),
                                    Text('${roomsData[index].kidsWithNoBed}'),
                                    SizedBox(width: 10,),


                                    (roomsData[index].kidsWithBed + roomsData[index].kidsWithNoBed <3 )?
                                    ActiveIconBody(
                                      onTap: ()
                                      {
                                        setState(() {
                                          roomsData[index].kidsWithNoBed++;
                                        });
                                      },
                                      child: Icon(Icons.add, size: 15, color: ColorsManager.primaryColor,),
                                    ):

                                    InActiveIconBody(
                                      child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children:
                                  [
                                    Text('${CacheData.lang == CacheHelperKeys.keyEN?'Infants':'رضع'} (0-2)', style: TextStyle(color: Colors.black,),),
                                    Spacer(),

                                    if(roomsData[index].infants>0)
                                      ActiveIconBody(
                                        onTap: ()
                                        {
                                          setState(() {
                                            roomsData[index].infants--;
                                          });
                                        },
                                        child: Icon(Icons.remove, size: 15, color: ColorsManager.primaryColor,),
                                      ),

                                    if(roomsData[index].infants<=0)
                                      InActiveIconBody(
                                        child: Icon(Icons.remove, size: 15, color: Colors.grey.withOpacity(0.4),),
                                      ),

                                    SizedBox(width: 10,),
                                    Text('${roomsData[index].infants}'),
                                    SizedBox(width: 10,),


                                    (roomsData[index].infants<3)?
                                    ActiveIconBody(
                                      onTap: ()
                                      {
                                        setState(() {
                                          roomsData[index].infants++;
                                        });
                                      },
                                      child: Icon(Icons.add, size: 15, color: ColorsManager.primaryColor,),
                                    ):

                                    InActiveIconBody(
                                      child: Icon(Icons.add, size: 15, color: Colors.grey.withOpacity(0.4),),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 10,),



                                Divider(),
                                if(index == roomsData.length-1&& adults <10)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        setState(() {
                                          adults++;
                                          roomsData.add(RoomData());
                                        });
                                      },
                                      child: Row(
                                        children:
                                        [
                                          Icon(Icons.add, color: ColorsManager.primaryColor,size: 18,),
                                          SizedBox(width: 15,),
                                          Text(
                                            CacheData.lang == CacheHelperKeys.keyEN?
                                            'Add a room':
                                            'إضافة غرفة',
                                            style: TextStyle(color: ColorsManager.primaryColor),)
                                        ],
                                      ),
                                    ),
                                  )



                              ],
                            ),
                          ),
                        ],
                      )
              ),
            ),



          ],
        ),
      ),
    );
  }
}

