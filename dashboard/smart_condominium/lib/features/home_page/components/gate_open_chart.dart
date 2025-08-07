import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/portao_model.dart';

class GateOpenChart extends StatelessWidget {
  final List<PortaoModel> data;
  const GateOpenChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text('Sem dados para o gráfico');
    }
    // Ordena por timestamp
    final sorted = List<PortaoModel>.from(data)
      ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
    // Prepara os pontos do gráfico
    final spots = <FlSpot>[];
    for (int i = 0; i < sorted.length; i++) {
      final model = sorted[i];
      final time =
          DateTime.tryParse(
            model.timestamp ?? '',
          )?.millisecondsSinceEpoch.toDouble() ??
          i.toDouble();
      final open = (model.gateOpen ?? false) ? 1.0 : 0.0;
      spots.add(FlSpot(i.toDouble(), open));
    }
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 1) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('Open', style: TextStyle(fontSize: 12)),
                    );
                  }
                  if (value == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('Close', style: TextStyle(fontSize: 12)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < sorted.length && idx % 2 == 0) {
                    final ts = sorted[idx].timestamp;
                    if (ts != null && ts.length >= 16) {
                      // Mostra só HH:mm
                      return Text(
                        ts.substring(11, 16),
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          minY: 0,
          maxY: 1,
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            verticalInterval: 2,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
