import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/core.dart';

abstract class LoginPageViewModel extends State<LoginPage> {
  TextEditingController cpfcontroller = TextEditingController(text: "");
  TextEditingController passwordcontroller = TextEditingController(text: "");
  final _storageManager = Modular.get<StorageManager>();
  final _navigatorManager = Modular.get<NavigatorManager>();
  bool isPasswordVisible = false;
  bool isCheck = true;

  @override
  void initState() {
    super.initState();

/*
    setState(() {
      cpfcontroller.text =
          StorageManager.instance.getString(Storage.instance.userLoginKey) ??
              '';
      passwordcontroller.text =
          StorageManager.instance.getString(Storage.instance.userPasswordKey) ??
              '';
    });

    */
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onLogin() async {
    await _navigatorManager.to(HomePage.route);
  }

  void setPersistedLogin(String login, String password) {
    if (isCheck == true) {
      _storageManager.setString(Storage.instance.userLoginKey, login);
      _storageManager.setString(Storage.instance.userPasswordKey, password);
    } else {
      _storageManager.setString(Storage.instance.userLoginKey, '');
      _storageManager.setString(Storage.instance.userPasswordKey, '');
    }
  }
}
