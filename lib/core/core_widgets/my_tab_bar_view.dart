import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';

import '../resources_manager/style_manager.dart';



class MyTabBarView extends StatelessWidget {
  const MyTabBarView({Key? key,
    required this.length,
    required this.tabs,
    required this.onTab,
    this.isScrollable = false,
  }) : super(key: key);
  final int length;
  final List<Widget> tabs;
  final void Function(int)? onTab;
  final bool isScrollable;
  @override
  Widget build(BuildContext context) {
    return   DefaultTabController(
      length: length,
      child: TabBar(
        indicatorWeight: 2.5,
        padding: const EdgeInsets.only(right: 5),
        indicatorSize: TabBarIndicatorSize.tab,
        //indicatorPadding: const EdgeInsets.only(left: 10,right: 10),
        indicatorColor: Colors.amber,
        isScrollable: isScrollable,
        onTap: onTab,
        tabs: tabs,
      ),
    );
  }
}
