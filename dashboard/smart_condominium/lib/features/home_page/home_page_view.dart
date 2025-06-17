import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/components/icon_card.dart';
import 'home_page_view_model.dart';

class HomePageView extends HomePageViewModel {
  @override
  Widget build(BuildContext context) {
    List<Widget> buildContentChildren() {
      final icons = [
        'assets/icons/quality.png',
        'assets/icons/flash.png',
        'assets/icons/gate.png',
      ];

      return icons.map((path) {
        final icon = IconCard(
          imagePath: path,
          onTap: () async {
            showStatusOverlay(context, path, gateStatus);
            await Future.delayed(Duration(seconds: 4));
            removeStatusOverlay();
          },
        );

        return kIsWeb
            ? MouseRegion(
                onEnter: (_) => showStatusOverlay(context, path, gateStatus),
                onExit: (_) => removeStatusOverlay(),
                child: icon,
              )
            : icon;
      }).toList();
    }

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
                            children: buildContentChildren(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: buildContentChildren(),
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
