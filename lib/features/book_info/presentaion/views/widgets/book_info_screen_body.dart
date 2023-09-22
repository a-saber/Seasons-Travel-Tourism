import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper_keys.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';
import 'package:seasons/features/book_info/presentaion/views/widgets/textform_code.dart';
import 'package:seasons/features/sign_in/presentaion/views/widgets/default_form_field.dart';

import '../../../../../core/resources_manager/style_manager.dart';

class BookInfoScreenBody extends StatefulWidget {
  const BookInfoScreenBody({Key? key}) : super(key: key);

  @override
  State<BookInfoScreenBody> createState() => _BookInfoScreenBodyState();
}

class _BookInfoScreenBodyState extends State<BookInfoScreenBody> {
  var code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(
                color: Colors.black45,
                blurRadius: .4,
                blurStyle: BlurStyle.normal,
                offset: Offset(0, 1))
          ]),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DefaultField(
              hint: TranslationKeyManager.userName.tr,
              controller: code,
              onChange: (String? val)
              {
                setState(() {});
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: TextFormField(
            //     onChanged: (val)
            //     {
            //       setState(() {});
            //     },
            //     controller: code,
            //     style: StyleManager.bookInputField.copyWith(fontWeight: FontWeight.w700,color: ColorsManager.primaryColor),
            //     decoration: InputDecoration(
            //         labelText: TranslationKeyManager.bookSearchCodeBtn.tr,
            //         labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5),fontWeight: FontWeight.bold),
            //         enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(3),
            //             borderSide: BorderSide(
            //               color:  Colors.grey.withOpacity(0.2),
            //             )),
            //         focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(3),
            //             borderSide: BorderSide(
            //               color:  ColorsManager.primaryColor,
            //             )),
            //         contentPadding:
            //         const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
            //   ),
            // ),
            const SizedBox(
              height: 40,
            ),

            InkWell(
              onTap: code.text.isEmpty?null:
              ()
              {

              },
              child: Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: code.text.isEmpty?
                      Colors.grey:
                  ColorsManager.primaryColor,
                  borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    TranslationKeyManager.bookInquiryBtn.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Cairo",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
