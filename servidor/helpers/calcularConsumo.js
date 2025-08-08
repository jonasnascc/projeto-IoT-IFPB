const { fn, literal, Op } = require("sequelize");

async function calcularConsumo(opt) {
    const { db, tableName, leitura, tensao, intervalo } = opt;

    const last = await db[tableName].findOne({
        order: [['timestamp', 'DESC']],
    }); 

    const consumoAnterior = last ? parseFloat(last.consumoAtual) : 0.0
    const consumoAtual = consumoAnterior + (tensao * leitura * (intervalo/3600)/1000)

    return parseFloat(consumoAtual).toFixed(6);
} 

module.exports = calcularConsumo;
