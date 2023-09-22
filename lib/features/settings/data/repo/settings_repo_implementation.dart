import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:seasons/features/settings/data/models/about_model.dart';
import 'package:seasons/features/settings/data/models/info_model.dart';
import 'package:seasons/features/settings/data/models/privacy_model.dart';
import 'package:seasons/features/settings/data/models/terms_model.dart';
import 'package:seasons/features/settings/data/repo/settings_repo.dart';

import '../../../../core/dio_helper/dio_helper.dart';
import '../../../../core/dio_helper/end_points.dart';
import '../../../../core/errors/failures.dart';

class SettingsRepoImplementation extends SettingsRepo {
  SettingsRepoImplementation();

  @override
  Future<Either<Failure, List<InfoModel>>> getAllInfo() async {
    try {
      var data = await DioHelper.getDate(
        url: EndPoints.INFO,
      );
      print("all info typppppppppppppppppes");
      print(data.data.toString());
      List<InfoModel> info = [];
      data.data.forEach((element) {
        info.add(InfoModel.fromJson(element));
      });
      return right(info);
    } catch (e) {
      print("info eeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrrooor");
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PrivacyModel>>> getAllPrivacy() async {
    try {
      var data = await DioHelper.getDate(
        url: EndPoints.PRIVACY,
      );
      print("all privacy typppppppppppppppppes");
      print(data.data.toString());
      List<PrivacyModel> privacy = [];
      data.data.forEach((element) {
        privacy.add(PrivacyModel.fromJson(element));
      });
      return right(privacy);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrrooor");
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TermsModel>>> getAllTerms() async {
    try {
      var data = await DioHelper.getDate(
        url: EndPoints.TERMS,
      );
      print("all Terms typppppppppppppppppes");
      print(data.data.toString());
      List<TermsModel> terms = [];
      data.data.forEach((element) {
        terms.add(TermsModel.fromJson(element));
      });
      return right(terms);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrrrrooor");
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AboutModel>>> getAbout() async{
    try {
      var data = await DioHelper.getDate(
        url: '/about',
      );
      //final parsed = jsonDecode(data.data.toString()).cast<Map<String, dynamic>>();
      print("all Terms about ");
      print(data.data.toString());
      List<AboutModel> terms = [];
      data.data.forEach((element) {
        terms.add(AboutModel.fromJson(element));
      });
      return right(terms);
    } catch (e) {
      print("error about");
      print(e.toString());
      if (e is DioError) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
