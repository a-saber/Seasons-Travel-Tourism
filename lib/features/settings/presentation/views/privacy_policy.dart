import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:seasons/core/core_widgets/basic_view.dart';
import 'package:seasons/core/core_widgets/default_app_bar.dart';
import 'package:seasons/core/localization/translation_key_manager.dart';
import 'package:seasons/core/resources_manager/style_manager.dart';
import 'package:seasons/features/settings/presentation/cubit/privacy_cubit/privacy_cubit.dart';
import 'package:seasons/features/settings/presentation/cubit/privacy_cubit/privacy_states.dart';

import '../../../../../core/local_database/cache_data.dart';
import '../../../../../core/local_database/cache_helper_keys.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    PrivacyCubit.get(context).getPrivacy(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
          context: context,
          text: TranslationKeyManager.privacyPolicy.tr,
      ),
      body: BasicView(
          bottomPadding: 20,
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            SizedBox(
                height: 100,
                child: Image.asset('assets/images/logo.PNG')),
            const SizedBox(height: 30,),
            // Text(
            //   TranslationKeyManager.privacyPolicy.tr,
            //   style: StyleManager.defaultHeadLine.copyWith(fontSize: 21),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            BlocBuilder<PrivacyCubit, PrivacyStates>(
              builder: (context, state) {
                if (state is GetAllPrivacyErrorState)
                  return Center(child: Text(state.error),);
                return state is GetAllPrivacyLoadingState
                    ? Center(child: CircularProgressIndicator())
                    : CacheData.lang == CacheHelperKeys.keyEN
                    ? Text(
                  '''${PrivacyCubit.get(context).privacyModel[0].privacypolicyEn}''',
                  textAlign: TextAlign.start,
                  style: StyleManager.contactUsBio.copyWith(color: Colors.grey.withOpacity(0.5)),
                )
                    : Text(
                  '''${PrivacyCubit.get(context).privacyModel[0].privacypolicyAr}''',
                  textAlign: TextAlign.start,
                  style: StyleManager.contactUsBio.copyWith(color: Colors.grey.withOpacity(0.5)),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
