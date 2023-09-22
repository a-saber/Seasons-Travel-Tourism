import 'package:flutter/material.dart';

import '../../../data/boarding_data.dart';
import 'board_item.dart';

class PageViewScreen extends StatelessWidget {
  const PageViewScreen({Key? key, required this.boardController})
      : super(key: key);
  final PageController boardController;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: boardController,
        onPageChanged: (int index) {
          // if (index == BoardingData.boarding.length - 1) {
          //   isLast = true;
          // } else {
          //   isLast = false;
          // }
        },
        itemBuilder: (context, index) => BoardItem(
          index: index,
          model: BoardingData.boarding[index],
        ),
        itemCount: BoardingData.boarding.length,
      ),
    );
  }
}
