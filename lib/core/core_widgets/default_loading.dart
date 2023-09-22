import 'package:flutter/material.dart';

import '../resources_manager/colors_manager.dart';

class DefaultLoading extends StatelessWidget {
  const DefaultLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const  Center(child: CircularProgressIndicator(color: ColorsManager.primaryColor,),);
  }
}
