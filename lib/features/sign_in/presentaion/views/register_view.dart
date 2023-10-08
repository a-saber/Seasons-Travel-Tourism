import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                          token: '',
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Register with google'),
                          IconButton(
                              onPressed: ()
                              {
                                LoginCubit.get(context).registerGoogle(context: context);
                              }, icon: FaIcon(FontAwesomeIcons.google, color: ColorsManager.primaryColor,)),
                        ],
                      ),
                    ],
                  );
                },
                listener:  (context ,state){}
            ),
          )
        ]
    );

  }
}

