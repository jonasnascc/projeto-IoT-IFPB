#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <time.h>

#define WIFI_LED_PIN 2
#define HIVE_LED_PIN 3

#define PIN_TRIGGER 4
#define PIN_ECHO 5

const char* ssid = "WifiTest";
const char* password = "esptest123";

// HiveMQ Cloud (com TLS)
const char* mqtt_server = "8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_topic = "sensor/caixa";

// Credenciais MQTT (usuário e senha criados no painel da HiveMQ Cloud)
const char* mqtt_user = "no_caixa";
const char* mqtt_password = "caixaIot2025";

WiFiClientSecure espClient;
PubSubClient client(espClient);

float getDistanciaSensor();

void setup_wifi() {
  Serial.print("Conectando ao Wi-Fi");
  WiFi.begin(ssid, password);
  WiFi.setTxPower(WIFI_POWER_8_5dBm);

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

   // Configura NTP (horário de Brasília: UTC-3)
  configTime(-3 * 3600, 0, "pool.ntp.org", "time.nist.gov");
  Serial.print("Aguardando sincronização NTP");

  time_t now = time(nullptr);
  while (now < 100000) {
    delay(500);
    Serial.print(".");
    now = time(nullptr);
  }
  Serial.println("\nHora sincronizada.");
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Conectando ao MQTT...");
    // Conecta usando autenticação
    if (client.connect("ESP32ClientCaixa", mqtt_user, mqtt_password)) {
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
  pinMode(WIFI_LED_PIN, OUTPUT);
  pinMode(HIVE_LED_PIN, OUTPUT);
  pinMode(PIN_TRIGGER, OUTPUT);
  pinMode(PIN_ECHO, INPUT);

  setup_wifi();

  espClient.setInsecure(); // ⚠️ Para testes — desativa verificação TLS
  client.setServer(mqtt_server, mqtt_port);
}

float lastDistancia = -1.0;
void loop() {
  if (!client.connected()) {
    digitalWrite(HIVE_LED_PIN, LOW);
    reconnect();
  } else {
    digitalWrite(HIVE_LED_PIN, HIGH);
  }
  client.loop();

  digitalWrite(PIN_TRIGGER, LOW);
  delayMicroseconds(2);
  digitalWrite(PIN_TRIGGER, HIGH);
  delay(500);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIGGER, LOW);

  float distancia = getDistanciaSensor();

  if ((int)lastDistancia != (int)distancia) {
    time_t now = time(nullptr);
    struct tm* timeinfo = localtime(&now);
    char timeStr[30];
    strftime(timeStr, sizeof(timeStr), "%Y-%m-%d %H:%M:%S", timeinfo);

    char msg[150];
    snprintf(msg, sizeof(msg),
      "{\"distancia\": %s, \"timestamp\": \"%s\"}", String(distancia, 2), timeStr);

    Serial.println(msg);

    client.publish(mqtt_topic, msg);
    
    lastDistancia = distancia;
  }
  delay(5000);
}

float getDistanciaSensor() {
  long duracao = pulseIn(PIN_ECHO, HIGH);
  float distancia = (duracao * 0.0343) / 2;
  return distancia;
}
