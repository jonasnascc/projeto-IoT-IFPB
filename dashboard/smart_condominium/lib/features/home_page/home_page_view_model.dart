import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smart_condominium/core/managers/mqtt_manager.dart';

import 'home_page.dart';

abstract class HomePageViewModel extends State<HomePage> {
  final _mqttManager = Modular.get<MqttManager>();

  OverlayEntry? _statusOverlay;
  String get gateStatus => _mqttManager.gateOpen == null
      ? 'Sem Status'
      : (_mqttManager.gateOpen! ? 'Aberto' : 'Fechado');
  String get gateTimestamp => _mqttManager.gateTimestamp ?? '-';

  ValueNotifier<bool?> get gateNotifier => _mqttManager.gateNotifier;
  ValueNotifier<double?> get currentNotifier => _mqttManager.currentNotifier;
  ValueNotifier<double?> get distanceNotifier => _mqttManager.distanceNotifier;

  String get currentStr => _mqttManager.current == null
      ? '-'
      : '${_mqttManager.current!.toStringAsFixed(3)} A';
  String get currentTimestamp => _mqttManager.currentTimestamp ?? '-';

  String get distanceStr => _mqttManager.distance == null
      ? '-'
      : '${_mqttManager.distance!.toStringAsFixed(1)} cm';
  String get distanceTimestamp => _mqttManager.distanceTimestamp ?? '-';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await initialize(),
    );
  }

  Future<void> initialize() async {
    _mqttManager.initialize(
      '8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud',
      8883,
      'dashboard_iot',
      'dashboardCond2025',
      'meuClientIdUnico12345678',
      'test/topic',
    );

    await _mqttManager.connect();
  }

  void showStatusOverlay(
    BuildContext context,
    String imagePath,
    String message,
  ) {
    removeStatusOverlay(); // remove anterior se houver

    final overlay = Overlay.of(context);
    _statusOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            elevation: 10,
            color: Colors.black.withOpacity(0.85),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(imagePath, width: 24, height: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Status:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    gateStatus,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_statusOverlay!);
  }

  void removeStatusOverlay() {
    _statusOverlay?.remove();
    _statusOverlay = null;
  }

  @override
  void dispose() {
    _mqttManager.disconnect();
    removeStatusOverlay();
    super.dispose();
  }
}
