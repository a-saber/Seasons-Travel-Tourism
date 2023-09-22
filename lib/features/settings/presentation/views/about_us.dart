import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';
import 'package:seasons/features/settings/presentation/cubit/about_cubit/about_cubit.dart';
import 'package:seasons/features/settings/presentation/cubit/about_cubit/about_states.dart';

import '../../../../core/localization/translation_key_manager.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: defaultAppBar(context: context, text: TranslationKeyManager.aboutUs.tr),
      body:  BasicView(
          bottomPadding: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
        children:
        [
            const SizedBox(height: 10,),
            SizedBox(
                height: 100,
                child: Image.asset('assets/images/logo.PNG')),
          const SizedBox(height: 20,),

            BlocConsumer<AboutCubit, AboutStates>(
                builder: (context, state)
                {
                  if(state is GetAboutLoadingState)
                    return Center(child: CircularProgressIndicator(),);
                  else if (state is GetAboutErrorState)
                    return Center(child: Text(state.error),);
                  else return Column(
                    children:
                    [
                      const SizedBox(height: 10,),
                      Text(TranslationKeyManager.seasonsTour.tr,style: StyleManager.hotelItemTitle.copyWith(height: 1.2,color: ColorsManager.primaryColor, fontSize: 30, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 5,),
                      Text('${TranslationKeyManager.versionNumber.tr} 1.0',
                        style: TextStyle(
                            color: Colors.grey.withOpacity(0.5),fontWeight: FontWeight.bold,fontSize: 13,height: 1.2
                        ),),
                      const SizedBox(height: 30,),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text( CacheData.lang ==  CacheHelperKeys.keyEN? AboutCubit.get(context).about[0].title1En!:AboutCubit.get(context).about[0].title1Ar!,
                              textAlign: TextAlign.start,
                              style: StyleManager.contactUsBio.copyWith(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10,),
                            Text( CacheData.lang ==  CacheHelperKeys.keyEN? AboutCubit.get(context).about[0].details1En!:AboutCubit.get(context).about[0].details1Ar!,
                              style: StyleManager.contactUsBio.copyWith(color: Colors.grey),
                            ),
                            SizedBox(height: 20,),
                            Text( CacheData.lang ==  CacheHelperKeys.keyEN? AboutCubit.get(context).about[0].title2En!:AboutCubit.get(context).about[0].title2Ar!,
                              style: StyleManager.contactUsBio.copyWith(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10,),
                            Text( CacheData.lang ==  CacheHelperKeys.keyEN? AboutCubit.get(context).about[0].details2En!:AboutCubit.get(context).about[0].details2Ar!,
                              style: StyleManager.contactUsBio.copyWith(color: Colors.grey.withOpacity(0.5)),
                            ),
                            SizedBox(height: 20,),
                            Text( CacheData.lang ==  CacheHelperKeys.keyEN? AboutCubit.get(context).about[0].title3En!:AboutCubit.get(context).about[0].title3Ar!,
                              style: StyleManager.contactUsBio.copyWith(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10,),
                            Text( CacheData.lang ==  CacheHelperKeys.keyEN? AboutCubit.get(context).about[0].details3En!:AboutCubit.get(context).about[0].details3Ar!,
                              style: StyleManager.contactUsBio.copyWith(color: Colors.grey.withOpacity(0.5)),
                            ),
                            SizedBox(height: 20,),
                            Text( CacheData.lang ==  CacheHelperKeys.keyEN? AboutCubit.get(context).about[0].titleSectionEn!:AboutCubit.get(context).about[0].titleSectionAr!,
                              style: StyleManager.contactUsBio.copyWith(color: Colors.grey.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }, listener: (context, state){}
            ),
        ],
      ),
          )),
    );
  }
}
