import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/components/icon_card.dart';

import 'home_page_view_model.dart';

class HomePageView extends HomePageViewModel {
  @override
  Widget build(BuildContext context) {
    Widget buildCard({
      required String icon,
      required String label,
      required String value,
      required String timestamp,
      required VoidCallback onTap,
    }) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconCard(imagePath: icon, onTap: onTap),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                          shadows: [Shadow(color: Colors.white, blurRadius: 8)],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          shadows: [Shadow(color: Colors.white, blurRadius: 8)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Horário: $timestamp',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      );
    }

    List<Widget> buildContentChildren() {
      return [
        // Distância
        ValueListenableBuilder<double?>(
          valueListenable: distanceNotifier,
          builder: (context, value, _) {
            final distanceStr = value == null
                ? '-'
                : '${value.toStringAsFixed(1)} cm';
            return buildCard(
              icon: 'assets/icons/quality.png',
              label: 'Distância na caixa',
              value: distanceStr,
              timestamp: distanceTimestamp,
              onTap: onTapBox,
            );
          },
        ),

        // Corrente
        ValueListenableBuilder<double?>(
          valueListenable: currentNotifier,
          builder: (context, value, _) {
            final currentStr = value == null
                ? '-'
                : '${value.toStringAsFixed(3)} A';
            return buildCard(
              icon: 'assets/icons/flash.png',
              label: 'Corrente elétrica',
              value: currentStr,
              timestamp: currentTimestamp,
              onTap: onTapCorrente,
            );
          },
        ),

        // Portão
        ValueListenableBuilder<bool?>(
          valueListenable: gateNotifier,
          builder: (context, value, _) {
            final status = value == null
                ? 'Sem Status'
                : (value ? 'Aberto' : 'Fechado');
            return buildCard(
              icon: 'assets/icons/gate.png',
              label: 'Status do portão',
              value: status,
              timestamp: gateTimestamp,
              onTap: onTapGate,
            );
          },
        ),
      ];
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
