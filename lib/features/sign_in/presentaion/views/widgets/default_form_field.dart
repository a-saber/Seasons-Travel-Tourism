import 'package:flutter/material.dart';

import '../../../../../core/resources_manager/colors_manager.dart';
import '../../../../../core/resources_manager/style_manager.dart';

class DefaultField extends StatelessWidget {
  DefaultField({
    super.key,
    required this.hint,
    this.enabled,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.fillColor = Colors.white,
    this.onpress,
    this.onChange,
    this.validator,
    this.prefix,
    this.horizontalPadding = 30,
  });

  final Color? fillColor;
  final Widget? prefix;
  String hint;
  bool? enabled;
  bool? isPassword;
  TextEditingController controller;
  TextInputType textInputType;
  void Function()? onpress;
  void Function(String)? onChange;
  String? Function(String?)? validator;
  final double horizontalPadding ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        validator: (String? val)
        {
          if(val!.isEmpty) {
            return 'This field must not be empty';
          }
           return null;
        },
        keyboardType: textInputType,
        controller: controller,
        onChanged: onChange,
        style: StyleManager.textFormField.copyWith(color: Colors.black, letterSpacing: 1),
        obscureText: isPassword!,
        obscuringCharacter: '●',
        cursorColor: Colors.grey.withOpacity(0.2),
        enabled: enabled,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
              fontFamily: "Cairo",
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.red),
          //filled: true,
          contentPadding: const EdgeInsetsDirectional.only(start: 10),
          fillColor: fillColor,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 2,
            minHeight: 2,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 2,
            minHeight: 2,
          ),
          prefixIcon: prefix,
          hintText: hint,
          hintStyle: StyleManager.hintFormField,
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          focusedErrorBorder:  UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
            color: Colors.red,
          )),
          errorBorder:  UnderlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
            color: Colors.red,
          )
          ),
        ),
      ),
    );
  }
}


class DefaultField2 extends StatelessWidget {
  DefaultField2({
    super.key,
    required this.hint,
    this.enabled,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.fillColor = Colors.white,
    this.onpress,
    this.onChange,
    this.validator,
    this.prefix,
    this.horizontalPadding = 30,
  });

  final Color? fillColor;
  final Widget? prefix;
  String hint;
  bool? enabled;
  bool? isPassword;
  TextEditingController controller;
  TextInputType textInputType;
  void Function()? onpress;
  void Function(String)? onChange;
  String? Function(String?)? validator;
  final double horizontalPadding ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        validator: (String? val)
        {
          if(val!.isEmpty) {
            return 'This field must not be empty';
          }
          return null;
        },
        keyboardType: textInputType,
        controller: controller,
        onChanged: onChange,
        style: StyleManager.textFormField.copyWith(color: Colors.black, letterSpacing: 1),
        obscureText: isPassword!,
        obscuringCharacter: '●',
        cursorColor: Colors.grey.withOpacity(0.2),
        enabled: enabled,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
              fontFamily: "Cairo",
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.red),
          //filled: true,
          contentPadding: const EdgeInsetsDirectional.only(start: 10),
          fillColor: fillColor,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 2,
            minHeight: 2,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 2,
            minHeight: 2,
          ),
          prefixIcon: prefix,
          hintText: hint,
          labelText: hint,
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: StyleManager.hintFormField,
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          focusedErrorBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.red,
              )),
          errorBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.red,
              )),
        ),
      ),
    );
  }
}
