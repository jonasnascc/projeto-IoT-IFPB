const { Sequelize } = require('sequelize');
require('dotenv').config();

const {DB_URL, DB_HOST, DB_PORT, DB_DATABASE, DB_USER, DB_PASSWORD} = process.env

let sequelize;

if(DB_URL) {
  sequelize = new Sequelize(DB_URL, 
    {
      dialect: 'postgres',
      logging: false,
    }
  )
}
else {
  sequelize = new Sequelize(
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
    {
      host: DB_HOST,
      port: DB_PORT,
      dialect: 'postgres',
      logging: false,
    }
  );
}

// Exporta o sequelize e os modelos
const db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;

db.PortaoMensagens = require('./PortaoMensagens')(sequelize, Sequelize)
db.EnergiaMensagens = require('./EnergiaMensagens')(sequelize, Sequelize)
db.CaixaMensagens = require('./CaixaMensagens')(sequelize, Sequelize)

module.exports = db;
