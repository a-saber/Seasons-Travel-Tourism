import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seasons/core/core_widgets/my_snack_bar.dart';
import 'package:seasons/core/dio_helper/dio_helper.dart';
import 'package:seasons/core/local_database/cache_data.dart';
import 'package:seasons/core/local_database/cache_helper.dart';
import 'package:seasons/features/home/cubit/home_cubit.dart';
import 'package:seasons/features/sign_in/data/models/user_model.dart';

import '../../../../../core/core_widgets/flutter_toast.dart';
import '../../../data/repo/login_repo_implementation.dart';
import 'login_states.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this.loginRepoImplementation) : super(LoginInitialState());
  final LoginRepoImplementation loginRepoImplementation;
  static LoginCubit get(context) => BlocProvider.of(context);
  UserModel? userModel;
  Future<void> userLogin({
    required String email,
    required String password,required context
  }) async
  {
    emit(LoginLoadingState());
    var result = await loginRepoImplementation.userLogin(
        email: email, password: password);
    result.fold((failure) {
      print("errrrrrrrrrrrrror");
      print(failure.errorMessage.toString());
      emit(LoginErrorState(failure.errorMessage));
      showToast(massage: failure.errorMessage, state: ToastState.ERROR);
    }, (loginResponse) async{
      if (loginResponse.success!) {
       // showToast(massage: "Login Successfully", state: ToastState.SUCCESS);
        print("Login Successfully");
        print(loginResponse.data!.email);
        userModel = loginResponse.data;
        CacheData.password = userModel!.password;
        CacheData.email = userModel!.email;
        await CacheHelper.saveData(key: 'email', value: userModel!.email);
        await CacheHelper.saveData(key: 'password', value: userModel!.password);
        HomeCubit.get(context).Login();
        emit(LoginSuccessState(loginResponse.data!));
      } else {
        emit(LoginErrorState("بيانات الدخول غير صحيحة"));
        showToast(massage: "بيانات الدخول غير صحيحة", state: ToastState.ERROR);
      }
    });
  }

  Future<void> userDelete(context) async
  {
    emit(DeleteUserLoadingState());
    var result = await loginRepoImplementation.deleteUser(
        userId: userModel!.id.toString());
    result.fold((failure) {
      print("errrrrrrrrrrrrror");
      print(failure.errorMessage.toString());
      emit(DeleteUserErrorState(failure.errorMessage));
      showToast(massage: failure.errorMessage, state: ToastState.ERROR);
    }, (deleteResponse) async{
        showToast(massage: "Deleted Successfully", state: ToastState.SUCCESS);
        userModel = null;
        CacheData.password = null;
        CacheData.email = null;
        await CacheHelper.removeData(key: 'email');
        await CacheHelper.removeData(key: 'password');
        HomeCubit.get(context).Logout();
        emit(DeleteUserSuccessState());
    });
  }



  File? registerImage;
  Future<void> register({
    required UserModel user,
    required context
  }) async
  {
    emit(RegisterLoadingState());
    var result = await loginRepoImplementation.register(
        filePath: registerImage==null? null: registerImage!.path,
        name: registerImage==null? null:Uri.file(registerImage!.path).pathSegments.last,
        userModel:user);
    result.fold((failure) {
      emit(RegisterErrorState(failure.errorMessage));
      callMySnackBar(text: failure.errorMessage, context: context);
    }, (loginResponse) async{
      if (loginResponse.success!) {
        callMySnackBar(text: loginResponse.message!, context: context);
        emit(RegisterSuccessState());
      } else {
        callMySnackBar(text: loginResponse.message!, context: context);
        emit(RegisterErrorState(loginResponse.message!));
      }
    });
  }

  void logout() async
  {
    await CacheHelper.removeData(key: 'email');
    await CacheHelper.removeData(key: 'password');
    CacheData.password = null;
    CacheData.email = null;
    userModel = null;
    emit(LogoutState());
  }

  File? profileImage;
  Future<void> getImage(ImageSource source) async {
    File? picked;
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      final imageTemporary = File(image.path);
      picked = imageTemporary;
      profileImage = imageTemporary;

      emit(GetImageSuccessState());
    }
    else
    {
      emit(GetImageErrorState());
    }
  }
  Future<void> getRegisterImage(ImageSource source) async {
    File? picked;
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      final imageTemporary = File(image.path);
      picked = imageTemporary;
      registerImage = imageTemporary;
      emit(GetImageSuccessState());
    }
    else
    {
      emit(GetImageErrorState());
    }
  }


  Future<void> update({required UserModel user, required context}) async {

    emit(UploadLoadingState());
      DioHelper.uploadFile(
        user: user,
          filePath: profileImage==null? null: profileImage!.path,
          name: profileImage==null? null:Uri.file(profileImage!.path).pathSegments.last)
          .then((value) async {
        emit(UploadSuccessState());
        await userLogin(email: user.email!, password: user.password!, context: context);
      }).catchError((error) {
        print(error.toString());
        if(error.toString()=='DioError [connection timeout]: The request connection took longer than 0:00:05.000000. It was aborted.I/flutter ( 3606): Invalid argument(s) (onError): The error handler of Future.catchError must return a value of the future\'s type')
          emit(UploadErrorState('No internet connection'));
        else
        if(error is DioError)
        {
          if(error.type == DioErrorType.connectionTimeout)
            emit(UploadErrorState('No internet connection'));
          else
            emit(UploadErrorState('sorry, error happened try again later'));
        }else
          emit(UploadErrorState('sorry, error happened try again later'));
      });
  }


}
