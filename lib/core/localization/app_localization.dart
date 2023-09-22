import 'package:get/get.dart';

import '../local_database/cache_helper_keys.dart';
import 'ar.dart';
import 'en.dart';

class AppLocalization implements Translations
{

  @override
  Map<String, Map<String, String>> get keys =>
      {
        CacheHelperKeys.keyAR : ar,
        CacheHelperKeys.keyEN : en
      };

}