import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  MqttManager._();
  static final instance = MqttManager._();

  late final MqttServerClient _client;

  Future<void> connect({
    required String broker,
    required String clientId,
    String topic = 'default/topic',
    int port = 1883,
    bool logging = false,
  }) async {
    _client = MqttServerClient(broker, clientId);
    _client.port = port;
    _client.logging(on: logging);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
      _client.subscribe(topic, MqttQos.atLeastOnce);
    } catch (e) {
      _client.disconnect();
      rethrow;
    }
  }

  void _onConnected() => print('✅ MQTT Connected');
  void _onDisconnected() => print('❌ MQTT Disconnected');
  void _onSubscribed(String topic) => print('📡 Subscribed to $topic');

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? get updates =>
      _client.updates;

  void disconnect() => _client.disconnect();
}
