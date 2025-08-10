# Um sistema de monitoramento inteligente de infraestrutura predial

Este projeto tem como objetivo o desenvolvimento de um sistema de monitoramento inteligente para condomínios, utilizando tecnologias de Internet das Coisas (IoT) para acompanhar em tempo real aspectos essenciais da infraestrutura predial. O sistema monitora três áreas principais: o nível da caixa d’água, o consumo de energia elétrica e a abertura do portão principal, oferecendo maior controle, segurança e eficiência operacional para a administração do condomínio.

O sistema de monitoramento da caixa d’água utiliza um sensor ultrassônico acoplado a um microcontrolador ESP32 para medir o nível de água em tempo real. As medições são realizadas continuamente, garantindo um acompanhamento preciso. O ESP32 processa os dados obtidos e identifica variações inesperadas no nível. Essas variações podem indicar possíveis vazamentos no reservatório. Ao detectar anomalias, o sistema pode acionar alertas visuais ou sonoros. Isso permite uma resposta rápida para evitar o desperdício de água.

No controle de acesso, um sensor de fim de curso monitora a abertura e fechamento do portão, informando o status em tempo real. Este sensor também está ligado a um ESP32, responsável por processar os dados localmente e enviá-los para a nuvem. Já o monitoramento do consumo de energia elétrica é feito por meio de um sensor de corrente, conectado a um microcontrolador ESP32. Esse sensor registra o uso de energia no condomínio, permitindo análises que podem identificar picos de consumo, possibilitar economia e prevenir falhas na rede elétrica.

Todos os dispositivos se comunicam com um gateway central, que por sua vez envia os dados para a nuvem utilizando o protocolo MQTT, permitindo o acesso remoto por meio de um aplicativo móvel. Com isso, os usuários podem acompanhar o estado do sistema de forma prática e em tempo real, de qualquer lugar.

O principal objetivo deste projeto é oferecer uma solução acessível, eficiente e automatizada para o gerenciamento de recursos essenciais em condomínios, promovendo sustentabilidade, segurança e maior comodidade para os moradores e administradores.
