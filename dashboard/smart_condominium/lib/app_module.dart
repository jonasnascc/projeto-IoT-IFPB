import 'package:flutter_modular/flutter_modular.dart';

import 'core/core.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);

    i
      ..addSingleton<StorageManager>(() => StorageManager.instance)
      ..addSingleton<NavigatorManager>(() => NavigatorManager.instance);
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);

    r
      ..child('/', child: (context) => const LoginPage())
      ..child(HomePage.route, child: (context) => const HomePage());
  }
}
