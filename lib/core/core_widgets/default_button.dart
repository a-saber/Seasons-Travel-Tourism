import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    // required this.background,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final void Function()? onPressed;
  //final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(5)),
        child: TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: StyleManager.defaultButton.copyWith(height: 1.2,fontSize: 15 ,fontWeight: FontWeight.w700),
            )),
      ),
    );
  }
}
