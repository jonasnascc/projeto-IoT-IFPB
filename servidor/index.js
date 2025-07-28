const express = require('express');
const mqtt = require('mqtt');
const db = require('./models');

const calcularVolume = require('./helpers/calcularVolume')
require('dotenv').config();

const app = express();
app.use(express.json());

const mqttClient = mqtt.connect(process.env.MQTT_BROKER, {
  username: process.env.MQTT_USERNAME,
  password: process.env.MQTT_PASSWORD,
});

mqttClient.on('error', (err) => {
  console.error('❌ Erro ao conectar ao MQTT:', err.message);
});

const topicos = [
    "sensor/caixa",
    "sensor/portao",
    "sensor/energia"
]

const relTables = [
    "CaixaMensagens",
    "PortaoMensagens",
    "EnergiaMensagens"
]

const totalOccurs = [
    10,  1000,   1000
//  caixa, portao, energia
]

const DISTANCIA_OFFSET_CM_LIMIT = 1;


mqttClient.on('connect', () => {
  console.log('🟢 Conectado ao MQTT');
  for (let topico of topicos){
    mqttClient.subscribe(topico, (err) => {
        if (err) console.error(`Erro na inscrição no topico '${topico}': `, err);
        else console.log(`📡 Inscrito em: ${topico}`);
    });
  }
});

mqttClient.on('message', async (receivedTopic, message) => {
    const conteudo = message.toString();
    console.log(`📥 ${receivedTopic} => ${conteudo}`);

    const topicIndex = topicos.indexOf(receivedTopic)

    try {
        const jsonObj = JSON.parse(conteudo)
        if("alerta" in jsonObj) return;

        const tableName = relTables[topicIndex];

        const last = await db[tableName].findOne({ // mais antigo
            order: [['timestamp', 'DESC']],
        });
        
        switch(receivedTopic){
            case("sensor/energia"): {
                if(last) {
                    if(last.corrente == jsonObj.corrente) {
                        console.log("ignorando")
                        return;
                    }
                }
                
                break;
            }
            case("sensor/caixa"): {
                jsonObj.distancia = Math.round(jsonObj.distancia)
                if(last) {
                    if(last.distancia == jsonObj.distancia || 
                        (jsonObj.distancia > last.distancia - DISTANCIA_OFFSET_CM_LIMIT 
                            && jsonObj.distancia < last.distancia + DISTANCIA_OFFSET_CM_LIMIT 
                        )
                    ) {
                        console.log("ignorando")
                        return;
                    }
                }

                jsonObj.volume = calcularVolume({
                    distanciaSensor: jsonObj.distancia/100, // 0.3889 m ~= 1000 litros
                    diametroCaixa: 1.52, 
                    alturaUtil: 0.72, 
                    alturaSensor: 0.94
                });
                console.log("Volume: ", jsonObj.volume)
                // jsonObj.volume = calcularVolume(jsonObj.distancia - (94 - 72), 72, 151);

                break;
            }
        }
        const count = await db[tableName].count();

        let first;
        if(count >= totalOccurs[topicIndex]) {
            first = await db[tableName].findOne({ // mais antigo
                order: [['timestamp', 'ASC']],
            });
        }

        const created = await db[tableName].create({topico: receivedTopic, ...jsonObj})

        if(created && first){
            await first.destroy();
            // console.log(`Maximo de objetos na tabela '${tableName}' excedido, excluindo o mais antigo.`)
        }
    } catch (error) {
        console.error('❌ Erro ao salvar:', error);
    }
});

const PORT = process.env.PORT || 3000;

db.sequelize.sync().then(() => {
  app.listen(PORT, () => {
    console.log(`🚀 Servidor rodando em http://localhost:${PORT}`);
  });
});
