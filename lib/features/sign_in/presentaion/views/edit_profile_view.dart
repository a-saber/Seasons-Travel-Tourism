import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/assets_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_cubit.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_states.dart';

import 'widgets/default_form_field.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();
@override
  void initState() {
    nameController.text = LoginCubit.get(context).userModel!.name!;
    emailController.text = LoginCubit.get(context).userModel!.email!;
    LoginCubit.get(context).profileImage = null;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return BasicView2(
      scaffoldKey: scaffoldKey,
      button: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              FirebaseMessaging.instance.subscribeToTopic("agent");
            }
          },
          builder: (context, state) {
            return state is UploadLoadingState
                ? CircularProgressIndicator(
              color: ColorsManager.primaryColor,
              // color: Colors.blue.shade700,
            ) :
            InkWell(
              onTap: () {
                if(_formKey.currentState!.validate() ) {
                  if(passwordController.text != passwordConfirmController.text)
                  {
                    callMySnackBar(context: context, text: 'Password is not correct');
                  }
                  else {
                    LoginCubit
                        .get(context)
                        .userModel!
                        .name = nameController.text;
                    LoginCubit
                        .get(context)
                        .userModel!
                        .email = emailController.text;
                    LoginCubit
                        .get(context)
                        .userModel!
                        .password = passwordController.text;
                    LoginCubit.get(context).update(
                      context: context,
                      user: LoginCubit
                          .get(context)
                          .userModel!,
                    );
                  }
                }
              },
              child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        'Update',
                        style: StyleManager.searchTextStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
            );
          },
        ),
      ),
      appbarTitle: CacheData.lang == CacheHelperKeys.keyEN? 'Update':'تعديل',
      children:
      [
        Form(
          key: _formKey,
          child: BlocConsumer<LoginCubit, LoginStates>(
              listener: (context, state)
              {
                if (state is UploadSuccessState)
                {
                  callMySnackBar(context: context, text: 'Profile updated successfully');
                }
                if (state is UploadErrorState)
                {
                  callMySnackBar(context: context, text: state.error);
                }
              },
              builder: (context, state)
              {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: ColorsManager.primaryColor,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children:
                        [
                          if(LoginCubit.get(context).profileImage != null)
                            Container(
                              height: 140,width: 140,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      image: FileImage(LoginCubit.get(context).profileImage!),
                                      fit: BoxFit.cover)
                              ),
                            ),
                          if(LoginCubit.get(context).profileImage == null)
                            InkWell(
                              onTap: ()
                              {
                                scaffoldKey.currentState!.showBottomSheet((context) => Column(
                                  children: [
                                    Expanded(child: InkWell(
                                      onTap: ()
                                      {
                                        Navigator.pop(context);
                                      },
                                    )),
                                    Container(
                                      color: Colors.grey,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:
                                        [
                                          IconButton(
                                              onPressed: ()
                                              {
                                                LoginCubit.get(context).getImage(ImageSource.camera);
                                              }, icon: Icon(Icons.camera_alt, color: Colors.white,)),
                                          SizedBox(width: 50,),
                                          IconButton(
                                              onPressed: ()
                                              {
                                                LoginCubit.get(context).getImage(ImageSource.gallery);
                                              }, icon: Icon(Icons.image,color: Colors.white,)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                    backgroundColor: Colors.transparent
                                );
                              },
                              child: CachedNetworkImage(
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
                            ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      thickness: 3,
                      color: Colors.amber,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Column(
                          children: [

                            DefaultField(
                              hint: 'Name',
                              controller: nameController,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DefaultField(
                              hint: TranslationKeyManager.userName.tr,
                              controller: emailController,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DefaultField(
                              hint: TranslationKeyManager.password.tr,
                              controller: passwordController,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DefaultField(
                              hint: 'Confirm password',
                              controller: passwordConfirmController,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                );
              }),
        )
      ]);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: defaultAppBar(context: context, text: 'Update'),
        body: Form(
          key: _formKey,
          child: BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state)
            {
              if (state is UploadSuccessState)
              {
                callMySnackBar(context: context, text: 'Profile updated successfully');
              }
              if (state is UploadErrorState)
              {
                callMySnackBar(context: context, text: state.error);
              }
            },
              builder: (context, state)
              {
                return SizedBox(
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20),
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.height*0.55,
                                        child: Center(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 75,
                                                ),
                                                DefaultField(
                                                  hint: 'Name',
                                                  controller: nameController,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                DefaultField(
                                                  hint: TranslationKeyManager.userName.tr,
                                                  controller: emailController,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                DefaultField(
                                                  hint: TranslationKeyManager.password.tr,
                                                  controller: passwordController,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                DefaultField(
                                                  hint: 'Confirm password',
                                                  controller: passwordConfirmController,
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: StreamBuilder<Object>(
                                    stream: null,
                                    builder: (context, snapshot) {
                                      return Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          if(LoginCubit.get(context).profileImage != null)
                                            Container(
                                              height: 140,width: 140,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(100),
                                                image: DecorationImage(
                                                    image: FileImage(LoginCubit.get(context).profileImage!),
                                                fit: BoxFit.cover)
                                              ),
                                            ),
                                          if(LoginCubit.get(context).profileImage == null)

                                          InkWell(
                                            onTap: ()
                                            {
                                              scaffoldKey.currentState!.showBottomSheet((context) => Column(
                                                children: [
                                                  Expanded(child: InkWell(
                                                    onTap: ()
                                                    {
                                                      Navigator.pop(context);
                                                    },
                                                  )),
                                                  Container(
                                                    color: Colors.grey,
                                                    width: double.infinity,
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children:
                                                      [
                                                        IconButton(
                                                            onPressed: ()
                                                            {
                                                              LoginCubit.get(context).getImage(ImageSource.camera);
                                                            }, icon: Icon(Icons.camera_alt, color: Colors.white,)),
                                                        SizedBox(width: 50,),
                                                        IconButton(
                                                            onPressed: ()
                                                            {
                                                              LoginCubit.get(context).getImage(ImageSource.gallery);
                                                            }, icon: Icon(Icons.image,color: Colors.white,)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                                  backgroundColor: Colors.transparent
                                              );
                                            },
                                            child: CachedNetworkImage(
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
                                          ),
                                          // IconButton(
                                          //     onPressed: ()
                                          //     {
                                          //
                                          //     },
                                          //     icon: Padding(
                                          //       padding: const EdgeInsets.only(left: 15.0,bottom: 10),
                                          //       child: CircleAvatar(
                                          //           backgroundColor: Colors.black,
                                          //           child: Icon(Icons.edit,color: Colors.white60,size: 25,)),
                                          //     )
                                          // )

                                        ],
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            BlocBuilder<LoginCubit, LoginStates>(
                              builder: (context, state) {
                                return state is UploadLoadingState
                                    ? CircularProgressIndicator(
                                      color: ColorsManager.primaryColor,
                                      // color: Colors.blue.shade700,
                                    )
                                    : InkWell(
                                  onTap: () {
                                    if(_formKey.currentState!.validate() ) {
                                      if(passwordController.text != passwordConfirmController.text)
                                      {
                                        callMySnackBar(context: context, text: 'Password is not correct');
                                      }
                                      else {
                                        LoginCubit
                                            .get(context)
                                            .userModel!
                                            .name = nameController.text;
                                        LoginCubit
                                            .get(context)
                                            .userModel!
                                            .email = emailController.text;
                                        LoginCubit
                                            .get(context)
                                            .userModel!
                                            .password = passwordController.text;
                                        LoginCubit.get(context).update(
                                          context: context,
                                          user: LoginCubit
                                              .get(context)
                                              .userModel!,
                                        );
                                      }
                                    }
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
                                          ]),
                                      //color: ColorsManager.primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Update',
                                        style: StyleManager.searchTextStyle.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
