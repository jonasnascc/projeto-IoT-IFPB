import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert'; // Added for jsonDecode

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart'; // Added for ValueNotifier

class MqttManager {
  MqttManager._();
  static final instance = MqttManager._();

  late MqttServerClient _client;
  StreamSubscription? _subscription;
  String topic = '';
  String gateStatus = 'Sem Status';

  // Variáveis para cada tópico
  double? current; // Corrente (A)
  String? currentTimestamp;
  double? distance; // Distância (cm)
  String? distanceTimestamp;
  bool? gateOpen; // Status do portão
  String? gateTimestamp;
  String? lastAlert;
  String? lastAlertTimestamp;

  // Notificador para updates
  final ValueNotifier<void> notifier = ValueNotifier(null);
  // Notificadores específicos para cada dado
  final ValueNotifier<bool?> gateNotifier = ValueNotifier(null);
  final ValueNotifier<double?> currentNotifier = ValueNotifier(null);
  final ValueNotifier<double?> distanceNotifier = ValueNotifier(null);

  // Tópicos a serem assinados
  final List<String> topics = [
    'sensor/energia',
    'sensor/portao',
    'sensor/caixa',
  ];

  void initialize(
    String broker,
    int port,
    String username,
    String password,
    String clientId,
    String? _ignoredInitTopic, // Não mais usado
  ) {
    _client = MqttServerClient(broker, clientId);
    _client.port = port;
    _client.secure = true;
    _client.logging(on: true);
    _client.keepAlivePeriod = 20;

    _client.setProtocolV311();
    _client.securityContext = SecurityContext.defaultContext;

    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .startClean();

    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onSubscribed = _onSubscribed;

    _client.pongCallback = () {
      log('🏓 Ping response recebido do broker.');
    };
  }

  Future<void> connect() async {
    try {
      log('🔄 Tentando conectar ao broker MQTT...');
      await _client.connect();
    } on Exception catch (e) {
      log('❌ Exceção na conexão MQTT: $e');
      disconnect();
      return;
    }

    final state = _client.connectionStatus?.state;
    if (state == MqttConnectionState.connected) {
      log('✅ Conectado com sucesso ao broker MQTT!');
      _subscribeToTopics();
    } else {
      log('❌ Falha na conexão MQTT: $state');
      disconnect();
    }
  }

  void _subscribeToTopics() {
    for (final t in topics) {
      log('🔔 Inscrevendo no tópico: $t');
      _client.subscribe(t, MqttQos.atLeastOnce);
    }

    // Cancelar subscription anterior, se houver
    _subscription?.cancel();

    _subscription = _client.updates?.listen((
      List<MqttReceivedMessage<MqttMessage>> messages,
    ) {
      for (var message in messages) {
        final recMess = message.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
        log('📩 Mensagem recebida no tópico ${message.topic}]: $payload');
        _handleMessage(message.topic, payload);
      }
    });
  }

  void _handleMessage(String topic, String payload) {
    print('_handleMessage $topic');
    try {
      final data = _parseJson(payload);
      // Tratamento de alerta genérico
      if (data.containsKey('alerta')) {
        lastAlert = data['alerta'] as String?;
        lastAlertTimestamp = data['timestamp'] as String?;
        log(
          '⚠️ Alerta recebido do tópico $topic: $lastAlert, Timestamp: $lastAlertTimestamp',
        );
        notifier.value = null;
        return;
      }
      switch (topic) {
        case 'sensor/energia':
          log(topic);
          current = (data['corrente'] as num?)?.toDouble();
          currentNotifier.value = current;
          currentTimestamp = data['timestamp'] as String?;
          log('🔌 Corrente recebida: $current A, Timestamp: $currentTimestamp');
          break;
        case 'sensor/portao':
          log('topic ${topic}');
          var rawGate = data['gate_open'];
          if (rawGate is bool) {
            gateOpen = rawGate;
          } else if (rawGate is String) {
            gateOpen = rawGate.toLowerCase() == 'true';
          } else if (rawGate is num) {
            gateOpen = rawGate != 0;
          } else {
            gateOpen = null;
          }
          gateNotifier.value = gateOpen;
          gateTimestamp = data['timestamp'] as String?;
          log(
            '🚪 Status do portão recebido: ${gateOpen == null ? 'null' : (gateOpen! ? 'Aberto' : 'Fechado')}, Timestamp: $gateTimestamp',
          );
          break;
        case 'sensor/caixa':
          log(topic);
          // Aceita tanto 'distância' quanto 'distancia' (com e sem acento)
          final dist = data['distância'] ?? data['distancia'];
          distance = (dist as num?)?.toDouble();
          distanceNotifier.value = distance;
          distanceTimestamp = data['timestamp'] as String?;
          log(
            '📦 Distância recebida: $distance cm, Timestamp: $distanceTimestamp',
          );
          break;
      }
      notifier.value = null;
    } catch (e) {
      log('❌ Erro ao processar mensagem do tópico $topic: $e');
    }
  }

  Map<String, dynamic> _parseJson(String payload) {
    try {
      return payload.isNotEmpty
          ? Map<String, dynamic>.from(jsonDecode(payload))
          : {};
    } catch (e) {
      log('❌ Erro ao fazer parse do JSON: $e');
      return {};
    }
  }

  void _onConnected() {
    log('🔗 MQTT conectado.');
  }

  void _onDisconnected() {
    log('🔌 MQTT desconectado.');
    _subscription?.cancel();
  }

  void _onSubscribed(String topic) {
    log('✅ Inscrito no tópico $topic.');
  }

  void disconnect() {
    log('🛑 Desconectando MQTT...');
    _subscription?.cancel();
    _client.disconnect();
  }
}
