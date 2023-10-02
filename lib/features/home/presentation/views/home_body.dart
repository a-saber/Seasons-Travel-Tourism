import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/assets_manager.dart';
import 'package:seasons/features/airports/cubit/airports_cubit.dart';
import 'package:seasons/features/cars/presentation/views/cars_search_view.dart';
import 'package:seasons/features/flights/presentation/cubit/flights_cubit.dart';
import 'package:seasons/features/flights/presentation/views/adult_number_view2.dart';
import 'package:seasons/features/flights/presentation/views/flights_view.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/home/cubit/home_states.dart';
import 'package:seasons/features/home/data/slider_model.dart';
import 'package:seasons/features/hotels/presentation/cubit/hotel_cubit/hotel_cubit.dart';
import 'package:seasons/features/programs_view/presentation/cubit/programs_cubit.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_cubit.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_states.dart';
import 'package:seasons/features/train/presentation/train_cubit/train_cubit.dart';
import 'package:seasons/features/train/presentation/train_cubit/train_states.dart';
import 'package:seasons/features/train/presentation/views/train_view.dart';

import '../../../../core/core_widgets/default_app_bar.dart';
import '../../../../core/resources_manager/colors_manager.dart';
import '../../../cars/presentation/views/cars_view.dart';
import '../../../flights/presentation/views/choose_destination_view1.dart';
import '../../../hotels/presentation/views/hotels_view2.dart';
import '../../../programs_view/presentation/views/programs_view.dart';
import 'main_home_view.dart';

class HomeBody extends StatelessWidget {
   HomeBody({Key? key}) : super(key: key);
   final List<FeatureBuilder> features = [
     FeatureBuilder(
         icon: Transform.rotate(
             angle: pi * 0.3,
             child:
             // FaIcon(
             //     FontAwesomeIcons.planeUp,
                 Icon(Icons.airplanemode_active,
                 color: Colors.white)),
         title: TranslationKeyManager.bottomNavFlight.tr,
         view: ChooseDestinationView1()),

     FeatureBuilder(
         icon:
         // FaIcon(
         //   FontAwesomeIcons.hotel,
           Icon(
           Icons.king_bed_sharp,
           color: Colors.white,
         ),
         title: TranslationKeyManager.bottomNavHotels.tr,
         view: HotelsView2()),

     FeatureBuilder(
         icon:
         //FaIcon(FontAwesomeIcons.map,

         Stack(
           alignment: AlignmentDirectional.center,
           children: [
             Icon(Icons.directions_car_sharp,
                 color: Colors.white),
             Padding(
               padding: const EdgeInsetsDirectional.only(end: 15.0, top: 8),
               child: Align(
                   alignment: AlignmentDirectional.topEnd,
                   child: Transform.rotate(
                       angle: pi * 0.5,
                       child: Icon(Icons.airplanemode_active,
                           size: 12, color: Colors.white))),
             ),
             Icon(Icons.bed, color: Colors.white),
           ],
         ),
         title: TranslationKeyManager.bottomNavTourism.tr,
         view: ProgramsView()),

     FeatureBuilder(
         icon:
        // FaIcon(FontAwesomeIcons.car,
              Icon(Icons.directions_car_sharp,
             color: Colors.white),
         title: TranslationKeyManager.cars.tr,
         view: CarsView()),

     FeatureBuilder(
         icon:
         // FaIcon(FontAwesomeIcons.car,
         Icon(Icons.directions_train,
             color: Colors.white),
         title: CacheData.lang == CacheHelperKeys.keyEN ? 'Trains' : 'قطارات' ,
         view: TrainView()),

   ];

   List<String> images2 = [
     'https://img.traveltriangle.com/blog/wp-content/uploads/2023/06/PTV-India-Cover-Final.png',
     'https://ihplb.b-cdn.net/wp-content/uploads/2021/11/izmir-750x430.jpg',
     'https://img.traveltriangle.com/blog/wp-content/uploads/2020/03/Places-To-Visit-In-Turkey-_7th-jun.jpg'
   ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BlocListener<TrainCubit, TrainStates>(
          listener: (context, state)
          {
            // if(state is TrainProgressEndState)
            //   TrainCubit.get(context).move();
            Get.to(()=>TrainView());
          },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: ColorsManager.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Center(
                child: Text(
                  TranslationKeyManager.allNeed.tr,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  for (int i = 0; i < features.length; i++)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (i == 0)
                          {
                            AirportsCubit.get(context).getAirports();
                            FlightsCubit.get(context).getFlights();
                            Get.to(() => FlightsView());
                            //AirportsCubit.get(context).getAirports();
                          }
                          else if (i == 1)
                          {
                            ProgramsCubit.get(context).getCountries(
                                allowGroup: false).then((value) =>
                                ProgramsCubit.get(context).getCities( allowGroup : false));
                            Get.to(() => HotelsView2());
                          }
                          else if (i == 2)
                          {
                            ProgramsCubit.get(context).getCountries().then((
                                value) =>
                                ProgramsCubit.get(context).getCities());
                            ProgramsCubit.get(context).getPrograms();
                            Get.to(() => ProgramsView());
                          }
                          else if (i == 3)
                          {
                            ProgramsCubit.get(context).getCountries(
                                allowGroup: false);
                            Get.to(() => CarSearchView());
                          }
                          else if (i == 4)
                          {
                            TrainCubit.get(context).initController();
                            //Get.to(() => TrainView());
                          }

                        },
                        child: Column(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                  //i == 1
                                  //  ? Colors.amber
                                  //     :
                                  Colors.blue.shade800,
                                  radius: (false&&i == 1) ? 31 : 30,
                                  child: CircleAvatar(
                                    radius: 30,
                                    // backgroundColor: Colors.black.withOpacity(0.2),
                                    backgroundColor: Color(0xff004a89),
                                    child: features[i].icon,
                                  ),
                                ),
                                if (false&&i == 1)
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.amber,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 0.5),
                                    child: Text(
                                      'Save on',
                                      style: TextStyle(
                                          height: 1.2,
                                          fontSize: 12,
                                          color: Color(0xff0f39a9),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                                height: 30,
                                child: Text(
                                  features[i].title,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontWeight: FontWeight.w600,
                                    color: (false&&i == 1) ? Colors.amber : Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),),

        //Expanded(child: Center(child: CarouselSliderDataFound())),

        BlocConsumer<SliderCubit, SliderStates>(
          listener: (context, state){},
          builder: (context, state)
            {
              if(state is SliderGetLoadingState)
              {
                return Expanded(child: Center(child: CircularProgressIndicator(),));
              }
              else if (state is SliderGetErrorState)
              {
                return Expanded(child: Center(child: Text(state.error, textAlign: TextAlign.center,),));
              }
              else if(SliderCubit.get(context).sliders.isEmpty)
              {
                return Expanded(child: Center(child: Text('Sorry, there are no offers now\nstay tuned',textAlign: TextAlign.center,),));
              }
              else if(state is SliderGetSuccessState)
              {
                return Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: SliderCubit.get(context).sliders.length,
                        itemBuilder: (context, index)=> InkWell(
                          onTap: ()
                          {
                            switch(SliderCubit.get(context).sliders[index].sliderType)
                            {
                              case SliderTypes.flight:
                              {
                                Get.to(()=> AdultNumberView2(
                                  flightModel: SliderCubit.get(context).sliders[index].flightModel,
                                  fromOffer: true,
                                  adults: 1,
                                  infants: 0,
                                  kids: 0,
                                ));
                                break;
                              }
                              case SliderTypes.program:
                              {
                                break;
                              }
                              case SliderTypes.hotel:
                              {
                                break;
                              }
                              case SliderTypes.car:
                              {
                                break;
                              }
                              default :
                              {
                                break;
                              }
                            }
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                        imageBuilder: (BuildContext, ImageProvider<Object> provider)
                                        {
                                          return Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(image: provider, fit: BoxFit.fill)
                                            ),
                                          );
                                        },
                                        placeholder: (context, error) =>SizedBox(
                                            height: 120,
                                            child: Center(child: CircularProgressIndicator())),
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            SizedBox(
                                              height: 120,
                                              child: Center(
                                                child: FaIcon(
                                                    FontAwesomeIcons.image,
                                                    size: 35,
                                                    color: ColorsManager.primaryColor),
                                              ),
                                            ),

                                        // const Icon(
                                        //   Icons.image_outlined,
                                        //   color: Colors.grey,
                                        // ),
                                        imageUrl: 'https://api.seasonsge.com/${SliderCubit.get(context).sliders[index].imagePath!}'),
                                    Stack(
                                      alignment: AlignmentDirectional.bottomStart,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: AlignmentDirectional.bottomCenter,
                                                  end: AlignmentDirectional.center,
                                                  colors:
                                                  [
                                                    Colors.black,
                                                    Colors.black,
                                                    Colors.black,
                                                    Colors.black.withOpacity(0.2),
                                                    Colors.black.withOpacity(0.2),
                                                    Colors.black.withOpacity(0.2),
                                                  ])
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(end: 40, start: 20, bottom: 15),
                                          child: Text(
                                            SliderCubit.get(context).sliders[index].text!.capitalize!,
                                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                                color: Colors.white,
                                thickness: 1.5,
                              )
                            ],
                          ),
                        )
                    )
                );
              }
              else
              {
                return SizedBox();
              }
            },
        ),
      ],
    );
  }
}



class HomeItemBuilder extends StatelessWidget {
  const HomeItemBuilder({super.key,
  required this.title,
  required this.icon,
  required this.onTap,
  required this.color,
  });
  final String title;
  final IconData icon;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            //color: Color(0xff9e98d5),
            //color: ColorsManager.primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              FaIcon(
                  icon,
                  size: 35,
                  color: Colors.white),
              SizedBox(height: 10,),
              Text(
                title,
                style: TextStyle(
                  height: 1.2,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color:  Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// class CarouselSliderDataFound extends StatefulWidget {
//   const CarouselSliderDataFound();
//
//   @override
//   _CarouselSliderDataFoundState createState() => _CarouselSliderDataFoundState();
// }
//
// class _CarouselSliderDataFoundState extends State<CarouselSliderDataFound> {
//   int _current = 0;
//   List<Widget>? imageSlider;
//   List<String> images = [
//     'https://img.traveltriangle.com/blog/wp-content/uploads/2023/06/PTV-India-Cover-Final.png',
//     'https://ihplb.b-cdn.net/wp-content/uploads/2021/11/izmir-750x430.jpg',
//     'https://img.traveltriangle.com/blog/wp-content/uploads/2020/03/Places-To-Visit-In-Turkey-_7th-jun.jpg'
//   ];
//
//   @override
//   void initState() {
//     imageSlider = images.map((e) => Container(
//       width: double.infinity,
//       height: double.infinity,
//       child: CachedNetworkImage(
//         imageUrl: e,
//         errorWidget: (context, url, error) =>
//             Icon(Icons.error),
//         progressIndicatorBuilder: (context, url, downloadProgress) =>
//             Center(
//               child: CircularProgressIndicator(
//                 value: downloadProgress.progress,
//               ),
//             ),
//         fit: BoxFit.fill,
//         width: double.infinity,
//         height: double.infinity,
//
//       ),
//     )).toList();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       width: double.infinity,
//       height: double.infinity,
//       //height: MediaQuery.of(context).size.height*0.45,
//       child: CarouselSlider(
//
//           items: imageSlider,
//           options: CarouselOptions(
//             height: double.infinity,
//             //scrollDirection: Axis.vertical,
//               autoPlay: true,
//               enlargeCenterPage: false,
//               //aspectRatio: 1/1.2,
//               viewportFraction: 1,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _current = index;
//                 });
//               }
//           )),
//     );
//   }
// }
//



// class HomeItemBuilder2 extends StatelessWidget {
//   const HomeItemBuilder2({super.key,
//     required this.title,
//     required this.image,
//     required this.icon,
//     required this.onTap,
//   });
//   final String title;
//   final String image;
//   final void Function()? onTap;
// final IconData icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: onTap,
//         child: Material(
//           elevation: 3,
//           borderRadius: BorderRadius.circular(15),
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   CachedNetworkImage(
//                       imageBuilder: (BuildContext, ImageProvider<Object> provider)
//                       {
//                         return   Container(
//                           height: 120,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(image: provider,fit: BoxFit.fill),
//                             //color: Color(0xff9e98d5),
//                             //color: ColorsManager.primaryColor,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(15),
//                               topRight: Radius.circular(15),
//                             ),
//                           ),
//                           //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                         );
//                       },
//                       placeholder: (context, error) =>SizedBox(
//                           height: 120,
//                           child: Center(child: CircularProgressIndicator())),
//                       // const Icon(
//                       //   Icons.image_outlined,
//                       //   color: Colors.grey,
//                       // ),
//                       fit: BoxFit.cover,
//                       errorWidget: (context, url, error) =>
//                           SizedBox(
//                             height: 120,
//                             child: Center(
//                               child: FaIcon(
//                                   icon,
//                                   size: 35,
//                                   color: ColorsManager.primaryColor),
//                             ),
//                           ),
//
//                       // const Icon(
//                       //   Icons.image_outlined,
//                       //   color: Colors.grey,
//                       // ),
//                       imageUrl: image),
//                   // Container(
//                   //   height: 120,
//                   //   decoration: BoxDecoration(
//                   //     image: DecorationImage(image: AssetImage(image),fit: BoxFit.fill),
//                   //     //color: Color(0xff9e98d5),
//                   //     //color: ColorsManager.primaryColor,
//                   //     borderRadius: BorderRadius.only(
//                   //       topLeft: Radius.circular(15),
//                   //       topRight: Radius.circular(15),
//                   //     ),
//                   //   ),
//                   //   //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   // ),
//                   Container(
//                     height: 120,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.25),
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(15),
//                           topRight: Radius.circular(15),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Stack(
//                 children: [
//                   Container(
//                     height: 29,
//                     width: double.infinity,
//                     padding: EdgeInsets.only(bottom: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(15),
//                         bottomLeft: Radius.circular(15),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.only(bottom: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.withOpacity(0.25),
//                       borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(15),
//                         bottomLeft: Radius.circular(15),
//                       ),
//                     ),
//                     child: Text(
//                       title,
//                       style: TextStyle(
//                         height: 1.2,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color:  ColorsManager.primaryColor,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
