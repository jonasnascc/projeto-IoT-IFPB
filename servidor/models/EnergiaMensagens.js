module.exports = (sequelize, DataTypes) => {
  const EnergiaMensagens = sequelize.define('EnergiaMensagens', {
    topico: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    corrente: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    consumoAtual: {
      type: DataTypes.DECIMAL(12,6),
      allowNull: false
    },
    timestamp: {
      type: DataTypes.DATE,
      allowNull: false,
    },
  }, {
    timestamps: false,
  });

  return EnergiaMensagens;
};