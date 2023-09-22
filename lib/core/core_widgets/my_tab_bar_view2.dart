import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';

import '../resources_manager/style_manager.dart';

class MyTabBarView2 extends StatelessWidget {
  const MyTabBarView2({
    Key? key,
    required this.length,
    required this.tabs,
    required this.onTab,
  }) : super(key: key);
  final int length;
  final List<Widget> tabs;
  final void Function(int)? onTab;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: length,
      child: TabBar(
        padding: const EdgeInsets.only(right: 5),
        // indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.blue.shade700,
        unselectedLabelColor: Colors.black,
        labelStyle: StyleManager.hotelItemDetailsDesc.copyWith(color: Colors.blue.shade700),
        unselectedLabelStyle: StyleManager.hotelItemDetailsDesc,
        isScrollable: true,
        indicatorPadding: const EdgeInsets.symmetric(),
        indicatorColor: Colors.amber,
        indicatorSize: TabBarIndicatorSize.values.first,
        // isScrollable: isScrollable,
        onTap: onTab,
        tabs: tabs,
      ),
    );
  }
}
