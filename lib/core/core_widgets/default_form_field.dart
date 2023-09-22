import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';

import '../resources_manager/colors_manager.dart';
import '../resources_manager/style_manager.dart';

class DefaultFormField extends StatelessWidget {
  DefaultFormField({
    super.key,
    this.hint,
    this.enabled = true,
    required this.controller,
    this.icon,
    this.suffixIcon,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.onpress,
    this.onChange,
    this.validator,
    this.onTap,
    this.maxLines = 1,
  });

  int maxLines;
  void Function()? onTap;
  String? hint;
  bool enabled;
  bool? isPassword;
  TextEditingController controller;
  Widget? icon;
  Widget? suffixIcon;
  TextInputType textInputType;
  void Function()? onpress;
  void Function(String)? onChange;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: maxLines != 1 ?50 :30,
      child: TextFormField(
        onTap: onTap,
        validator: (value) {
          if (value!.isEmpty) {
            return TranslationKeyManager.defValidation.tr;
          }
          return null;
        },
        keyboardType: textInputType,
        controller: controller,
        onChanged: onChange,
        style: StyleManager.bookInputField,
        obscureText: isPassword!,
        obscuringCharacter: '●',
        cursorColor: Colors.blueGrey,
        maxLines: maxLines != 1 ? 5 : 1,
        minLines: maxLines != 1 ? 2 : null,
        enabled: enabled,
        decoration: InputDecoration(
            hintText: hint,
            errorStyle: StyleManager.bookInputField
                .copyWith(color: ColorsManager.tabBarIndicator),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.withOpacity(0.2),
            // suffixIconConstraints: const BoxConstraints(
            //   minWidth: 2,
            //   minHeight: 2,
            // ),
            //
            // prefixIconConstraints: const BoxConstraints(
            //   minWidth: 2,
            //   minHeight: 2,
            // ),
            // prefixIcon: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: icon!,
            // ),
            // suffixIcon: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: suffixIcon,
            // ),
            //hintText: hint,
            //hintStyle: StyleManager.bookInputField,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                  color: enabled
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.transparent,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                  color: enabled
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.transparent,
                )),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                  color: enabled
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.transparent,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                  color: enabled
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.transparent,
                )),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
      ),
    );
  }
}
// if(icon != null)
// icon!,
// const SizedBox(width: 15,),

// if(suffixIcon != null)
//   suffixIcon!

/*
TextField(
        style: const TextStyle(
            fontSize: 16,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600
        ),
          enabled: enabled,
          onChanged: onChange,
          keyboardType: textInputType,
          controller: controller,
          decoration: InputDecoration(
            icon: iconData,
            contentPadding: const EdgeInsets.only(bottom: 17),
            hintText: text,
            hintStyle: TextStyle(
              fontSize: 16,
                color: Colors.blueGrey.withOpacity(0.7),
              fontWeight: FontWeight.w600
            ),
            border: InputBorder.none,
            //prefixIcon: iconData,
          )
      )
 */
