import 'package:flutter/material.dart';
import './splash_view.dart';

/// Widget principal que implementa o padrão MVVM
/// Separa a lógica de apresentação (View) da lógica de negócio (ViewModel)
class Splash extends StatefulWidget {
  static const route = '/';

  const Splash({super.key});

  @override
  SplashView createState() => SplashView();
}
