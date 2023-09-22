import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';

abstract class StyleManager {
  static const TextStyle appbarTitle = TextStyle(
      //fontWeight: FontWeight.w600,
      fontSize: 15,
      color: Colors.black,
      fontFamily: 'Cairo',
      height: 1.2);

  static const TextStyle hotelTabBarItem = TextStyle(
    //fontWeight: FontWeight.w600,
    fontSize: 12,
    color: Colors.black,
    fontFamily: 'Cairo',
  );

  static const TextStyle hotelItemTitle = TextStyle(
    // fontWeight: FontWeight.w600,
    fontSize: 15,
    color: ColorsManager.hotelItemTitle,
    fontFamily: 'Cairo',
  );

  static const TextStyle hotelItemExtraTitle = TextStyle(
    //fontWeight: FontWeight.w600,
    fontSize: 13,
    color: ColorsManager.hotelItemExtraTitle,
    fontFamily: 'Cairo',
  );

  static const TextStyle hotelItemDetailsDesc = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: Colors.black,
    fontFamily: 'Cairo',
  );

  static const TextStyle defaultButton = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: Colors.white,
    fontFamily: 'Cairo',
  );

  static const TextStyle defaultHeadLine = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Colors.black,
    fontFamily: 'Cairo',
  );

  static const TextStyle defaultSettingsBtn = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: Colors.grey,
    fontFamily: 'Cairo',
  );

  static const TextStyle hotelsBook = TextStyle(
    //fontWeight: FontWeight.w600,
    fontSize: 20,
    color: Colors.blue,
    fontFamily: 'Cairo',
  );

  static const TextStyle hotelsBookMainPath = TextStyle(
    //fontWeight: FontWeight.w600,
    fontSize: 17,
    color: Colors.blue,
    fontFamily: 'Cairo',
  );

  static const TextStyle hotelsBookPath = TextStyle(
    //fontWeight: FontWeight.w600,
    fontSize: 17,
    color: Colors.blueGrey,
    fontFamily: 'Cairo',
  );

  static const TextStyle bookTypeTitle = TextStyle(
    //fontWeight: FontWeight.w600,
    fontSize: 20,
    color: Colors.blueGrey,
    fontFamily: 'Cairo',
  );

  static const TextStyle bookAboveInput = TextStyle(
    //fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Colors.blueGrey,
    fontFamily: 'Cairo',
  );

  static const TextStyle bookInputField = TextStyle(
    //fontWeight: FontWeight.w600,
    fontSize: 13,
    color: Colors.blueGrey,
    fontFamily: 'Cairo',
  );

  static const TextStyle contactUsBio = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 17,
    height: 1.3,
    color: Colors.blueGrey,
    fontFamily: 'Cairo',
  );

  //  aya  ******

  static const TextStyle appBarTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.black,
  );
  static const TextStyle bottomNavigationTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle leavingDateTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  static const TextStyle rowTextStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
  static const TextStyle textFieldTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 10,
    color: Colors.grey,
  );
  static const TextStyle searchTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Colors.white,
  );
  static TextStyle textFormField = TextStyle(
    //fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: ColorsManager.iconColor,
    letterSpacing: 1.5,
    //height: 1.3
  );
  static const TextStyle hintFormField = TextStyle(
    //fontFamily: 'Cairo',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: ColorsManager.secondary,
    // height: 1
  );
  static const TextStyle signInTextStyle = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  static const TextStyle smallTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
  static const TextStyle travelTextStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle checkTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontSize: 13,
  );
  static const TextStyle textStyle1 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.grey,
  );
  static TextStyle textStyle2 = TextStyle(
      fontFamily: "Cairo",
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Colors.grey[400]);
  static const TextStyle textStyle3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: "Cairo",
    color: ColorsManager.primaryColor,
  );
  static const TextStyle textStyle4 = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: "Cairo",
    fontSize: 24.0,
  );
  static const TextStyle textStyle5 = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: "Cairo",
    color: Colors.black54,
    fontSize: 13.0,
  );
  static const TextStyle textStyle6 = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontFamily: "Cairo",
  );
  static const TextStyle textStyle7 = TextStyle(
    fontFamily: "Cairo",
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Colors.black,
  );
}
