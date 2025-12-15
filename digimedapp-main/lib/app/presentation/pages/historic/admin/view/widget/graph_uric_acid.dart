import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/state/historic_patients_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphUricAcid extends StatelessWidget {
  final String title;
  final double valueProm;
  final String unit;
  final double? minSafeZone;
  final double maxSafeZone;
  final double maxValue;
  final Widget Function() buildStatusMessage;
  final bool? showSelectedTime;
  final Function(String) onTimeSelected;
  final List<BarChartGroupData> dataBarGroups;
  final double chartHeight = 100;

  const GraphUricAcid(
      {super.key,
      required this.title,
      required this.valueProm,
      required this.unit,
      this.minSafeZone,
      required this.maxSafeZone,
      required this.maxValue,
      required this.buildStatusMessage,
      this.showSelectedTime,
      required this.onTimeSelected,
      required this.dataBarGroups});

  @override
  Widget build(BuildContext context) {
    final HistoricPatientsController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return CardDigimed(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título y selector
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppTextStyle.normalContentTextStyle,
                ),
                const Spacer(),
                showSelectedTime ?? true
                    ? _buildTimeSelector(context, controller)
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 16),

            buildStatusMessage(),

            const SizedBox(height: 16),
            const Divider(color: AppColors.dividerColor),

            // Valor promedio destacado
            Row(
              children: [
                // Valor promedio - tamaño fijo pero responsivo
                Flexible(
                  flex: 3,
                  child: controller.state.uricAcidDataState.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    failed: (failure) => _buildErrorState(),
                    nullData: () => _buildErrorState(),
                    loaded: (_) => _buildAverageValue(valueProm, unit),
                  ),
                ),

                const Spacer(),

                // Gráfico mejorado - se expande para usar el espacio restante
                Expanded(
                  flex: 3,
                  child: controller.state.uricAcidDataState.when(
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    failed: (failure) => _buildErrorState(),
                    nullData: () => _buildErrorState(),
                    loaded: (_) => _buildEnhancedChart(controller),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector(
      BuildContext context, HistoricPatientsController controller) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.buttonSelectedRangeColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.valueSelectedUricAcid,
              style: AppTextStyle.normalBlueTextStyle,
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.backgroundColor,
              size: 16,
            ),
          ],
        ),
      ),
      onSelected: (String value) {
        onTimeSelected(value);
      },
      itemBuilder: (BuildContext context) {
        return ["1 semana", "1 mes", "6 meses"].map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: ListTile(
              title: Text(value),
              leading: Radio<String>(
                value: value,
                groupValue: controller.valueSelectedUricAcid,
                onChanged: (value) {
                  if (value != null) {
                    onTimeSelected(value);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildAverageValue(double value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Acido Úrico Promedio",
          style: AppTextStyle.grey13W500ContentTextStyle,
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: showNumber(value),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundColor,
                ),
              ),
              TextSpan(
                text: " $unit",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedChart(HistoricPatientsController controller) {
    return SizedBox(
      height: chartHeight,
      child: Stack(
        children: [
          // Gráfico de barras
          BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String formattedValue = rod.toY.toStringAsFixed(0);
                    return BarTooltipItem(
                      "$formattedValue $unit",
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              minY: 0,
              maxY: maxValue,
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: dataBarGroups,
            ),
          ),

          // Zona verde de referencia (rango normal 90-129 mmHg)
          Positioned(
            left: 0,
            right: 0,
            top: _calculateNormalZoneTop(),
            child: Container(
              height: _calculateNormalZoneHeight(),
              decoration: BoxDecoration(
                color: AppColors.backgroundSettingSaveColorWithOpacity,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Métodos para calcular la posición y altura de la zona normal
  double _calculateNormalZoneTop() {
    // Calcular la posición top de la zona normal (rango 90-129)
    // Mapear 129 mmHg a la posición en el gráfico de 200 mmHg máximo
    double normalRangeTop = maxSafeZone;
    return (chartHeight * (maxValue - normalRangeTop)) / maxValue;
  }

  double _calculateNormalZoneHeight() {
    // Calcular la altura de la zona normal (rango 90-129)
    double normalRangeHeight =
        minSafeZone != null ? maxSafeZone - minSafeZone! : 2; // 39 mmHg
    return (chartHeight * normalRangeHeight) / maxValue;
  }

  Widget _buildErrorState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.grey[400],
              size: 48,
            ),
            const SizedBox(height: 8),
            const Text(
              "¡No hay datos disponibles!",
              style: AppTextStyle.grey13W500ContentTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
