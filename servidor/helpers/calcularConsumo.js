const { fn, literal, Op } = require("sequelize");

async function calcularConsumo(opt) {
    const { db, tableName, leitura, tensao, intervalo } = opt;

    const last = await db[tableName].findOne({
        order: [['timestamp', 'DESC']],
    }); 

    const intervaloFloat = parseFloat(intervalo);
    if (isNaN(intervaloFloat)) {
        throw new Error("Intervalo inválido, não é número");
    }

    const intervaloLiteral = intervaloFloat % 1 === 0 ? `${intervaloFloat}.0` : `${intervaloFloat}`;

    const consumoAnterior = last ? parseFloat(last.consumoAtual) : 0.0
    const consumoAtual = consumoAnterior + (tensao * leitura * (intervaloLiteral/3600)/1000)

    return parseFloat(consumoAtual).toFixed(6);
} 

module.exports = calcularConsumo;
