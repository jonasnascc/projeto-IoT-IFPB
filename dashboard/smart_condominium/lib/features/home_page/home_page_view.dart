import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/components/icon_card.dart';
import 'home_page_view_model.dart';

class HomePageView extends HomePageViewModel {
  @override
  Widget build(BuildContext context) {
    final contentChildren = [
      IconCard(imagePath: 'assets/icons/quality.png'),
      IconCard(imagePath: 'assets/icons/flash.png'),
      IconCard(imagePath: 'assets/icons/gate.png'),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset('assets/icons/rectangle.png', width: 200),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'condomínio inteligente',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: kIsWeb
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: contentChildren,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: contentChildren,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
