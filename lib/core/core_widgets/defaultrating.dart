import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../resources_manager/colors_manager.dart';

class DefaultRating extends StatelessWidget {
  const DefaultRating({Key? key, required this.rate}) : super(key: key);
  final double rate;

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.ltr,
      child: RatingBar(
          ignoreGestures: true,
          tapOnlyMode: true,
          direction: Axis.horizontal,
          allowHalfRating: true,
          glowColor: Colors.white,
          updateOnDrag: false,
          initialRating: rate,
          itemSize: 20,
          itemCount:5,
          ratingWidget: RatingWidget(
              full: const Icon(Icons.star,
                  color: ColorsManager.star),
              half: const Icon(
                Icons.star_half,
                color:  ColorsManager.star,
              ),
              empty: const Icon(
                Icons.star_outline,
                color: Colors.grey,
              )),
        onRatingUpdate: (double value) {  },
          ),
    );
  }
}
