#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>

#define SENSOR_PIN 2
#define WIFI_LED_PIN 4

const char* ssid = "PROXXIMA-JONAS-2G";
const char* password = "1F1c0uLd";

// HiveMQ Cloud (com TLS)
const char* mqtt_server = "8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_topic = "portao/sensor";

// Credenciais MQTT (usuário e senha criados no painel da HiveMQ Cloud)
const char* mqtt_user = "no_portao";
const char* mqtt_password = "portaoIot2025";

WiFiClientSecure espClient;
PubSubClient client(espClient);

int last_state = 0;
void setup_wifi() {
  Serial.print("Conectando ao Wi-Fi");
  WiFi.begin(ssid, password);
  int blink = 1;
  while (WiFi.status() != WL_CONNECTED) {
    digitalWrite(WIFI_LED_PIN, blink);
    delay(500);
    Serial.print(".");
    blink = !blink;
  }
  digitalWrite(WIFI_LED_PIN, LOW);
  Serial.println("\nWi-Fi conectado. IP: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Conectando ao MQTT...");
    // Conecta usando autenticação
    if (client.connect("ESP32Client", mqtt_user, mqtt_password)) {
      Serial.println("Conectado ao MQTT!");
    } else {
      Serial.print("falha, rc=");
      Serial.print(client.state());
      Serial.println(" tentando novamente em 5s");
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(SENSOR_PIN, INPUT_PULLDOWN);
  pinMode(WIFI_LED_PIN, OUTPUT);

  setup_wifi();

  espClient.setInsecure(); // ⚠️ Para testes — desativa verificação TLS
  client.setServer(mqtt_server, mqtt_port);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  int sensorVal = digitalRead(SENSOR_PIN);
  if (sensorVal == HIGH) {
    Serial.println("Sensor ATIVADO");
    if(last_state == 0) {
      client.publish(mqtt_topic, "Sensor ATIVADO");
    }
  } else {
    Serial.println("Sensor DESATIVADO");
    if(last_state == 1) {
      client.publish(mqtt_topic, "Sensor DESATIVADO");
    }
  }

  last_state = sensorVal;

  delay(500);
}
