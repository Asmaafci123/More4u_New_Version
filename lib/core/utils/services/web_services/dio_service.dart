import 'package:dio/dio.dart';

enum HttpMethod { GET, POST, PUT, DELETE, PATCH }

class DioService {
  static Future<Response> request(
      {required String url,
      required HttpMethod method,
      dynamic data,
      Map<String, dynamic>? queryParameters}) async {
    Response response;
    switch (method) {
      case HttpMethod.GET:
        response = await Dio().get(
          url,
          queryParameters: queryParameters,
        );
        break;
      case HttpMethod.POST:
        response = await Dio().post(url,
            data: data, queryParameters: queryParameters, options: Options());
        break;
      case HttpMethod.PUT:
        response = await Dio().put(
          url,
          data: data,
          queryParameters: queryParameters,
        );
        break;
      case HttpMethod.DELETE:
        response = await Dio().delete(
          url,
          data: data,
          queryParameters: queryParameters,
        );
        break;
      case HttpMethod.PATCH:
        response = await Dio().patch(
          url,
          data: data,
          queryParameters: queryParameters,
        );
        break;
    }

    return response;
  }
}
