import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:seasons/core/app_cubit/app_cubit.dart';
import 'package:seasons/core/constant.dart';
import 'package:seasons/features/book_info/presentaion/book_info_cubit/book_info_cubit.dart';
import 'package:seasons/features/book_info/presentaion/views/book_infor_screen.dart';
import 'package:seasons/features/cars/data/repo/car_repo_implementation.dart';
import 'package:seasons/features/cars/presentation/cubit/book_cubit/car_book_cubit.dart';
import 'package:seasons/features/cars/presentation/cubit/car_types_cubit/car_types_cubit.dart';
import 'package:seasons/features/cars/presentation/cubit/cars_cubit/cars_cubit.dart';
import 'package:seasons/features/onboarding/presentation/views/splash_view.dart';
import 'package:seasons/features/settings/data/repo/settings_repo_implementation.dart';
import 'package:seasons/features/settings/presentation/cubit/about_cubit/about_cubit.dart';
import 'package:seasons/features/settings/presentation/cubit/info_cubit/info_cubit.dart';
import 'package:seasons/features/settings/presentation/cubit/privacy_cubit/privacy_cubit.dart';
import 'package:seasons/features/settings/presentation/cubit/terms_cubit/terms_cubit.dart';
import 'package:seasons/features/sign_in/data/repo/login_repo_implementation.dart';
import 'package:seasons/features/train/presentation/train_cubit/train_cubit.dart';

import 'core/dio_helper/dio_helper.dart';
import 'core/local_database/cache_data.dart';
import 'core/local_database/cache_helper.dart';
import 'core/local_database/cache_helper_keys.dart';
import 'core/localization/app_localization.dart';
import 'core/localization/translation_key_manager.dart';
import 'core/service_locator/service_locator.dart';
import 'features/Archives/cubit/archives_cubit.dart';
import 'features/airports/cubit/airports_cubit.dart';
import 'features/flights/presentation/cubit/flights_cubit.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/hotels/data/repos/hotel_repo_implementation.dart';
import 'features/hotels/presentation/cubit/hotel_cubit/hotel_cubit.dart';
import 'features/programs_view/presentation/cubit/programs_cubit.dart';
import 'features/sign_in/presentaion/cubit/login_cubit/login_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';


Future onBackground(RemoteMessage message) async {
  print("on background:---------- ${message.notification!.body}");
}

getMessage() {
  FirebaseMessaging.onMessage.listen((event) {
    print("hereeeeeeeeeeeeeeeeeeeeeeee");
    print(event.notification!.body);
    print(event.notification!.title);
    print(event.data['name']);
    print(event.data['lastname']);
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await CacheHelper.init();
  setupForgotPassSingleton();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseMessaging.instance;
  // FirebaseMessaging.onBackgroundMessage(onBackground);
  // FirebaseMessaging.instance.getToken().then((value) {
  //   print(value);
  //   token = value;
  // });
  // print("////////////****************///////////");
  // getMessage();
  //await CacheHelper.saveData(key: CacheHelperKeys.langKey, value: CacheHelperKeys.keyAR);

  CacheData.lang = await CacheHelper.getData(key: CacheHelperKeys.langKey);
  CacheData.email = await CacheHelper.getData(key: 'email');
  CacheData.password = await CacheHelper.getData(key: 'password');

  if (CacheData.lang == null) {
    await CacheHelper.saveData(
        key: CacheHelperKeys.langKey, value: CacheHelperKeys.keyEN);
    await Get.updateLocale(TranslationKeyManager.localeEN);
    CacheData.lang = CacheHelperKeys.keyEN;
  }
  if(CacheData.email ==null || CacheData.password ==null)
  {
    runApp(const MyApp(isLoggedIn: false,));
  }
  else
  {
    runApp(const MyApp(isLoggedIn: true,));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isLoggedIn = false});
  final bool isLoggedIn;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                LoginCubit(getIt.get<LoginRepoImplementation>())),
        BlocProvider(
            create: (BuildContext context) =>
                HotelsCubit(getIt.get<HotelRepoImplementation>())),
        BlocProvider(
            create: (BuildContext context) =>
                CarsCubit(getIt.get<CarRepoImplementation>())),
        BlocProvider(
            create: (BuildContext context) =>
                CarTypesCubit(getIt.get<CarRepoImplementation>())),
        BlocProvider(
            create: (BuildContext context) =>
                CarBookCubit(getIt.get<CarRepoImplementation>())),
        BlocProvider(
            create: (BuildContext context) =>
                PrivacyCubit(getIt.get<SettingsRepoImplementation>())),
        BlocProvider(
            create: (BuildContext context) =>
                InfoCubit(getIt.get<SettingsRepoImplementation>())),
        BlocProvider(
            create: (BuildContext context) =>
                TermsCubit(getIt.get<SettingsRepoImplementation>())),
        BlocProvider(
            create: (BuildContext context) =>
                AboutCubit(getIt.get<SettingsRepoImplementation>())),
        BlocProvider(create: (BuildContext context) => AppCubit()),
        BlocProvider(create: (BuildContext context) => BookInfoCubit()),
        BlocProvider(create: (BuildContext context) => FlightsCubit()),
        BlocProvider(create: (BuildContext context) => ProgramsCubit()),
        BlocProvider(create: (BuildContext context) => AirportsCubit()),
        BlocProvider(create: (BuildContext context) => TrainCubit()),
        BlocProvider(create: (BuildContext context) => HomeCubit()),
        BlocProvider(create: (BuildContext context) => ArchivesCubit()),
        BlocProvider(create: (BuildContext context) => SliderCubit()..getSlider(context)),

      ],
      child: GetMaterialApp(
        theme: ThemeData(
          fontFamily: 'Cairo',
          useMaterial3: true,
          scaffoldBackgroundColor: Color(0xfff2f2f2),
          // scaffoldBackgroundColor: Colors.grey.shade100,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle:  TextStyle(
              color: Colors.white,
              fontSize: 20
            )
          )
        ),
        title: 'Seasons Tour',
        debugShowCheckedModeBanner: false,
        locale: Locale(CacheData.lang!),
        translations: AppLocalization(),
        home: const SplashView(),
        //home: const MainHomeView(),
        //home: const BookInfoScreen(),
      ),
    );
  }
}

/*

 return  GetMaterialApp(
        title: 'Quickly',
        debugShowCheckedModeBanner: false,
        locale: Locale( CacheData.lang!),
        translations: AppLocalization(),
        home:  const SettingsView()
    );
 */
