import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:smart_condominium/core/managers/mqtt_manager.dart';
import 'package:smart_condominium/core/repositories/%20graphics_repository.dart';
import 'package:smart_condominium/features/home_page/components/caixa_volume_chart.dart';
import 'package:smart_condominium/features/home_page/components/corrente_chart.dart';
import 'package:smart_condominium/features/home_page/components/portao_graph_modal.dart';

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
  Timer? _gateOpenTimer;
  bool _alertShown = false;

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
    gateNotifier.addListener(_checkGateStatus);
  }

  void _checkGateStatus() {
    if (gateNotifier.value == true) {
      _gateOpenTimer ??= Timer(const Duration(minutes: 1), () {
        if (gateNotifier.value == true && !_alertShown) {
          _showGateOpenAlert();
          _alertShown = true;
          Future.delayed(const Duration(seconds: 10), () {
            removeStatusOverlay();
            _alertShown = false;
          });
        }
      });
    } else {
      _gateOpenTimer?.cancel();
      _gateOpenTimer = null;
      _alertShown = false;
    }
  }

  void _showGateOpenAlert() {
    showStatusOverlay(
      context,
      'assets/icons/gate.png',
      'Alerta: Portão está aberto há mais de 1 minuto!',
    );
  }

  Future<void> initialize() async {
    if (kIsWeb) {
      // Web: atualiza os notifiers a cada 10 segundos
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        print('getDataWeb');
        final energiaData = await GraphicsRepository.instance.getEnergiaData(
          limit: 1,
          offset: 0,
        );
        if (energiaData?.data?.isNotEmpty ?? false) {
          final last = energiaData!.data!.last;
          currentNotifier.value = last.corrente;
          _mqttManager.currentTimestamp = last.timestamp ?? '-';
        }

        final portaoData = await GraphicsRepository.instance.getPortaoData(
          limit: 1,
          offset: 0,
        );
        if (portaoData?.data?.isNotEmpty ?? false) {
          final last = portaoData!.data!.last;
          gateNotifier.value = last.gateOpen;
          _mqttManager.gateTimestamp = last.timestamp ?? '-';
        }

        final caixaData = await GraphicsRepository.instance.getCaixaData(
          limit: 1,
          offset: 0,
        );
        if (caixaData?.data?.isNotEmpty ?? false) {
          final last = caixaData!.data!.last;
          distanceNotifier.value = last.distancia;
          _mqttManager.distanceTimestamp = last.timestamp ?? '-';
        }
      });
    } else {
      _mqttManager.initialize(
        '8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud', // broker igual ao site
        8884, // porta websocket segura
        'dashboard_iot', // usuário igual ao site
        'dashboardCond2025', // senha igual ao site
        'clientId-jsXpWcjHHO', // clientId igual ao site
        'testtopic/1', // tópico igual ao site
      );
      await _mqttManager.connect();
    }
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );
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
            color: Colors.black,
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

  Future<void> onTapGate() async {
    await showLoadingDialog(context);
    final portaoData = await GraphicsRepository.instance.getPortaoData(
      limit: 100000,
      offset: 1,
    );
    if (context.mounted) Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => PortaoGraphModal(data: portaoData),
    );
  }

  Future<void> onTapCorrente() async {
    await showLoadingDialog(context);
    final energiaData = await GraphicsRepository.instance.getEnergiaData(
      limit: 100000,
      offset: 1,
    );
    if (context.mounted) Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => energiaData?.data?.isEmpty ?? true
          ? const Center(child: Text('Nenhum dado disponível'))
          : Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Variação da Corrente Elétrica',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CorrenteChart(data: energiaData!.data!),
                ],
              ),
            ),
    );
  }

  onTapBox() async {
    await showLoadingDialog(context);
    final caixaData = await GraphicsRepository.instance.getCaixaData(
      limit: 100000,
      offset: 1,
    );
    if (context.mounted) Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => caixaData?.data?.isEmpty ?? true
          ? const Center(child: Text('Nenhum dado disponível'))
          : Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Variação do Volume da Caixa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CaixaVolumeChart(data: caixaData!.data!),
                ],
              ),
            ),
    );
  }

  void removeStatusOverlay() {
    _statusOverlay?.remove();
    _statusOverlay = null;
  }

  @override
  void dispose() {
    _mqttManager.disconnect();
    removeStatusOverlay();
    gateNotifier.removeListener(_checkGateStatus);
    _gateOpenTimer?.cancel();
    super.dispose();
  }
}
