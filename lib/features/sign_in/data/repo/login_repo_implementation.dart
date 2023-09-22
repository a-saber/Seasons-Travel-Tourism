import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:seasons/core/dio_helper/end_points.dart';
import 'package:seasons/features/sign_in/data/models/user_model.dart';

import '../../../../core/dio_helper/dio_helper.dart';
import '../../../../core/errors/failures.dart';
import 'login_repo.dart';

class LoginRepoImplementation extends LoginRepo {
  LoginRepoImplementation();

  @override
  Future<Either<Failure, LoginResponse>> userLogin(
      {required String email, required String password}) async {
    try {
      var data = await DioHelper.postDate(endPoint: EndPoints.LOGIN, query: {
        'email': email,
        'password': password,
      });
      print(data.data!.toString());
      LoginResponse loginResponse = LoginResponse.fromJson(data.data);
      return right(loginResponse);
    } catch (e) {
      print("Nooooooooooooooooo");
      print(e.toString());
      if (e is DioError) {
        print("diooooooooooo Nooooooooooooooooo");
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterResponse>> register({required UserModel userModel, required String? filePath,
    required String? name,}) async {
    try {
      // Map<String, dynamic> userJson ={
      //   "id": userModel.id,
      //   "name": userModel.name,
      //   "email": userModel.email,
      //   "password": userModel.password,
      //   "type": userModel.type,
      //   "discount": userModel.discount,
      //   "balance": userModel.balance,
      //   "img": await MultipartFile.fromFile(filePath!, filename: name),
      // };
      var data = await DioHelper.register( name: name, filePath: filePath, user: userModel);
      print(data.data!.toString());
      RegisterResponse registerResponse = RegisterResponse.fromJson(data.data);
      return right(registerResponse);
    } catch (e) {
      print("Nooooooooooooooooo");
      print(e.toString());
      if (e is DioError) {
        print("diooooooooooo Nooooooooooooooooo");
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

}