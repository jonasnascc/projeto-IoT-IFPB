const express = require("express")
const router = express.Router()
const db = require('./models/conn');

const {Op} = require("sequelize")

const listFn = async (req, res, table) => {
    try {
        const limit = parseInt(req.query.limit) || 10;
        const offset = parseInt(req.query.offset) || 0;

        const list = await db[table].findAll({
            limit,
            offset,
            order: [['timestamp', 'DESC']],
        });

        const total = await db[table].count();

        const hasMore = offset + list.length < total;

        return res.status(200).json({
            limit,
            offset,
            data: list,
            hasMore,
            total
        });
    } catch (err) {
        console.error("Erro ao buscar mensagens:", err);
        return res.status(500).json({ error: "Erro interno do servidor" });
    }
}

//-----------------//
router.get("/portao", async (req, res) => await listFn(req, res, "PortaoMensagens"))

router.get("/portao/last", async (req, res) => {
    const last = await db.PortaoMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    return res.status(200).json(last);
})
//-----------------//
router.get("/caixa", async (req, res) => await listFn(req, res, "CaixaMensagens"))

router.get("/caixa/last", async (req, res) => {
    const last = await db.CaixaMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    return res.status(200).json(last);
})

//-----------------//
router.get("/energia", async (req, res) => await listFn(req, res, "EnergiaMensagens"))

router.get("/energia/last", async (req, res) => {
    const last = await db.EnergiaMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    return res.status(200).json(last);
})

router.get("/energia/consumo", async (req, res) => {
  try {
    const { dia, mes, ano } = req.query;

    // Função para calcular consumo
    function calcularConsumo(first, last) {
      return Math.max(0, parseFloat(last.consumoAtual) - parseFloat(first.consumoAtual));
    }

    if (dia && mes && ano) {
      // Ajuste mês para zero-based (Janeiro=0)
      const anoNum = parseInt(ano, 10);
      const mesNum = parseInt(mes, 10) - 1;
      const diaNum = parseInt(dia, 10);

      const inicio = new Date(anoNum, mesNum, diaNum, 0, 0, 0);
      const fim = new Date(anoNum, mesNum, diaNum, 23, 59, 59, 999);

      const first = await db.EnergiaMensagens.findOne({
        where: { timestamp: { [Op.between]: [inicio, fim] } },
        order: [['timestamp', 'ASC']]
      });

      const last = await db.EnergiaMensagens.findOne({
        where: { timestamp: { [Op.between]: [inicio, fim] } },
        order: [['timestamp', 'DESC']]
      });

      if (first && last) {
        const consumo = calcularConsumo(first, last);
        return res.status(200).json({ consumo, timestamp: last.timestamp });
      } else {
        return res.status(200).json({ consumo: 0, timestamp: null });
      }
    }

    if (mes && ano && !dia) {
      const anoNum = parseInt(ano, 10);
      const mesNum = parseInt(mes, 10) - 1;

      const inicio = new Date(anoNum, mesNum, 1, 0, 0, 0);
      const fim = new Date(anoNum, mesNum + 1, 0, 23, 59, 59, 999); // último dia do mês

      const first = await db.EnergiaMensagens.findOne({
        where: { timestamp: { [Op.between]: [inicio, fim] } },
        order: [['timestamp', 'ASC']]
      });

      const last = await db.EnergiaMensagens.findOne({
        where: { timestamp: { [Op.between]: [inicio, fim] } },
        order: [['timestamp', 'DESC']]
      });

      if (first && last) {
        const consumo = calcularConsumo(first, last);
        return res.status(200).json({ consumo, timestamp: last.timestamp });
      } else {
        return res.status(200).json({ consumo: 0, timestamp: null });
      }
    }

    // Caso nenhum filtro, retorna último consumo
    const last = await db.EnergiaMensagens.findOne({
      order: [['timestamp', 'DESC']],
    });

    if (last) return res.status(200).json({ consumo: last.consumoAtual, timestamp: last.timestamp });

    return res.status(200).json({ consumo: 0, timestamp: null });
  } catch (error) {
    console.error('Erro em /energia/consumo:', error);
    res.status(500).json({ error: 'Erro interno no servidor' });
  }
});

module.exports = router