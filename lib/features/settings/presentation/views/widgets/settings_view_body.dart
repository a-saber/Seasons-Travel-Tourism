import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/delay_manager.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/home/cubit/home_states.dart';
import 'package:seasons/features/settings/presentation/cubit/about_cubit/about_cubit.dart';
import 'package:seasons/features/settings/presentation/views/about_us.dart';
import 'package:seasons/features/settings/presentation/views/contact_us.dart';
import 'package:seasons/features/settings/presentation/views/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/core_widgets/default_button.dart';
import '../../../../../core/core_widgets/flutter_toast.dart';
import '../../../../../core/local_database/cache_helper.dart';
import '../../../../../core/local_database/cache_helper_keys.dart';
import '../../../../../core/localization/translation_key_manager.dart';
import '../../cubit/info_cubit/info_cubit.dart';
import '../../cubit/info_cubit/info_states.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({Key? key}) : super(key: key);

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  @override
  void initState() {
    InfoCubit.get(context).getInfo(context);
    AboutCubit.get(context).getAbout(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) => BasicView(
          child: Column(
            children: [
              Divider(
                height: 3,
                thickness: 4,
                color: Colors.amber,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        // if (CacheData.lang == CacheHelperKeys.keyEN) {
                        //   await CacheHelper.saveData(
                        //       key: CacheHelperKeys.langKey,
                        //       value: CacheHelperKeys.keyAR);
                        //   Get.updateLocale(TranslationKeyManager.localeAR);
                        //   CacheData.lang = CacheHelperKeys.keyAR;
                        // } else {
                        //   await CacheHelper.saveData(
                        //       key: CacheHelperKeys.langKey,
                        //       value: CacheHelperKeys.keyEN);
                        //   Get.updateLocale(TranslationKeyManager.localeEN);
                        //   CacheData.lang = CacheHelperKeys.keyEN;
                        // }
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.globe,
                            color: ColorsManager.primaryColor,
                            size: 22,

                          ),
                          // Icon(
                          //   Icons.language,
                          //  // color: Colors.blue.shade800,
                          //   color: ColorsManager.primaryColor,
                          // ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            TranslationKeyManager.language.tr,
                            style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          FaIcon(
                            FontAwesomeIcons.arrowsRotate,
                            color:  Colors.grey,
                            size: 17,
                          ),

                          // const Icon(
                          //   Icons.arrow_forward_ios_sharp,
                          //   color: Colors.grey,
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Divider(
                height: 0,
                thickness: 2,
                color: Colors.amber,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0)
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    InkWell(
                      onTap: () {
                        Get.to(() => const AboutUs(),
                            transition: DelayManager.transitionToBook,
                            duration: DelayManager.durationTransitionToBook,
                            curve: DelayManager.curveToBook);
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.peopleGroup,
                            color: ColorsManager.primaryColor,
                          ),
                          // Icon(
                          //   Icons.info_outline,
                          //   color: Colors.blue.shade800,
                          // ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            TranslationKeyManager.aboutUs.tr,
                            style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Colors.grey,
                            size: 17,

                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const PrivacyPolicy(),
                            transition: DelayManager.transitionToBook,
                            duration: DelayManager.durationTransitionToBook,
                            curve: DelayManager.curveToBook);
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.userLock,
                            color: ColorsManager.primaryColor,
                            size: 20,

                          ),
                          // Icon(
                          //   Icons.privacy_tip_outlined,
                          //   color: Colors.blue.shade800,
                          // ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            TranslationKeyManager.privacyPolicy.tr,
                            style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Colors.grey,
                            size: 17,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const ContactUs(),
                            transition: DelayManager.transitionToBook,
                            duration: DelayManager.durationTransitionToBook,
                            curve: DelayManager.curveToBook);
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.commentDots,
                            color: ColorsManager.primaryColor,
                            size: 20,
                          ),
                          // Icon(
                          //   Icons.message_outlined,
                          //   color: Colors.blue.shade800,
                          // ),
                          const SizedBox(
                            width: 25,
                          ),
                          Text(
                            TranslationKeyManager.contactUs.tr,
                            style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Colors.grey,
                            size: 17,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Divider(
                height: 0,
                thickness: 2,
                color: Colors.amber,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0)
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        TranslationKeyManager.followUs.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<InfoCubit, InfoStates>(
                      builder: (context, state) {
                        var cubit = InfoCubit.get(context);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  try {
                                    openUrl(cubit.info[0].instagram!);
                                  } catch (e) {
                                    showToast(
                                        massage: "couldn't open instagram",
                                        state: ToastState.ERROR);
                                    throw Exception(
                                        "couldn't launch url ${cubit.info[0].instagram}");
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.instagram,
                                  //color: Colors.blue.shade700,
                                  color: ColorsManager.primaryColor,
                                )),
                            IconButton(
                                onPressed: () async {
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
                                icon: Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: ColorsManager.primaryColor,
                                )),
                            IconButton(
                                onPressed: () {
                                  try {
                                    openUrl(cubit.info[0].tiktok!);
                                  } catch (e) {
                                    showToast(
                                        massage: "couldn't open tiktok",
                                        state: ToastState.ERROR);
                                    throw Exception(
                                        "couldn't launch url ${cubit.info[0].tiktok}");
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.tiktok,
                                  color: ColorsManager.primaryColor,
                                )),
                            IconButton(
                                onPressed: () {
                                  try {
                                    openUrl(cubit.info[0].youtube!);
                                  } catch (e) {
                                    showToast(
                                        massage: "couldn't open youtube",
                                        state: ToastState.ERROR);
                                    throw Exception(
                                        "couldn't launch url ${cubit.info[0].youtube}");
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.youtube,
                                  color: ColorsManager.primaryColor,
                                )),
                            IconButton(
                                onPressed: () {
                                  try {
                                    openUrl(cubit.info[0].facebook!);
                                  } catch (e) {
                                    showToast(
                                        massage: "couldn't open facebook",
                                        state: ToastState.ERROR);
                                    throw Exception(
                                        "couldn't launch url ${cubit.info[0].facebook}");
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.facebook,
                                  color: ColorsManager.primaryColor,
                                )),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }

  openUrl(String url) async {
    await launch(url);
  }
}

/*
Text(
                  TranslationKeyManager.settings.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
 */
/*
Text(
                  TranslationKeyManager.seasonsTour.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
 */
/*
Container(
            height: 2,
            width: double.infinity,
            color: Colors.amber,
          ),
 */

/*
 const SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 110.0),
            height: 35,
            child: DefaultButton(
                text: TranslationKeyManager.main.tr,
                onPressed: () {
                  HomeCubit.get(context).changeIndex(0);
                }),
          ),
 */


