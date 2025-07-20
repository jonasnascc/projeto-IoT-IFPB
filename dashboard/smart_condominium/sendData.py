import paho.mqtt.client as mqtt
import ssl
import json

# python3 sendData.py

BROKER = "8c97ab339b614714b675b317bd5e35cf.s1.eu.hivemq.cloud"
PORT = 8883
USERNAME = "dashboard_iot"
PASSWORD = "dashboardCond2025"
# Tópicos do sistema
ALL_TOPICS = {
    'sensor/energia': json.dumps({
        'corrente': 1.234,
        'timestamp': '2025-07-20 12:34:56',
    }),
    'sensor/portao': json.dumps({
        'gate_open': True,
        'timestamp': '2025-07-20 12:35:10',
    }),
    'sensor/caixa': json.dumps({
        'distância': 15.7,
        'timestamp': '2025-07-20 12:35:20',
    }),
    'sensor/alerta': json.dumps({
        'alerta': 'Alerta de teste! Porta aberta.',
        'timestamp': '2025-07-20 12:35:30',
    }),
}

# Pergunta se quer enviar para todos os tópicos
send_all = input("Deseja enviar dados mockados para todos os tópicos? (s/n): ").strip().lower() == 's'

if send_all:
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("✅ Conectado ao broker com sucesso.")
            try:
                for topic, msg in ALL_TOPICS.items():
                    result = client.publish(topic, msg)
                    status = result[0]
                    if status == 0:
                        print(f"📤 Mensagem enviada para o tópico '{topic}': {msg}")
                    else:
                        print(f"❌ Falha ao enviar mensagem para '{topic}', status: {status}")
            except Exception as e:
                print(f"❌ Exceção ao tentar publicar mensagem: {e}")
        else:
            print(f"❌ Falha na conexão, código de retorno: {rc}")
else:
    # 📝 Solicita o tópico e a mensagem no terminal
    TOPIC = input("📝 Digite o tópico para enviar a mensagem (ex: sensor/energia): ")
    MESSAGE = input("📝 Escreva a mensagem para enviar via MQTT: ")
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("✅ Conectado ao broker com sucesso.")
            try:
                result = client.publish(TOPIC, MESSAGE)
                status = result[0]
                if status == 0:
                    print(f"📤 Mensagem enviada para o tópico '{TOPIC}': {MESSAGE}")
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
