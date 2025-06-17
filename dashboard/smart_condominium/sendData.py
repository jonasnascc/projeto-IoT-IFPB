import paho.mqtt.client as mqtt
import ssl

# python3 sendData.py

BROKER = "8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud"
PORT = 8883
USERNAME = "dashboard_iot"
PASSWORD = "dashboardCond2025"
TOPIC = "test/topic"

# 📝 Solicita a mensagem no terminal
MESSAGE = input("📝 Escreva a mensagem para enviar via MQTT: ")

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("✅ Conectado ao broker com sucesso.")
        try:
            result = client.publish(TOPIC, MESSAGE)
            status = result[0]
            if status == 0:
                print(f"📤 Mensagem enviada: {MESSAGE}")
            else:
                print(f"❌ Falha ao enviar mensagem, status: {status}")
        except Exception as e:
            print(f"❌ Exceção ao tentar publicar mensagem: {e}")
    else:
        print(f"❌ Falha na conexão, código de retorno: {rc}")

def on_publish(client, userdata, mid):
    print(f"✅ Mensagem publicada com sucesso, mid={mid}")

def on_disconnect(client, userdata, rc):
    if rc != 0:
        print(f"⚠️ Desconectado inesperadamente, rc={rc}")
    else:
        print("🔌 Desconectado do broker.")

def on_log(client, userdata, level, buf):
    print(f"LOG ({level}): {buf}")

client = mqtt.Client(client_id="meuClientIdUnico123")
client.tls_set(tls_version=ssl.PROTOCOL_TLS)
client.username_pw_set(USERNAME, PASSWORD)

client.on_connect = on_connect
client.on_publish = on_publish
client.on_disconnect = on_disconnect
client.on_log = on_log

try:
    print("🔄 Tentando conectar ao broker...")
    client.connect(BROKER, PORT)
except Exception as e:
    print(f"❌ Exceção na conexão: {e}")

client.loop_forever()
