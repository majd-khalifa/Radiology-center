import 'package:dio/dio.dart';

class Failure {
  final String errorMessage;
  Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure("Connection timeout with server");

      case DioExceptionType.sendTimeout:
        return ServerFailure("Send timeout with server");

      case DioExceptionType.receiveTimeout:
        return ServerFailure("Receive timeout with server");

      case DioExceptionType.badCertificate:
        return ServerFailure("Bad certificate from server");

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(dioError.response!.statusCode);

      case DioExceptionType.cancel:
        return ServerFailure("Request was cancelled");

      case DioExceptionType.connectionError:
        return ServerFailure("No internet connection");

      case DioExceptionType.unknown:
        if (dioError.message!.contains("socetException")) {
          return ServerFailure("no internet connection");
        }
        return ServerFailure("Unkown error, please try again");
      // ignore: unreachable_switch_default
      default:
        return ServerFailure("Unexpected error, please try again");
    }
  }

  factory ServerFailure.fromResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return ServerFailure("Bad request, please check your input");
      case 401:
        return ServerFailure("Unauthorized, please login again");
      case 403:
        return ServerFailure("Access denied");
      case 404:
        return ServerFailure("Request not found");
      case 500:
        return ServerFailure("Internal server error, try again later");
      default:
        return ServerFailure("Unexpected server error");
    }
  }
}
