import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/caixa_model.dart';

class CaixaVolumeChart extends StatelessWidget {
  final List<CaixaModel> data;
  const CaixaVolumeChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text('Sem dados para o gráfico');
    }
    final sorted = List<CaixaModel>.from(data)
      ..sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
    // Reduz para no máximo 10 pontos
    List<CaixaModel> reduced;
    const maxPoints = 10;
    if (sorted.length > maxPoints) {
      final step = (sorted.length / maxPoints).ceil();
      reduced = [for (int i = 0; i < sorted.length; i += step) sorted[i]];
      // Garante que o último ponto seja incluído
      if (reduced.last != sorted.last) reduced.add(sorted.last);
    } else {
      reduced = sorted;
    }
    final spots = <FlSpot>[];
    for (int i = 0; i < reduced.length; i++) {
      final model = reduced[i];
      final volume = model.volume ?? 0.0;
      spots.add(FlSpot(i.toDouble(), volume));
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
                    value.toStringAsFixed(0),
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
          gridData: FlGridData(show: true, horizontalInterval: 100),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
