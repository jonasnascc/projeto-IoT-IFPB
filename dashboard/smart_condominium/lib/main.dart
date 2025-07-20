import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smart_condominium/app_module.dart';

import 'app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Modular.get<StorageManager>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final modularApp = ModularApp(
      module: AppModule(),
      debugMode: kDebugMode,
      child: const AppWidget(),
    );
    return modularApp;
  }
}
