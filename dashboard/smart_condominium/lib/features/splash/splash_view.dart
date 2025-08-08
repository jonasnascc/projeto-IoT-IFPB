import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smart_condominium/core/core.dart';
import 'package:smart_condominium/core/managers/navigator_manager.dart';
import './splash_view_model.dart';

/// View - Responsável apenas pela apresentação (UI)
/// Herda do ViewModel para acessar estado e lógica de negócio
class SplashView extends SplashViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.8 + 0.2 * value,
                child: const Text(
                  'smartCondominium',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            );
          },
          onEnd: () async {
            await Modular.get<NavigatorManager>().to(HomePage.route);
          },
        ),
      ),
    );
  }
}
