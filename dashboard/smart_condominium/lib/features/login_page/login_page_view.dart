import 'package:flutter/material.dart';

import 'login_page_view_model.dart';

class LoginPageView extends LoginPageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: [
            const Text('Login'),
            TextButton(onPressed: onLogin, child: const Text('login'))
          ],
        ));
  }
}
