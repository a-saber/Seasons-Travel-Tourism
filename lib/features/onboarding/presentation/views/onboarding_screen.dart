import 'package:flutter/material.dart';
import 'package:seasons/features/onboarding/presentation/views/widgets/page_indicator.dart';
import 'package:seasons/features/onboarding/presentation/views/widgets/page_view.dart';

class OnBoardingscreen extends StatefulWidget {
  const OnBoardingscreen({super.key});

  @override
  State<OnBoardingscreen> createState() => _OnBoardingscreenState();
}

class _OnBoardingscreenState extends State<OnBoardingscreen> {
  var boardController = PageController();

  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(top: 70.0, left: 15, right: 15),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  PageViewScreen(
                    boardController: boardController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Center(
                      child: PageIndicatorScreen(
                        boardController: boardController,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
