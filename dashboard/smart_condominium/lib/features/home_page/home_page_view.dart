import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/components/icon_card.dart';
import 'home_page_view_model.dart';

class HomePageView extends HomePageViewModel {
  @override
  Widget build(BuildContext context) {
    List<Widget> buildContentChildren() {
      final cards = [
        {
          'icon': 'assets/icons/quality.png',
          'label': 'Distância na caixa',
          'value': distanceStr,
          'timestamp': distanceTimestamp,
        },
        {
          'icon': 'assets/icons/flash.png',
          'label': 'Corrente elétrica',
          'value': currentStr,
          'timestamp': currentTimestamp,
        },
        {
          'icon': 'assets/icons/gate.png',
          'label': 'Status do portão',
          'value': gateStatus,
          'timestamp': gateTimestamp,
        },
      ];

      return cards.asMap().entries.map((entry) {
        final i = entry.key;
        final card = entry.value;
        // Card do portão usa ValueListenableBuilder
        if (card['label'] == 'Status do portão') {
          return ValueListenableBuilder<bool?>(
            valueListenable: gateNotifier,
            builder: (context, value, _) {
              final status = value == null
                  ? 'Sem Status'
                  : (value ? 'Aberto' : 'Fechado');
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconCard(
                        imagePath: card['icon']!,
                        onTap: () async {
                          showStatusOverlay(
                            context,
                            card['icon']!,
                            '${card['label']}: $status\nHorário: ${gateTimestamp}',
                          );
                          await Future.delayed(Duration(seconds: 4));
                          removeStatusOverlay();
                        },
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                card['label']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 8),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                status,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 8),
                                  ],
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
                    'Horário: ${gateTimestamp}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              );
            },
          );
        }
        // Card de corrente usa ValueListenableBuilder
        if (card['label'] == 'Corrente elétrica') {
          return ValueListenableBuilder<double?>(
            valueListenable: currentNotifier,
            builder: (context, value, _) {
              final currentStr = value == null
                  ? '-'
                  : '${value.toStringAsFixed(3)} A';
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconCard(
                        imagePath: card['icon']!,
                        onTap: () async {
                          showStatusOverlay(
                            context,
                            card['icon']!,
                            '${card['label']}: $currentStr\nHorário: ${currentTimestamp}',
                          );
                          await Future.delayed(Duration(seconds: 4));
                          removeStatusOverlay();
                        },
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                card['label']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 8),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentStr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 8),
                                  ],
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
                    'Horário: ${currentTimestamp}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              );
            },
          );
        }
        // Card de distância usa ValueListenableBuilder
        if (card['label'] == 'Distância na caixa') {
          return ValueListenableBuilder<double?>(
            valueListenable: distanceNotifier,
            builder: (context, value, _) {
              final distanceStr = value == null
                  ? '-'
                  : '${value.toStringAsFixed(1)} cm';
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconCard(
                        imagePath: card['icon']!,
                        onTap: () async {
                          showStatusOverlay(
                            context,
                            card['icon']!,
                            '${card['label']}: $distanceStr\nHorário: ${distanceTimestamp}',
                          );
                          await Future.delayed(Duration(seconds: 4));
                          removeStatusOverlay();
                        },
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                card['label']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 8),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                distanceStr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(color: Colors.white, blurRadius: 8),
                                  ],
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
                    'Horário: ${distanceTimestamp}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              );
            },
          );
        }
        // Outros cards permanecem iguais
        final cardWidget = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconCard(
                  imagePath: card['icon']!,
                  onTap: () async {
                    showStatusOverlay(
                      context,
                      card['icon']!,
                      '${card['label']}: ${card['value']}\nHorário: ${card['timestamp']}',
                    );
                    await Future.delayed(Duration(seconds: 4));
                    removeStatusOverlay();
                  },
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          card['label']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                            shadows: [
                              Shadow(color: Colors.white, blurRadius: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card['value']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(color: Colors.white, blurRadius: 8),
                            ],
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
              'Horário: ${card['timestamp']}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        );
        return cardWidget;
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
