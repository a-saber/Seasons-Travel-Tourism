import 'dart:math';

import 'package:flutter/material.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';

class DefaultSettingsButton extends StatelessWidget {
  const DefaultSettingsButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.iconSize = 17,
    this.isNear = false,
  }) : super(key: key);

  final String text;
  final bool isNear;
  final double iconSize;
  final IconData icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          isNear
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                   // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds)=> LinearGradient(
                            colors: [
                              //Color(0xff9e98d5)
                              ColorsManager.primaryTwoColor,
                              ColorsManager.primaryColor,
                              //ColorsManager.primaryTwoColor,
                            ]).createShader(bounds),
                        child: Icon(
                          icon,
                          size: iconSize,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ShaderMask(
                        shaderCallback: (bounds)=> LinearGradient(
                            colors: [
                              //Color(0xff9e98d5)
                              ColorsManager.primaryColor,
                              ColorsManager.primaryTwoColor,
                            ]).createShader(bounds),
                        child: Text(
                          text,
                          style: StyleManager.defaultSettingsBtn
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Text(
                        text,
                        style: StyleManager.defaultSettingsBtn.copyWith(color: ColorsManager.primaryColor),
                      ),
                      const Spacer(),
                      Transform.rotate(
                          angle:
                              CacheData.lang == CacheHelperKeys.keyEN ? pi : 0,
                          child: Icon(
                            icon,
                            size: iconSize,
                            color: ColorsManager.primaryColor,
                          ))
                    ],
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 50.0),
          //   child: Divider(
          //     color: Colors.grey.withOpacity(0.2),
          //   ),
          // ),
        ],
      ),
    );
  }
}
