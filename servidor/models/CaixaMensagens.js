module.exports = (sequelize, DataTypes) => {
  const CaixaMensagens = sequelize.define('CaixaMensagens', {
    topico: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    distancia: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    timestamp: {
      type: DataTypes.DATE,
      allowNull: false,
    },
  }, {
    timestamps: false,
  });

  return CaixaMensagens;
};