module.exports = function (config) {
    const {
        distanciaSensor, diametroCaixa, alturaUtil, alturaSensor
    } = config;

    const raio = diametroCaixa / 2;

    let alturaAgua = alturaSensor - distanciaSensor;

    // Garante que não passe da altura útil
    if (alturaAgua > alturaUtil) {
        alturaAgua = alturaUtil;
    } else if (alturaAgua < 0) {
        alturaAgua = 0;
    }

    const volume = Math.PI * Math.pow(raio, 2) * alturaAgua * 1000; // litros
    return Math.floor(volume * 100)/100; // 2 casas decimais
}
