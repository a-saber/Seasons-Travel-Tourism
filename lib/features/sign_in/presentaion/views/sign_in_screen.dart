import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/delay_manager.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/home/cubit/home_states.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_cubit.dart';
import 'package:seasons/features/sign_in/presentaion/cubit/login_cubit/login_states.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';

import '../../../../core/resources_manager/style_manager.dart';
import 'profile_view.dart';
import 'register_view.dart';
//CacheData.lang == CacheHelperKeys.keyEN
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key, this.fromBook = false}) : super(key: key);

  final bool fromBook;
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BasicView2(
        appbarTitle: TranslationKeyManager.login.tr,
        button: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state)
          {
            if(widget.fromBook)
            if(state is LoginSuccessState)
            {
              print('object');
              callMySnackBar(context: context, text: 'Now, you are logged in');
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return
            Column(
              children:
              [
                state is LoginLoadingState
                    ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0, ),
                  child: CircularProgressIndicator(
                    color: ColorsManager.primaryColor,
                    // color: Colors.blue.shade700,
                  ),
                )
                    : InkWell(
                  onTap: emailController.text.isEmpty || passwordController.text.isEmpty ||passwordController.text.length<6 || !emailController.text.contains('@')?
                  null:
                      () {
                    if(_formKey.currentState!.validate()) {
                      LoginCubit.get(context).userLogin(
                        context:context,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      color: emailController.text.isEmpty || passwordController.text.isEmpty ||passwordController.text.length<6 || !emailController.text.contains('@')?
                      Colors.black.withOpacity(0.1):
                      ColorsManager.primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        TranslationKeyManager.login.tr,
                        style: StyleManager.searchTextStyle.copyWith(fontFamily: "Cairo",fontWeight: FontWeight.w700,fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account ?'),
                      TextButton(
                          onPressed: ()
                          {
                            Get.to(()=>RegisterView(),
                                transition: DelayManager.transitionToBook,
                                duration: Duration(milliseconds:500 ));
                          },
                          child: Text('Register now', style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold, color: ColorsManager.primaryColor),)),
                    ],
                  ),
                )

              ],
            );

          },
        ),
        children:
        [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  color: ColorsManager.primaryColor,
                  child: Column(
                    children:
                    [
                      Text('You haven\'t logged in yet.', style: TextStyle(color: Colors.white),),
                      Text('Ready to get started ?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorsManager.primaryColor,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.white)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Text('Join Now'.toUpperCase(), style:  TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17),),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 3,
                  color: Colors.amber,
                ),
                SizedBox(height: 25,),
                Text(TranslationKeyManager.loginFaster.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                SizedBox(height: 25),
                DefaultField(
                  hint: TranslationKeyManager.userName.tr,
                  controller: emailController,
                  onChange: (String? val)
                  {
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                DefaultField(
                  hint: TranslationKeyManager.password.tr,
                  controller: passwordController,
                    onChange: (String? val)
                    {
                      setState(() {});
                    }
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ],
    );
  }
}
/*
SafeArea(
      child: Scaffold(
        appBar: defaultAppBar(
            context: context, text: 'Login',
          action: TextButton(
              onPressed: ()
              {
                Get.to(()=>RegisterView(),
                transition: DelayManager.transitionToBook,
                duration: Duration(milliseconds:500 ));
              },
              child: Text('Register now', style: TextStyle(
                fontSize: 14,
                  fontWeight: FontWeight.bold, color: Colors.white),))
        ),
        body: Form(
          key: _formKey,
          child: SizedBox(
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
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height*0.35,
                            child: Column(
                              children: [
                                SizedBox(height: 15,),
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(TranslationKeyManager.loginFaster.tr,
                                      textAlign: TextAlign.center,

                                    style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 22),)),
                                Expanded(
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 5,),
                                          DefaultField(
                                            hint: TranslationKeyManager.userName.tr,
                                            controller: emailController,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          DefaultField(
                                            hint: TranslationKeyManager.password.tr,
                                            controller: passwordController,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      BlocConsumer<LoginCubit, LoginStates>(
                        listener: (context, state)
                        {
                          // if(state is LoginSuccessState)
                          // {
                          //   Get.to(()=>ProfileView());
                          // }
                        },
                          builder: (context, state) {
                            return state is LoginLoadingState
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
                                  LoginCubit.get(context).userLogin(
                                    context:context,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
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
                                    TranslationKeyManager.login.tr,
                                    style: StyleManager.searchTextStyle.copyWith(fontFamily: "Cairo",fontWeight: FontWeight.w700,fontSize: 16),
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
          ),
        ),
      ),
    )
 */
/*
 ClipPath(
              clipper: WaveClipperTwo(flip: true),
              child: Container(
                height: 180,
                color: Colors.blue.shade700,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        TranslationKeyManager.login.tr,
                        style: StyleManager.signInTextStyle,
                      ),
                      const Spacer(),
                      BlocBuilder<HomeCubit, HomeStates>(
                        builder: (context, state) => InkWell(
                          onTap: () {
                            HomeCubit.get(context).changeIndex(0);
                          },
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue.shade700,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
 */