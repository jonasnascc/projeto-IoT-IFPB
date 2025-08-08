const express = require("express")
const router = express.Router()
const db = require('./models/conn');

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

        res.status(200).json({
            limit,
            offset,
            data: list,
            hasMore,
            total
        });
    } catch (err) {
        console.error("Erro ao buscar mensagens:", err);
        res.status(500).json({ error: "Erro interno do servidor" });
    }
}

//-----------------//
router.get("/portao", async (req, res) => await listFn(req, res, "PortaoMensagens"))

router.get("/portao/last", async (req, res) => {
    const last = await db.PortaoMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    res.status(200).json(last);
})
//-----------------//
router.get("/caixa", async (req, res) => await listFn(req, res, "CaixaMensagens"))

router.get("/caixa/last", async (req, res) => {
    const last = await db.CaixaMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    res.status(200).json(last);
})

//-----------------//
router.get("/energia", async (req, res) => await listFn(req, res, "EnergiaMensagens"))

router.get("/energia/last", async (req, res) => {
    const last = await db.EnergiaMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    res.status(200).json(last);
})

module.exports = router