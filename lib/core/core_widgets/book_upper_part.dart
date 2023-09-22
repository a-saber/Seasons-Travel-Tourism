import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';

import '../resources_manager/style_manager.dart';
import 'list_item_image.dart';

class BookUpperPart extends StatelessWidget {
  const BookUpperPart(
      {Key? key,
      required this.image,
      required this.pageTitle,
      required this.pageTitlePath})
      : super(key: key);

  final String image;
  final String pageTitle;
  final String pageTitlePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
              height: MediaQuery.of(context).size.height / 3.5,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 5),
              // padding: const EdgeInsets.symmetric(horizontal: 100),
              child: ListItemImage(image: image)),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  pageTitle,
                  style: StyleManager.hotelsBook,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      TranslationKeyManager.main.tr,
                      style: StyleManager.hotelsBookMainPath,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.blueGrey,
                        size: 12,
                      ),
                    ),
                    Text(
                      pageTitlePath,
                      style: StyleManager.hotelsBookPath,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.blueGrey,
                        size: 12,
                      ),
                    ),
                    Text(
                      pageTitle,
                      style: StyleManager.hotelsBookPath,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
