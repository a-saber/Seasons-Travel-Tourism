import 'package:dartz/dartz.dart';
import 'package:seasons/features/settings/data/models/about_model.dart';
import 'package:seasons/features/settings/data/models/info_model.dart';
import 'package:seasons/features/settings/data/models/privacy_model.dart';
import 'package:seasons/features/settings/data/models/terms_model.dart';

import '../../../../core/errors/failures.dart';

abstract class SettingsRepo {
  Future<Either<Failure, List<PrivacyModel>>> getAllPrivacy();
  Future<Either<Failure, List<TermsModel>>> getAllTerms();
  Future<Either<Failure, List<InfoModel>>> getAllInfo();
  Future<Either<Failure, List<AboutModel>>> getAbout();
}
