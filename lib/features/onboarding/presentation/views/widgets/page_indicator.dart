import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/resources_manager/colors_manager.dart';
import '../../../data/boarding_data.dart';

class PageIndicatorScreen extends StatelessWidget {
  const PageIndicatorScreen({Key? key, required this.boardController})
      : super(key: key);
  final PageController boardController;
  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
        controller: boardController,
        effect: ExpandingDotsEffect(
            dotColor: Colors.grey[200]!,
            activeDotColor: ColorsManager.redColor,
            dotHeight: 10,
            expansionFactor: 4,
            dotWidth: 10,
            spacing: 5.0),
        count: BoardingData.boarding.length);
  }
}
