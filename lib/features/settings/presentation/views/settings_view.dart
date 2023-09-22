import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/core_widgets/default_app_bar.dart';
import '../../../../core/localization/translation_key_manager.dart';
import 'widgets/settings_view_body.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.shade100,
      appBar: defaultAppBar(
          context: context, text: TranslationKeyManager.settings.tr),
      body: const SettingsViewBody(),
    );
  }
}
