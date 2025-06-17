import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  MqttManager._();
  static final instance = MqttManager._();

  late MqttServerClient _client;
  StreamSubscription? _subscription;
  String topic = '';
  String gateStatus = 'Sem Status';

  void initialize(
    String broker,
    int port,
    String username,
    String password,
    String clientId,
    String initTopic,
  ) {
    topic = initTopic;
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
      _subscribeToTopic(topic);
    } else {
      log('❌ Falha na conexão MQTT: $state');
      disconnect();
    }
  }

  void _subscribeToTopic(String topic) {
    log('🔔 Inscrevendo no tópico: $topic');
    _client.subscribe(topic, MqttQos.atLeastOnce);

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
        gateStatus = payload;
      }
    });
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
