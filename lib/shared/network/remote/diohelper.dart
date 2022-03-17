import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:todo_tasks_with_alert/shared/componets/constants.dart';

class DioHelper {
  static Dio? dio;

  static Future<void> init() async {
    dio = Dio(BaseOptions(
        baseUrl: ' https://fcm.googleapis.com/fcm/send',
        receiveDataWhenStatusError: true));

    // erooooorrrr befor added this
    //DioError [DioErrorType.other]: HandshakeException: Handshake error in client (OS Error: I/flutter ( 9085):
    // CERTIFICATE_VERIFY_FAILED: unable to get local issuer certificate(handshake.cc:359))

    (dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  static Future<Response> getData(
      {required String url, required Map<String, dynamic> query}) async {
    return await dio!.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    dio!.options.headers = {
      'Authorization': 'key=$API_FCM_KEY',
      'Content-Type': 'application/json',
    };

    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
