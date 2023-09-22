import 'package:flutter/material.dart';

import 'default_form_field.dart';

class DefaultDatePicker extends StatelessWidget {
  const DefaultDatePicker({
    Key? key,
    required this.controller,
    this.onTap,
  }) : super(key: key);
  final TextEditingController controller;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
            ).then((value) {
              controller.text = value.toString().substring(0, 10);
            });
          },
      child: DefaultFormField(
        enabled: false,
        controller: controller,
        textInputType: TextInputType.datetime,
        //onTap: ,
        hint: '',
      ),
    );
  }
}
/*
class DefaultDatePicker extends StatelessWidget {
  const DefaultDatePicker(
      {Key? key, required this.controller, required this.onTap})
      : super(key: key);
  final TextEditingController controller;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return DefaultFormField(
      controller: controller,
      textInputType: TextInputType.datetime,
      onTap: onTap,
      // onTap: () {
      //   showDatePicker(
      //     context: context,
      //     initialDate: DateTime.now(),
      //     firstDate: DateTime.now(),
      //     lastDate: DateTime(2200),
      //   ).then((value) {
      //     controller.text = value.toString().substring(0, 10);
      //     print("************************");
      //     print(controller.text);
      //   });
      //   print("************************");
      //   print(controller.text);
      // },
      hint: '',
    );
  }
}


Widget defaultDatePicker({
  required context,
  required String label,
  required var controller,
  int? firstDate = 2000,
  int? lastDate = 2030,
  dynamic Function()? onTap,
}) =>
    defaultFormField(
      label: label,
      controller: controller,
      prefix: Icons.date_range,
      type: TextInputType.datetime,
      onTap: onTap ??
          () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(firstDate!),
              lastDate: DateTime(lastDate!),
            ).then((value) {
              controller.text = value.toString().substring(0, 10);
            });
          },
    );
 */
