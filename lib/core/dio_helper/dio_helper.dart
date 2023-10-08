import 'package:dio/dio.dart';
import 'package:seasons/features/sign_in/data/models/user_model.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: "https://api.seasonsge.com",
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 5),
    ));
  }

  static Future<Response> getDate({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? ''
    };
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postDate({
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    return dio.post(endPoint, data: FormData.fromMap(query!)
        //queryParameters: query,
        );
  }

  static Future<Response> putDate({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? ''
    };
    return dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<dynamic> uploadFile({
    required String? filePath,
    required String? name,
    required UserModel user
  }) async {
    late FormData formData;
    if(filePath == null || name == null)
    {
      formData = FormData.fromMap(user.toJson());
    }
    else
    {
      formData=FormData.fromMap({
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "password": user.password,
        "type": user.type,
        "discount": user.discount,
        "balance": user.balance,
        'token':user.token??'',
        "img": await MultipartFile.fromFile(filePath, filename: name),
      });
    }

    Response response = await dio.post(
        'https://api.seasonsge.com/user-edit',
        data: formData,
    ).then((value) {
      print('suc');
      print(value.data.toString());
      return value;
    }).catchError((error){
      print('err');
      print(error.toString());
      return error;
    });
    return response;
  }

  static Future<dynamic> register({
    required String? filePath,
    required String? name,
    required UserModel user
  }) async {
    late FormData formData;
    if(filePath == null || name == null)
    {
      formData = FormData.fromMap(user.toJson());
    }
    else
    {
      formData=FormData.fromMap({
        "name": user.name,
        "email": user.email,
        "password": user.password??'',
        "type": 0,
        "discount": 0,
        "balance": 0,
        'token':user.token??'',
        "img": await MultipartFile.fromFile(filePath, filename: name),
      });
    }

    Response response = await dio.post(
        'https://api.seasonsge.com/add-user',
        data: formData,
    ).then((value) {
      print('suc');
      print(value.data.toString());
      return value;
    }).catchError((error){
      print('err');
      print(error.toString());
      return error;
    });
    return response;
  }


}
