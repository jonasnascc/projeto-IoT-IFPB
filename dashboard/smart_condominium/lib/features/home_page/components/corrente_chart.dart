import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/energia_model.dart';

class CorrenteChart extends StatelessWidget {
  final List<EnergiaModel> data;
  const CorrenteChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text('Sem dados para o gráfico');
    }
    final sorted = List<EnergiaModel>.from(data)
      ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
    // Reduz para no máximo 10 pontos
    List<EnergiaModel> reduced;
    const maxPoints = 10;
    if (sorted.length > maxPoints) {
      final step = (sorted.length / maxPoints).ceil();
      reduced = [for (int i = 0; i < sorted.length; i += step) sorted[i]];
      if (reduced.last != sorted.last) reduced.add(sorted.last);
    } else {
      reduced = sorted;
    }
    final spots = <FlSpot>[];
    for (int i = 0; i < reduced.length; i++) {
      final model = reduced[i];
      final corrente = model.corrente ?? 0.0;
      spots.add(FlSpot(i.toDouble(), corrente));
    }
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 10),
                  );
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
                  if (idx >= 0 && idx < reduced.length) {
                    final ts = reduced[idx].timestamp;
                    if (ts != null && ts.length >= 16) {
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
          maxY: spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1,
          gridData: FlGridData(show: true, horizontalInterval: 0.5),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.orange,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
