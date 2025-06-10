import 'package:flutter_modular/flutter_modular.dart';
import 'package:smart_condominium/core/managers/mqqt_manager.dart';

import 'core/core.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);

    i
      ..addSingleton<StorageManager>(() => StorageManager.instance)
      ..addSingleton<MqttManager>(() => MqttManager.instance)
      ..addSingleton<NavigatorManager>(() => NavigatorManager.instance);
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child('/', child: (context) => const HomePage());
  }
}
