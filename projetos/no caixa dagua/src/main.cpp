#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>

#define WIFI_LED_PIN 4
#define PIN_TRIGGER 14
#define PIN_ECHO 12

#define SIM_POT 34 //Potenciometro para simular distancia

const char* ssid = "PROXXIMA-JONAS-2G";
const char* password = "1F1c0uLd";

// HiveMQ Cloud (com TLS)
const char* mqtt_server = "8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_topic = "caixa/sensor";

// Credenciais MQTT (usuário e senha criados no painel da HiveMQ Cloud)
const char* mqtt_user = "no_caixa";
const char* mqtt_password = "caixaIot2025";

WiFiClientSecure espClient;
PubSubClient client(espClient);

float getDistanciaSensor();
float getSimulacaoDistanciaSensor();

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
  Serial.begin(9600);
  pinMode(WIFI_LED_PIN, OUTPUT);
  pinMode(PIN_TRIGGER, OUTPUT);
  pinMode(PIN_ECHO, INPUT);

  pinMode(SIM_POT, INPUT); //

  setup_wifi();

  espClient.setInsecure(); // ⚠️ Para testes — desativa verificação TLS
  client.setServer(mqtt_server, mqtt_port);
}

float lastDistancia = 0.0;
void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  digitalWrite(PIN_TRIGGER, LOW);
  delayMicroseconds(2);
  digitalWrite(PIN_TRIGGER, HIGH);
  delay(500);
  // delayMicroseconds(10);
  digitalWrite(PIN_TRIGGER, LOW);

  float distancia = getSimulacaoDistanciaSensor();

  if ((int)lastDistancia != (int)distancia) {
    String msg = "{\"distancia\":" + String(distancia, 2) + "}";

    Serial.println(msg);

    client.publish(mqtt_topic, msg.c_str());
    
    lastDistancia = distancia;
  }
  delay(500);
}

float getDistanciaSensor() {
  long duracao = pulseIn(PIN_ECHO, HIGH);
  float distancia = (duracao * 0.0343) / 2;
  return distancia;
}

float getSimulacaoDistanciaSensor() {
  float distancaMaximaCm = 150.0;
  float val = analogRead(SIM_POT);
  return (((int)(val/10))/409.0) * distancaMaximaCm;
}