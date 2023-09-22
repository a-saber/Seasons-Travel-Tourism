import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/core_widgets/default_head_line.dart';
import 'package:seasons/core/core_widgets/default_settings_button.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/assets_manager.dart';
import 'package:seasons/features/settings/presentation/cubit/info_cubit/info_cubit.dart';
import 'package:seasons/features/settings/presentation/cubit/info_cubit/info_states.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/core_widgets/flutter_toast.dart';
import '../../../../core/resources_manager/colors_manager.dart';
import '../../../../core/resources_manager/style_manager.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
          context: context,
          text: TranslationKeyManager.contactUs.tr,
          ),
      body: BasicView(
        bottomPadding: 20,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                  height: 100,
                  child: Image.asset(AssetsManager.logo)
                /*Image.network(
                                      "https://api.seasonsge.com/${cubit.info[0].logo!}"
                                  )*/
                // ListItemImage(
                //   image:
                //       "https://api.seasonsge.com/${cubit.info[0].logo!}",
                // )
                // Image.asset('assets/images/logo.PNG')
              ),
            ),
            SizedBox(height: 20,),
            BlocBuilder<InfoCubit, InfoStates>(
              builder: (context, state) {
                var cubit = InfoCubit.get(context);
                return state is GetAllInfoLoadingState ?
                Center(child: CircularProgressIndicator()) :
                state is GetAllInfoErrorState ?
                Center(child: Text(state.error)) :
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children:
                    [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0)
                            .copyWith(top: 0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0),
                              child: ShaderMask(
                                shaderCallback: (bounds)=> LinearGradient(
                                    colors: [
                                      //Color(0xff9e98d5)
                                      ColorsManager.primaryColor,
                                      ColorsManager.primaryTwoColor,
                                      //ColorsManager.primaryTwoColor,
                                    ]).createShader(bounds),
                                child: Text(
                                  TranslationKeyManager.contactUsBio.tr,
                                  style: StyleManager.contactUsBio.copyWith(color: Colors.grey.withOpacity(0.5)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white
                              ),
                              child: Text(
                                TranslationKeyManager.contactUs.tr + ' ' +TranslationKeyManager.via.tr,
                                style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // DefaultHeadLine(
                            //   text:
                            //   TranslationKeyManager.contactUs.tr + ' ' +TranslationKeyManager.via.tr,
                            //   icon: null,
                            //   color: ColorsManager.tabBarIndicator,
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.facebook.tr}',
                                  icon: FontAwesomeIcons.facebook,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(
                                          cubit.info[0].facebook!, "facebook");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open facebook",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].facebook}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.twitter.tr}',
                                  icon: FontAwesomeIcons.twitter,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(cubit.info[0].twitter!, "twitter");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open twitter",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].twitter}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.whatsApp.tr}',
                                  icon: FontAwesomeIcons.whatsapp,
                                  iconSize: 20,
                                  onTap: () async {
                                    try {
                                      var whatsapp = Uri.parse(
                                          "whatsapp://send?phone=${cubit.info[0].mobileNumber}");
                                      await launchUrl(whatsapp);
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open whatsapp",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].whatsapp}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.instagram.tr}',
                                  icon: FontAwesomeIcons.instagram,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(
                                          cubit.info[0].instagram!, "instagram");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open instagram",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].instagram}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.snapchat.tr}',
                                  icon: FontAwesomeIcons.snapchat,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(
                                          cubit.info[0].snapchat!, "snapchat");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open snapchat",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].snapchat}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.tiktok.tr}',
                                  icon: FontAwesomeIcons.tiktok,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(cubit.info[0].tiktok!, "tiktok");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open tiktok",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].tiktok}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.messenger.tr}',
                                  icon: Icons.message_outlined,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(
                                          cubit.info[0].messenger!, "messenger");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open messenger",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].messenger}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.telegram.tr}',
                                  icon: FontAwesomeIcons.telegram,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(
                                          cubit.info[0].telegram!, "telegram");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open telegram",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].telegram}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.youtube.tr}',
                                  icon: FontAwesomeIcons.youtube,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(cubit.info[0].youtube!, "youtube");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open youtube",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].youtube}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.email.tr}',
                                  icon: Icons.email_outlined,
                                  iconSize: 20,
                                  onTap: () async {
                                    final Uri emailUri = Uri(
                                        path: cubit.info[0].email,
                                        scheme: "mailto");
                                    if (await canLaunchUrl(emailUri)) {
                                      await launchUrl(emailUri);
                                    } else {
                                      showToast(
                                          massage: "couldn't open email",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].email}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.mobileNumber.tr}',
                                  icon: FontAwesomeIcons.mobile,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      print("88888888888888888888888");
                                      print(
                                          cubit.info[0].mobileNumber.toString());
                                      openUrl("tel:${cubit.info[0].mobileNumber}",
                                          "Mobile number");
                                    } catch (e) {
                                      showToast(
                                          massage: "Mobile number",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].mobileNumber}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: DefaultSettingsButton(
                                  text:
                                  '${TranslationKeyManager.googlePlayLink.tr}',
                                  icon: FontAwesomeIcons.googlePlay,
                                  iconSize: 20,
                                  onTap: () {
                                    try {
                                      openUrl(cubit.info[0].googlePlayLink!,
                                          "googlePlayLink");
                                    } catch (e) {
                                      showToast(
                                          massage: "couldn't open google Play",
                                          state: ToastState.ERROR);
                                      throw Exception(
                                          "couldn't launch url ${cubit.info[0].googlePlayLink}");
                                    }
                                  },
                                  isNear: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DefaultSettingsButton(
                            text:
                            '${TranslationKeyManager.appStoreLink.tr}',
                            icon: FontAwesomeIcons.appStore,
                            iconSize: 20,
                            onTap: () {
                              try {
                                openUrl(cubit.info[0].appStoreLink!,
                                    "appStoreLink");
                              } catch (e) {
                                print("in cattttttttttttt");
                                showToast(
                                    massage: "couldn't open app store",
                                    state: ToastState.ERROR);
                                throw Exception(
                                    "couldn't launch url ${cubit.info[0].appStoreLink}");
                              }
                            },
                            isNear: true,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  openUrl(
    String url,
    String message,
  ) async {
    if (await canLaunch(url) == false) {
      showToast(massage: "couldn't open $message", state: ToastState.ERROR);
    }
    await launch(
      url,
      enableJavaScript: true,
      forceSafariVC: true,
      forceWebView: true,
    );
  }
}
