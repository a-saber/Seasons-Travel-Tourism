import 'package:dio/dio.dart';

abstract class Failure
{
  final String errorMessage;
  Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioError(DioError dioError)
  {
    switch (dioError.type)
    {
      case DioErrorType.connectionTimeout:
        return ServerFailure('تأكد من الاتصال بالانترنت');
        return ServerFailure('Connection timeout with ApiServer');
      case DioErrorType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');
      case DioErrorType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioErrorType.badResponse:
        return ServerFailure('Connection timeout with ApiServer');
      case DioErrorType.cancel:
        return ServerFailure('Request to ApiServer was canceled');
      // case DioErrorType.unknown:
      //   if (dioError.message!.contains('SocketException')){
      //     return ServerFailure('No Internet Connection');
      //   }
        //return ServerFailure('Unexpected Error, please try again!');
        default:
          return ServerFailure('تأكد من الاتصال بالانترنت');

    //  return ServerFailure('Ops Connection timeout, please try again later!');
        //  return ServerFailure('Ops There was an error, please try again later!');
    }
  }
  factory ServerFailure.fromResponse( int? statusCode, dynamic response)
  {
    if ( statusCode == 400 ||  statusCode == 401 ||  statusCode == 403 ){
      return ServerFailure(response['error']['message']);
    }
    else if( statusCode == 404){
      return ServerFailure("Your Request not found, please try again later!");
    }
    else if( statusCode == 500){
      return ServerFailure("Internal Server Error, please try again later!");
    }
    else {
      return ServerFailure("Ops There was an error, please try again later!");
    }
  }
}