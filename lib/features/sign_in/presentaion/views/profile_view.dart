import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/assets_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';
import 'package:seasons/features/Archives/cubit/archives_cubit.dart';
import 'package:seasons/features/Archives/presentation/views/archives_view.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/sign_in/data/models/user_model.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_cubit.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_states.dart';

import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BasicView2(
      action: IconButton(
          onPressed: ()
          {
            Get.to(()=>EditProfileView());
          }, icon: FaIcon(FontAwesomeIcons.userPen)),
      scaffoldKey: scaffoldKey,
      appbarTitle: CacheData.lang == CacheHelperKeys.keyEN? 'Profile':'الحساب',
      button: InkWell(
        onTap: () async
        {

          LoginCubit.get(context).logout();
          HomeCubit.get(context).Logout();
          // HomeCubit.get(context).changeIndex(0);
        },
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 40.0),
          decoration: BoxDecoration(
            color: ColorsManager.primaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              'Logout',
              style: StyleManager.searchTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      children:
      [
        BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state){},
          builder: (context, state)
          {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
              [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                    [
                      Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        color: ColorsManager.primaryColor,
                        child: Column(
                          children: [
                            CachedNetworkImage(
                                imageBuilder: (BuildContext, ImageProvider<Object> provider)
                                {
                                  return CircleAvatar(
                                      radius: 70,
                                      backgroundImage: provider
                                  );
                                },
                                placeholder: (context, error) =>CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 70,
                                    backgroundImage: AssetImage(AssetsManager.profile)
                                ),
                                // const Icon(
                                //   Icons.image_outlined,
                                //   color: Colors.grey,
                                // ),
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                        radius: 70,
                                        backgroundColor: Colors.black,
                                        backgroundImage: AssetImage(AssetsManager.profile)
                                    ),

                                // const Icon(
                                //   Icons.image_outlined,
                                //   color: Colors.grey,
                                // ),
                                imageUrl: 'https://api.seasonsge.com/images/Agents/${LoginCubit.get(context).userModel!.img}'),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        color: Colors.amber,
                        thickness: 3,
                      ),
                      SizedBox(height: 30,),
                      Text(LoginCubit.get(context).userModel!.name!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                      SizedBox(height: 15,),
                      Text(LoginCubit.get(context).userModel!.email!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                      SizedBox(height: 40,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorsManager.primaryColor,
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children:
                                  [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      [
                                        FaIcon(FontAwesomeIcons.sackDollar,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 15,),
                                        Text('My Balance', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Text('${LoginCubit.get(context).userModel!.balance!} \$', style:
                                    TextStyle(color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),)

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xff9e98d5),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children:
                                  [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:
                                      [
                                        FaIcon(FontAwesomeIcons.tags,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10,),
                                        Text('My Discount', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Text('${LoginCubit.get(context).userModel!.discount!} \%', style:
                                    TextStyle(color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),)

                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height:40
                      ),
                      InkWell(
                        onTap: () async
                        {
                          ArchivesCubit.get(context).getArchives(LoginCubit.get(context).userModel!.id.toString(), LoginCubit.get(context).userModel!.type ==1 );
                          Get.to(()=>ArchivesView());
                        },
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 40.0),
                          decoration: BoxDecoration(
                            color: ColorsManager.primaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              CacheData.lang == CacheHelperKeys.keyEN? 'Archives':'الارشيف',
                              style: StyleManager.searchTextStyle.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                    ],
                  ),
                )
              ],
            );
          },
        )
      ],
    );

  }
}

/*
gradient: LinearGradient(
                                    colors:
                                    [
                                      ColorsManager.primaryColor,
                                      Color(0xff604fb4),
                                    ]),
 */


/*
return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorsManager.primaryColor,
      appBar: defaultAppBar(context: context, text: 'Profile',action: IconButton(
          onPressed: ()
          {
            Get.to(()=>EditProfileView());
          }, icon: FaIcon(FontAwesomeIcons.userPen))),
      body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state){},
            builder: (context, state)
            {
              return Column(
                children:
                [
                  SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                            [
                              CachedNetworkImage(
                                imageBuilder: (BuildContext, ImageProvider<Object> provider)
                                {
                                  return CircleAvatar(
                                      radius: 70,
                                      backgroundImage: provider
                                  );
                                  },
                                  placeholder: (context, error) =>CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 70,
                                      backgroundImage: AssetImage(AssetsManager.profile)
                                  ),
                                  // const Icon(
                                  //   Icons.image_outlined,
                                  //   color: Colors.grey,
                                  // ),
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          radius: 70,
                                          backgroundColor: Colors.black,
                                          backgroundImage: AssetImage(AssetsManager.profile)
                                      ),

                                  // const Icon(
                                  //   Icons.image_outlined,
                                  //   color: Colors.grey,
                                  // ),
                                  imageUrl: 'https://api.seasonsge.com/images/Agents/${LoginCubit.get(context).userModel!.img}'),
                              SizedBox(height: 30,),
                              Text(LoginCubit.get(context).userModel!.name!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                              SizedBox(height: 15,),
                              Text(LoginCubit.get(context).userModel!.email!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                              SizedBox(height: 40,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: ColorsManager.primaryColor,
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children:
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:
                                              [
                                                FaIcon(FontAwesomeIcons.sackDollar,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 15,),
                                                Text('My Balance', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                              ],
                                            ),
                                            SizedBox(height: 15,),
                                            Text('${LoginCubit.get(context).userModel!.balance!} \$', style:
                                            TextStyle(color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),)

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color(0xff9e98d5),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children:
                                          [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:
                                              [
                                                FaIcon(FontAwesomeIcons.tags,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 10,),
                                                Text('My Discount', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                              ],
                                            ),
                                            SizedBox(height: 15,),
                                            Text('${LoginCubit.get(context).userModel!.discount!} \%', style:
                                            TextStyle(color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),)

                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:40
                              ),
                              InkWell(
                                onTap: () async
                                {

                                  LoginCubit.get(context).logout();
                                  HomeCubit.get(context).Logout();
                                 // HomeCubit.get(context).changeIndex(0);
                                },
                                child: Container(
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(horizontal: 40.0),
                                  decoration: BoxDecoration(
                                    //color: Colors.blue.shade700,
                                    gradient: LinearGradient(
                                        colors:
                                        [
                                          ColorsManager.primaryColor,
                                          Color(0xff604fb4),
                                          // Color(0xff604fb4),
                                        ]),
                                    //color: ColorsManager.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Logout',
                                      style: StyleManager.searchTextStyle.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          )
      ),
    );
 */