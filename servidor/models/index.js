const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize(
  process.env.DB_DATABASE,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    dialect: 'postgres',
    logging: false,
  }
);

// Exporta o sequelize e os modelos
const db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;

db.PortaoMensagens = require('./PortaoMensagens')(sequelize, Sequelize)
db.EnergiaMensagens = require('./EnergiaMensagens')(sequelize, Sequelize)
db.CaixaMensagens = require('./CaixaMensagens')(sequelize, Sequelize)

module.exports = db;
