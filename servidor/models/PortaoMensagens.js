module.exports = (sequelize, DataTypes) => {
  const PortaoMensagens = sequelize.define('PortaoMensagens', {
    topico: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    gate_open: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
    },
    timestamp: {
      type: DataTypes.DATE,
      allowNull: false,
    },
  }, {
    timestamps: false,
  });

  return PortaoMensagens;
};