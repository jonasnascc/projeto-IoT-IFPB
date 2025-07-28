const express = require("express")
const router = express.Router()
const db = require('./models');

router.get("portao/last", async (req, res) => {
    const last = await db[tableName].findOne({ // mais antigo
        order: [['timestamp', 'DESC']],
    });

    res.send(200).json(last)
})

module.exports = router