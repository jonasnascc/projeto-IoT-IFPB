import 'package:flutter/material.dart';
import '../../../core/models/portao_model.dart';
import 'gate_open_chart.dart';
import 'caixa_volume_chart.dart';

class PortaoGraphModal extends StatelessWidget {
  final PortaoResponseModel? data;
  const PortaoGraphModal({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Gráficos do Portão',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (data?.data == null || data!.data!.isEmpty)
            const Text('Nenhum dado disponível')
          else
            GateOpenChart(
              data: (data!.data!.length > 10)
                  ? [
                      for (
                        int i = 0;
                        i < data!.data!.length;
                        i += (data!.data!.length / 10).ceil()
                      )
                        data!.data![i],
                      if (data!.data!.last !=
                          data!.data![((data!.data!.length - 1) ~/
                                  (data!.data!.length / 10).ceil()) *
                              (data!.data!.length / 10).ceil()])
                        data!.data!.last,
                    ]
                  : data!.data!,
            ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
