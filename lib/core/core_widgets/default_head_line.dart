import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';

import '../resources_manager/colors_manager.dart';

class DefaultHeadLine extends StatelessWidget {
  DefaultHeadLine(
      {Key? key,
      required this.text,
      required this.icon,
      this.color = ColorsManager.appBarTitleContainer})
      : super(key: key);

  final String text;
  final IconData? icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.only(bottom: 12, right: 10, left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.amber.shade700, offset: const Offset(0, 1)),
            const BoxShadow(color: Colors.white, offset: Offset(1, 0)),
            const BoxShadow(color: Colors.white, offset: Offset(-1, 0)),
          ]),
      child: Row(
        children: [
          Text(
            text,
            style: StyleManager.defaultHeadLine,
          ),
          const Spacer(),
          Icon(
            icon,
            size: 17,
          )
        ],
      ),
    );
  }
}

/*
return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorsManager.appBarTitleContainer
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 0.5),
        padding: const EdgeInsets.only(bottom: 12,right: 5,left: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white
        ),
        child: Row(
          children:
          [
            Text(text, style: StyleManager.defaultHeadLine,),
            const Spacer(),
            Icon(icon,size: 17,)
          ],
        ),
      ),
    );
 */
