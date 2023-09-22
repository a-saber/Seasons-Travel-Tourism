import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class DelayManager
{
  // splash
  static const Duration durationSplashAnimation = Duration(seconds: 1);
  static Tween<Offset> tweenSplashAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -2),
  );
  static const Duration durationSplashToHome = Duration(milliseconds: 1500);
  static const Transition transitionSplashToHome = Transition.fadeIn;

  // hotels to hotel details
  static const Transition transitionToHotelDetails = Transition.downToUp;
  static const Curve curveToHotelDetails = Curves.linearToEaseOut;
  static const Duration durationTransitionToHotelDetails = Duration(milliseconds: 500);

  // hotel to Book details
  static const Transition transitionToBook = Transition.rightToLeft;
  static const Curve curveToBook = Curves.linearToEaseOut;
  static const Duration durationTransitionToBook = Duration(milliseconds: 500);

  // hotel to Book details
  static const Transition leftToRight = Transition.leftToRight;
  static const Transition fade = Transition.fadeIn;




}