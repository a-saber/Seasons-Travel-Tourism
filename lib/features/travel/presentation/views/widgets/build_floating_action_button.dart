import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../sign_in/presentaion/views/sign_in_screen.dart';

class BuildFloatingActionButton extends StatelessWidget {
  const BuildFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => const SignInScreen(),
            transition: Transition.downToUp,
            duration: const Duration(seconds: 1),
          );
        },
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
        child: const RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.key_outlined,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
