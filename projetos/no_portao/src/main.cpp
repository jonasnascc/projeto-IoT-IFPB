#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <time.h>

#define SENSOR_PIN 15
#define WIFI_LED_PIN 4
#define HIVE_LED_PIN 13

const char* ssid = "WifiTest";
const char* password = "esptest123";

const char* mqtt_server = "8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_topic = "sensor/portao";
const char* mqtt_user = "no_portao";
const char* mqtt_password = "portaoIot2025";

WiFiClientSecure espClient;
PubSubClient client(espClient);

int last_state = LOW;

unsigned long sensorOnSince = 0;
bool alertCycleStarted = false;
int alertCount = 0;
unsigned long lastAlertTime = 0;

const unsigned long ALERT_START_DELAY = 10000; 
const unsigned long ALERT_INTERVAL = 5000;

void setup_wifi() {
  Serial.print("Conectando ao Wi-Fi");
  WiFi.begin(ssid, password);
  int blink = 1;
  digitalWrite(WIFI_LED_PIN, HIGH);
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
    if (client.connect("ESP32Client", mqtt_user, mqtt_password)) {
      Serial.println("Conectado ao MQTT!");
    } else {
      Serial.print("Falha, rc=");
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
  pinMode(HIVE_LED_PIN, OUTPUT);
  setup_wifi();

  espClient.setInsecure();
  client.setServer(mqtt_server, mqtt_port);
  client.setKeepAlive(30);
}

void loop() {
  if (!client.connected()) {
    digitalWrite(HIVE_LED_PIN, LOW);
    reconnect();
  } else {
    digitalWrite(HIVE_LED_PIN, HIGH);
  }
  client.loop();

  int sensorVal = digitalRead(SENSOR_PIN);
  time_t now = time(nullptr);
  struct tm* timeinfo = localtime(&now);
  char timeStr[30];
  strftime(timeStr, sizeof(timeStr), "%Y-%m-%d %H:%M:%S", timeinfo);

  unsigned long nowMillis = millis();

  if (sensorVal == HIGH) {
    if (last_state == LOW) {
      Serial.println("Sensor ATIVADO");
      char msg[150];
      snprintf(msg, sizeof(msg), "{\"gate_open\": true, \"timestamp\": \"%s\"}", timeStr);
      client.publish(mqtt_topic, msg);

      sensorOnSince = nowMillis;
      alertCycleStarted = false;
      alertCount = 0;
      lastAlertTime = 0;
    }

    if (!alertCycleStarted && (nowMillis - sensorOnSince >= ALERT_START_DELAY)) {
      alertCycleStarted = true;
      lastAlertTime = nowMillis - ALERT_INTERVAL;
      alertCount = 0;
    }

    if (alertCycleStarted && alertCount < 3 && (nowMillis - lastAlertTime >= ALERT_INTERVAL)) {
      char msg[150];
      snprintf(msg, sizeof(msg),
        "{\"alerta\": \"Portão aberto a mais de 10 segundos\", \"timestamp\": \"%s\"}", timeStr);
      client.publish(mqtt_topic, msg);
      Serial.print("🔔 Alerta enviado: ");
      Serial.println(msg);
      lastAlertTime = nowMillis;
      alertCount++;
    }

  } else {
    if (last_state == HIGH) {
      Serial.println("Sensor DESATIVADO");
      char msg[150];
      snprintf(msg, sizeof(msg), "{\"gate_open\": false, \"timestamp\": \"%s\"}", timeStr);
      client.publish(mqtt_topic, msg);
    }

    sensorOnSince = 0;
    alertCycleStarted = false;
    alertCount = 0;
    lastAlertTime = 0;
  }

  last_state = sensorVal;
  delay(100);
}