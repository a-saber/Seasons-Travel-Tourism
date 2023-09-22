import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/features/hotels/presentation/views/widgets/hotels_view_body.dart';

import '../../../../core/core_widgets/default_app_bar.dart';

class HotelView extends StatelessWidget {
  const HotelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HotelsViewBody();

  }
}
