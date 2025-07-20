#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <time.h>

#define PIN_SENSOR 1
#define OFFSET 1.670       // tensão com corrente = 0, após divisor
#define SENSIBILIDADE 0.050 // V por A, calculado a partir das medições reais

#define WIFI_LED_PIN 2
#define HIVE_LED_PIN 3

const char* ssid = "WifiTest";
const char* password = "esptest123";

// HiveMQ Cloud (com TLS)
const char* mqtt_server = "8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_topic = "sensor/energia";

// Credenciais MQTT (usuário e senha criados no painel da HiveMQ Cloud)
const char* mqtt_user = "no_caixa";
const char* mqtt_password = "caixaIot2025";

WiFiClientSecure espClient;
PubSubClient client(espClient);

void setup_wifi() {
  Serial.print("Conectando ao Wi-Fi");
  WiFi.begin(ssid, password);
  WiFi.setTxPower(WIFI_POWER_8_5dBm);

  pinMode(WIFI_LED_PIN, OUTPUT);
  pinMode(HIVE_LED_PIN, OUTPUT);

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
    if (client.connect("ESP32ClientCorrente", mqtt_user, mqtt_password)) {
      Serial.println("Conectado ao MQTT!");
    } else {
      Serial.print("falha, rc=");
      Serial.print(client.state());
      Serial.println(" tentando novamente em 5s");
      delay(5000);
    }
  }
}

float lastCorrente = -1.0;

void setup() {
  Serial.begin(115200);
  WiFi.setTxPower(WIFI_POWER_8_5dBm);
  setup_wifi();

  espClient.setInsecure(); // desabilita verificação TLS para teste
  client.setServer(mqtt_server, mqtt_port);
}

void loop() {
  if (!client.connected()) {
    digitalWrite(HIVE_LED_PIN, LOW);
    reconnect();
  } else {
    digitalWrite(HIVE_LED_PIN, HIGH);
  }
  client.loop();

  const int amst = 1000;
  float soma = 0.0;
  float correnteFiltrada = 0.0;

  for (int i = 0; i < amst; i++) {
    int adc = analogRead(PIN_SENSOR);
    float Vadc = adc * (3.3 / 4095.0);
    float corrente = (Vadc - OFFSET) / SENSIBILIDADE;
    corrente -= 3.5;
    if(corrente < 0.03) corrente = 0.0;
    soma += corrente;
  }

  correnteFiltrada = soma / amst;
  if (abs(correnteFiltrada) < 0.05) correnteFiltrada = 0.0;

  time_t now = time(nullptr);
  struct tm* timeinfo = localtime(&now);
  char timeStr[30];
  strftime(timeStr, sizeof(timeStr), "%Y-%m-%d %H:%M:%S", timeinfo);

  char msg[150];
  snprintf(msg, sizeof(msg), "{\"corrente\": %s, \"timestamp\": \"%s\"}", String(correnteFiltrada, 3), timeStr);

  Serial.println(msg);
  client.publish(mqtt_topic, msg);

  lastCorrente = correnteFiltrada;
  delay(5000);
}
