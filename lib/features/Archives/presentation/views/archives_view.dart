import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/Archives/cubit/archives_cubit.dart';
import 'package:seasons/features/Archives/cubit/archives_state.dart';

import '../../../../core/local_database/cache_data.dart';
import '../../../../core/local_database/cache_helper_keys.dart';
import '../../../sign_in/presentaion/views/archives_web_view.dart';

class ArchivesView extends StatefulWidget {
  const ArchivesView({super.key});

  @override
  State<ArchivesView> createState() => _ArchivesViewState();
}

class _ArchivesViewState extends State<ArchivesView> {
  List<String> namesAR =
  [
    'الطيران',
    'البرامج',
    'الفنادق',
    'السيارات',
  ];
  List<String> namesEN =
  [
    'Flights',
    'Programs',
    'Hotels',
    'Cars',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context: context, text: CacheData.lang == CacheHelperKeys.keyEN? 'Archives':'الارشيف'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children:
          [
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index)=>InkWell(
                  onTap: ()
                  {
                    ArchivesCubit.get(context).tab(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsManager.primaryColor
                    ),
                    height: 200,
                    width: 100,
                    child: Center(
                      child: Text(CacheData.lang == CacheHelperKeys.keyEN? namesEN[index]: namesAR[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
                    ),
                  ),
                ), separatorBuilder: (context, index)=>SizedBox(width: 10,),
                  itemCount: 4
              ),
            ),
            SizedBox(height: 20,),
            BlocConsumer<ArchivesCubit, ArchivesState>(
              listener: (context, state)
              {
                // if(state is ArchivesErrorInitial)
                // {
                // callMySnackBar(context: context, text: state.error);
                // }
              },
              builder: (context, state) {
                print(state.toString());
                if(state is ArchivesLoadingInitial)
                {
                  return Center(child: CircularProgressIndicator());
                }
                // else if(state is ArchivesSuccessInitial) {
                //   return Expanded(
                //       child: ListView.separated(
                //           itemBuilder: (context, index) =>
                //               InkWell(
                //                 onTap: () {},
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(10),
                //                       color: ColorsManager.primaryColor
                //                   ),
                //                   height: 100,
                //                   child: Center(
                //                     child: Text(ArchivesCubit
                //                         .get(context)
                //                         .categories![index],
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(color: Colors.white,
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 17),),
                //                   ),
                //                 ),
                //               ),
                //           separatorBuilder: (context, index) =>
                //               SizedBox(height: 10,),
                //           itemCount: ArchivesCubit
                //               .get(context)
                //               .categories!
                //               .length
                //       )
                //   );
                // }

                return Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) =>
                            InkWell(
                              onTap: ()
                              {
                                print('----------');
                                String url;
                                if(ArchivesCubit.get(context).currentIndex==0)
                                {
                                  url = 'flights';
                                }
                                else if(ArchivesCubit.get(context).currentIndex==1)
                                {
                                  url = 'programs';
                                }
                                else if(ArchivesCubit.get(context).currentIndex==2)
                                {
                                  url = 'hotels';
                                }
                                else
                                {
                                  url = 'cars';
                                }
                                String agent='';
                                if(ArchivesCubit.get(context).agent!)
                                {
                                  url = 'agent-${url}';
                                  agent ='/3';
                                }
                                print('object');
                                print(url);
                                print('${url}-checkout/${ArchivesCubit
                                    .get(context)
                                    .categories![index]}');
                                Get.to(()=>ArchivesWebView('${url}-checkout/${ArchivesCubit
                                    .get(context)
                                    .categories![index]}$agent'));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorsManager.primaryColor
                                ),
                                height: 100,
                                child: Center(
                                  child: Text(ArchivesCubit
                                      .get(context)
                                      .categories![index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),),
                                ),
                              ),
                            ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10,),
                        itemCount: ArchivesCubit
                            .get(context)
                            .categories!
                            .length
                    )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
