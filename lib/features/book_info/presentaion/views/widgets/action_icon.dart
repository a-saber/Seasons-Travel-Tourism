import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActionIcon extends StatelessWidget {
  const ActionIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8.0),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: const CircleAvatar(
          radius: 11,
          backgroundColor: Colors.red,
          child: CircleAvatar(
            radius: 9,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}
