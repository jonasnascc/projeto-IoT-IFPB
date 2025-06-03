import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NavigatorManager {
  NavigatorManager._();
  // final pathNotifier = ValueNotifier<String>(Splash.route);

  static final instance = NavigatorManager._();

  final _modularTo = Modular.to;

  Future<void> launchUrl(String url) async => await launchUrlString(url);

  Future<void> to(String route) async => await _modularTo.pushNamed(route);
}
