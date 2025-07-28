const express = require("express")
const router = express.Router()
const db = require('./models');

router.get("/portao/last", async (req, res) => {
    const last = await db.PortaoMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    res.status(200).json(last);
})

router.get("/caixa/last", async (req, res) => {
    const last = await db.CaixaMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    res.status(200).json(last);
})

router.get("/energia/last", async (req, res) => {
    const last = await db.EnergiaMensagens.findOne({
        order: [['timestamp', 'DESC']],
    });

    res.status(200).json(last);
})

module.exports = router