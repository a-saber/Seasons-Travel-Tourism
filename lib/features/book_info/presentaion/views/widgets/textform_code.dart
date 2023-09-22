import 'package:flutter/material.dart';

import '../../../../../core/resources_manager/style_manager.dart';

class TextFormCode extends StatelessWidget {
  const TextFormCode({Key? key, required this.text, required this.controller})
      : super(key: key);
  final String text;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      scrollPadding: EdgeInsets.zero,
      textAlign: TextAlign.center,
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: StyleManager.textStyle2,
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(30)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
