import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core.dart';

class LoginRepository {
  LoginRepository._();
  static final instance = LoginRepository._();

  Future<LoginModel?> getLogin(String cpf, String senha) async {
    LoginModel? loginModel;
    final request = AppBaseRequest(
      path: 'url da api',
      requestType: RequestType.post,
      headers: {
        'Content-Type': 'application/json',
      },
      data: {
        'cpf': cpf,
        'senha': senha,
      },
    );

    try {
      final response = await request.sendRequest(request);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        loginModel = LoginModel.fromJson(responseJson);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro na chamada da API: $e');
      }
    }

    return loginModel;
  }
}
