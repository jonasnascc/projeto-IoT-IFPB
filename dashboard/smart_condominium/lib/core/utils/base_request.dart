import 'dart:convert';

import 'package:http/http.dart' as http;

enum RequestType { get, post, put, delete, patch }

class AppBaseRequest {
  final String path;
  final RequestType requestType;
  final Map<String, dynamic> queryParameters;
  final Map<String, String>? headers;
  final dynamic data;

  AppBaseRequest({
    required this.path,
    this.requestType = RequestType.get,
    this.queryParameters = const {},
    this.headers,
    this.data,
  });

  Future<http.Response> sendRequest(AppBaseRequest request) async {
    // Build URI with query parameters
    final uri = Uri.parse(request.path).replace(
      queryParameters: request.queryParameters.isNotEmpty
          ? request.queryParameters.map(
              (key, value) => MapEntry(key, value.toString()),
            )
          : null,
    );
    final headers = request.headers ?? {};

    late http.Response response;

    switch (request.requestType) {
      case RequestType.get:
        response = await http.get(uri, headers: headers);
        break;
      case RequestType.post:
        response = await http.post(
          uri,
          headers: headers,
          body: json.encode(request.data),
        );
        break;
      case RequestType.put:
        response = await http.put(
          uri,
          headers: headers,
          body: json.encode(request.data),
        );
        break;
      case RequestType.delete:
        response = await http.delete(uri, headers: headers);
        break;
      case RequestType.patch:
        response = await http.patch(
          uri,
          headers: headers,
          body: json.encode(request.data),
        );
        break;
    }

    return response;
  }
}
