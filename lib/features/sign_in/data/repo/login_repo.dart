import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

abstract class LoginRepo {
  Future<Either<Failure, LoginResponse>> userLogin(
      {required String email, required String password});

  Future<Either<Failure, RegisterResponse>> register(
      {required UserModel userModel, required String? filePath,
        required String? name,});

  Future<Either<Failure, DeleteUserResponse>> deleteUser(
      {required String userId});
}
