import 'package:flutter/material.dart';

import '../resources_manager/style_manager.dart';

class DefaultDropDown extends StatelessWidget {
  DefaultDropDown({Key? key,
    // required this.hint,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);
  //final String hint;
  String? value;
  final void Function(String?)? onChanged;
  final List<String> items;

  String? printer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2))
      ),
      //height: 30,
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: DropdownButton(
        isExpanded: true,
        style: StyleManager.bookInputField,
        underline: const SizedBox(),
        icon: const SizedBox(),
        value: value,
          items:
          items.map(buildMenuItem).toList(),
          onChanged: onChanged
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item,style:StyleManager.bookInputField,));
}