import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';

class TabBarItem extends StatelessWidget {
  const TabBarItem({Key? key, required this.label, this.selected = true}) : super(key: key);

  final bool selected;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        left: 8,
        right: 8,
        top: 10,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: selected? Colors.white: Colors.white.withOpacity(0.5), fontWeight: FontWeight.w700),
      ),
    );
  }
}

class TabBarItem2 extends StatelessWidget {
  const TabBarItem2({Key? key, required this.label}) : super(key: key);

  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
        left: 8,
        right: 8,
        top: 10,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: ColorsManager.primaryColor, fontSize: 12 ,fontWeight: FontWeight.w700),
      ),
    );
  }
}
