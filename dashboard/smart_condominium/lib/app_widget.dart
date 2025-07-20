import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/core.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Modular.get<StorageManager>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Modular-Base-App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: Modular.routerConfig,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      builder: (context, widget) {
        final mediaQuery = MediaQuery.of(context);
        final size = mediaQuery.size;

        AppConstants.instance
          ..screenHeight = size.height
          ..screenWidth = size.width;

        return widget ?? Container();
      },
    );
  }
}
