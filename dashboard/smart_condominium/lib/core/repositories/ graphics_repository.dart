import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../core.dart';

class GraphicsRepository {
  GraphicsRepository._();
  static final instance = GraphicsRepository._();

  Future<PortaoResponseModel?> getPortaoData({int? limit, int? offset}) async {
    PortaoResponseModel? portaoResponse;

    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final request = AppBaseRequest(
      path: 'http://35.215.235.202:3000/api/portao',
      requestType: RequestType.get,
      headers: {'Content-Type': 'application/json'},
      queryParameters: queryParams,
    );

    try {
      final response = await request.sendRequest(request);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        portaoResponse = PortaoResponseModel.fromJson(responseJson);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro na chamada da API portao: $e');
      }
    }
    log(
      'Portão response: ${portaoResponse?.toJson()}',
      name: 'GraphicsRepository',
    );
    return portaoResponse;
  }

  Future<CaixaResponseModel?> getCaixaData({int? limit, int? offset}) async {
    CaixaResponseModel? caixaResponse;

    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final request = AppBaseRequest(
      path: 'http://35.215.235.202:3000/api/caixa',
      requestType: RequestType.get,
      headers: {'Content-Type': 'application/json'},
      queryParameters: queryParams,
    );

    try {
      final response = await request.sendRequest(request);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        caixaResponse = CaixaResponseModel.fromJson(responseJson);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro na chamada da API caixa: $e');
      }
    }

    return caixaResponse;
  }

  Future<EnergiaResponseModel?> getEnergiaData({
    int? limit,
    int? offset,
  }) async {
    EnergiaResponseModel? energiaResponse;

    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    final request = AppBaseRequest(
      path: 'http://35.215.235.202:3000/api/energia',
      requestType: RequestType.get,
      headers: {'Content-Type': 'application/json'},
      queryParameters: queryParams,
    );

    try {
      final response = await request.sendRequest(request);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        energiaResponse = EnergiaResponseModel.fromJson(responseJson);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro na chamada da API energia: $e');
      }
    }

    return energiaResponse;
  }
}
