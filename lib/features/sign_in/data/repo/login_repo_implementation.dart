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

  @override
  Future<Either<Failure, DeleteUserResponse>> deleteUser({required String userId}) async {
    try {
      var data = await DioHelper.getDate(url: 'delete-user', query:
      {
        "user_id": userId
      });
      print(data.data!.toString());
      DeleteUserResponse deleteUserResponse = DeleteUserResponse.fromJson(data.data);
      if(deleteUserResponse.status=="success")
      return right(deleteUserResponse);
      else
        return left(ServerFailure(deleteUserResponse.message!));
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
