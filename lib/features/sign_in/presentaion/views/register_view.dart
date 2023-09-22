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
import 'package:seasons/features/sign_in/data/models/user_model.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_cubit.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_states.dart';

import 'widgets/default_form_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return BasicView2(
      scaffoldKey: scaffoldKey,
        appbarTitle: CacheData.lang==CacheHelperKeys.keyEN?'Register':'انشاء حساب',
        button:  BlocBuilder<LoginCubit, LoginStates>(
          builder: (context, state) {
            return state is RegisterLoadingState
                ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0, ),
              child: CircularProgressIndicator(
                color: ColorsManager.primaryColor,
                // color: Colors.blue.shade700,
              ),
            )
                : InkWell(
              onTap: () {
                if(_formKey.currentState!.validate()) {
                  if(passwordController.text ==passwordConfirmController.text) {
                    if(LoginCubit.get(context).registerImage ==null)
                    {
                      callMySnackBar(context: context, text: 'please select image');
                    }
                    else {
                      LoginCubit.get(context).register(
                        user: UserModel(
                            email: emailController.text,
                            name: nameController.text,
                            password: passwordController.text
                        ),
                        context: context,
                      );
                    }
                  }
                  else
                  {
                    callMySnackBar(context: context, text: 'Password confirm is not correct');
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
                    'Create an account',
                    style: StyleManager.searchTextStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
        children:
        [
          Form(
            key: _formKey,
            child: BlocConsumer<LoginCubit, LoginStates>(
                builder: (context ,state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
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
                                          LoginCubit.get(context).getRegisterImage(ImageSource.camera);
                                        }, icon: Icon(Icons.camera_alt, color: Colors.white,)),
                                    SizedBox(width: 50,),
                                    IconButton(
                                        onPressed: ()
                                        {
                                          LoginCubit.get(context).getRegisterImage(ImageSource.gallery);
                                        }, icon: Icon(Icons.image,color: Colors.white,)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                              backgroundColor: Colors.transparent
                          );
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black,
                          backgroundImage: LoginCubit.get(context).registerImage ==null?
                          AssetImage(AssetsManager.profile):
                          FileImage(LoginCubit.get(context).registerImage!) as ImageProvider<Object>?,
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 25,
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
                      )
                    ],
                  );
                },
                listener:  (context ,state){}
            ),
          )
        ]
    );
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: defaultAppBar(
            context: context, text: 'Register'),
        body: Form(
          key: _formKey,
          child: BlocConsumer<LoginCubit, LoginStates>(
              builder: (context ,state) {
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
                        padding: const EdgeInsets.only(right: 20.0, left: 20, bottom: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 60.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      elevation: 3,
                                      child: Container(
                                        //padding: EdgeInsets.only(top: 75+40, bottom: 40),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Column(
                                            children: [
                                               const SizedBox(
                                                height: 85,
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
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: InkWell(
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
                                                        LoginCubit.get(context).getRegisterImage(ImageSource.camera);
                                                      }, icon: Icon(Icons.camera_alt, color: Colors.white,)),
                                                  SizedBox(width: 50,),
                                                  IconButton(
                                                      onPressed: ()
                                                      {
                                                        LoginCubit.get(context).getRegisterImage(ImageSource.gallery);
                                                      }, icon: Icon(Icons.image,color: Colors.white,)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                            backgroundColor: Colors.transparent
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.black,
                                        backgroundImage: LoginCubit.get(context).registerImage ==null?
                                        AssetImage(AssetsManager.profile):
                                        FileImage(LoginCubit.get(context).registerImage!) as ImageProvider<Object>?,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              BlocBuilder<LoginCubit, LoginStates>(
                                builder: (context, state) {
                                  return state is RegisterLoadingState
                                      ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, ),
                                    child: CircularProgressIndicator(
                                      color: ColorsManager.primaryColor,
                                      // color: Colors.blue.shade700,
                                    ),
                                  )
                                      : InkWell(
                                    onTap: () {
                                      if(_formKey.currentState!.validate()) {
                                        if(passwordController.text ==passwordConfirmController.text) {
                                          if(LoginCubit.get(context).registerImage ==null)
                                          {
                                            callMySnackBar(context: context, text: 'please select image');
                                          }
                                          else {
                                            LoginCubit.get(context).register(
                                              user: UserModel(
                                                  email: emailController.text,
                                                  name: nameController.text,
                                                  password: passwordController.text
                                              ),
                                              context: context,
                                            );
                                          }
                                        }
                                        else
                                        {
                                          callMySnackBar(context: context, text: 'Password confirm is not correct');
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(horizontal: 30.0),
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
                                          'Create an account',
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
                      ),

                    ],
                  ),
                );
              },
              listener:  (context ,state){}
          ),
        ),
      ),
    );
  }
}
