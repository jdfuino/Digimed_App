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
import 'dart:math' as math;

class GraphGlucose extends StatefulWidget {
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
  final VoidCallback? onInfoPressed; // Callback para el botón de información
  final double chartHeight = 100;

  const GraphGlucose(
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
        required this.dataBarGroups,
        this.onInfoPressed}); // Parámetro opcional para el callback de información

  @override
  State<GraphGlucose> createState() => _GraphGlucoseState();
}

class _GraphGlucoseState extends State<GraphGlucose>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _lastSelectedTime = "";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    // Iniciar animación al crear el widget
    _startAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  // Método para calcular el rango dinámico del gráfico
  Map<String, double> _calculateDynamicRange() {
    // Obtener valores mínimos y máximos de los datos
    double dataMin = double.infinity;
    double dataMax = double.negativeInfinity;

    for (var group in widget.dataBarGroups) {
      for (var rod in group.barRods) {
        if (rod.toY < dataMin) dataMin = rod.toY;
        if (rod.toY > dataMax) dataMax = rod.toY;
      }
    }

    // Si no hay datos, usar las zonas seguras como referencia
    if (dataMin == double.infinity || dataMax == double.negativeInfinity) {
      dataMin = widget.minSafeZone ?? 0;
      dataMax = widget.maxSafeZone;
    }

    // Determinar el valor máximo real entre los datos y maxSafeZone
    double actualMax = math.max(dataMax, widget.maxSafeZone);

    // Determinar el valor mínimo real entre los datos y minSafeZone (si existe)
    double actualMin = widget.minSafeZone != null ?
    math.min(dataMin, widget.minSafeZone!) : dataMin;

    // Aplicar márgenes del 10% basándose en los valores reales
    double finalMax = actualMax + (actualMax * 0.1);
    double finalMin = actualMin - (actualMin * 0.1);

    // Asegurar que el mínimo no sea negativo para valores de salud
    finalMin = finalMin.clamp(0, double.infinity);

    return {
      'min': finalMin,
      'max': finalMax,
      'dataMin': dataMin,
      'dataMax': dataMax,
    };
  }

  // Método para generar labels del eje Y dinámicamente
  List<double> _generateYAxisLabels(double minY, double maxY) {
    List<double> labels = [];
    double range = maxY - minY;

    // Determinar el número óptimo de labels (entre 4-6 labels)
    int numLabels = 5;
    double interval = range / (numLabels - 1);

    // Redondear el intervalo para valores más legibles
    if (interval > 0) {
      double magnitude = math.pow(10, (math.log(interval) / math.ln10).floor()).toDouble();
      double normalizedInterval = interval / magnitude;

      if (normalizedInterval <= 1) {
        interval = magnitude;
      } else if (normalizedInterval <= 2) {
        interval = 2 * magnitude;
      } else if (normalizedInterval <= 5) {
        interval = 5 * magnitude;
      } else {
        interval = 10 * magnitude;
      }
    }

    // Generar labels comenzando desde un valor redondeado
    double startValue = (minY / interval).ceil() * interval;
    double currentValue = startValue;

    while (currentValue <= maxY && labels.length < 6) {
      labels.add(currentValue);
      currentValue += interval;
    }

    // Asegurar que tenemos al menos el valor mínimo y máximo aproximados
    if (labels.isEmpty || labels.first > minY + range * 0.1) {
      labels.insert(0, minY);
    }
    if (labels.isEmpty || labels.last < maxY - range * 0.1) {
      labels.add(maxY);
    }

    return labels;
  }

  // Método para calcular el grosor de las barras según el número de barras
  double _calculateBarWidth() {
    int numBars = widget.dataBarGroups.length;
    if (numBars == 0) return 20.0;
    return 15.0;
    //
    // // Ajustar el grosor de manera más sutil
    // double baseWidth = 20.0; // Grosor base
    // double maxWidth = 30.0;  // Máximo grosor reducido
    //
    // if (numBars == 1) {
    //   // Para una sola barra, usar un grosor moderado
    //   return 20.0;
    // } else if (numBars <= 3) {
    //   // Para pocas barras (2-3), grosor ligeramente mayor
    //   return baseWidth + 3.0;
    // } else if (numBars <= 6) {
    //   // Para más barras, usar grosor base o ligeramente menor
    //   double calculatedWidth = baseWidth - (numBars - 3) * 1.5;
    //   return calculatedWidth.clamp(18.0, baseWidth);
    // } else {
    //   // Para más de 6 barras, usar grosor mínimo
    //   return 18.0;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final HistoricPatientsController controller = Provider.of(context);
    return CardDigimed(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título y selector
            Row(
              children: [
                // Indicador de información (copiado del chart_card)
                InkWell(
                  onTap: widget.onInfoPressed,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 24,
                    height: 24,
                    child: const Icon(
                      Icons.info,
                      color: AppColors.backgroundColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: AppTextStyle.normalContentTextStyle,
                ),
                const Spacer(),
                widget.showSelectedTime ?? true
                    ? _buildTimeSelector(context, controller)
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 16),

            // Mensaje de estado de glucosa
            widget.buildStatusMessage(),

            const SizedBox(height: 16),
            const Divider(color: AppColors.dividerColor),

            // Valor promedio destacado
            Row(
              children: [
                // Valor promedio - tamaño fijo pero responsivo
                Flexible(
                  flex: 3,
                  child: controller.state.glucoseDataState.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    failed: (failure) => _buildErrorState(),
                    nullData: () => _buildErrorState(),
                    loaded: (_) => _buildAverageValue(widget.valueProm, widget.unit),
                  ),
                ),

                const Spacer(),

                // Gráfico mejorado - se expande para usar el espacio restante
                Expanded(
                  flex: 3,
                  child: controller.state.glucoseDataState.when(
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
              controller.valueSelectedGlucose,
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
        widget.onTimeSelected(value);
      },
      itemBuilder: (BuildContext context) {
        return ["1 semana", "1 mes", "6 meses"].map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: ListTile(
              title: Text(value),
              leading: Radio<String>(
                value: value,
                groupValue: controller.valueSelectedGlucose,
                onChanged: (value) {
                  if (value != null) {
                    widget.onTimeSelected(value);
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
          "Presión Promedio",
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
    // Detectar cambio en el rango de tiempo para reiniciar la animación
    if (_lastSelectedTime != controller.valueSelectedGlucose) {
      _lastSelectedTime = controller.valueSelectedGlucose;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAnimation();
      });
    }

    final dynamicRange = _calculateDynamicRange();
    final double chartMinY = dynamicRange['min']!;
    final double chartMaxY = dynamicRange['max']!;
    final double barWidth = _calculateBarWidth();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Crear barras animadas - las barras suben desde chartMinY hasta su valor final
        List<BarChartGroupData> animatedBarGroups = widget.dataBarGroups.map((group) {
          return BarChartGroupData(
            x: group.x,
            barRods: group.barRods.map((rod) {
              // Calcular el valor animado: desde chartMinY hasta el valor final
              double animatedValue = chartMinY + ((rod.toY - chartMinY) * _animation.value);

              return BarChartRodData(
                toY: animatedValue,
                color: rod.color,
                width: barWidth,
                borderRadius: rod.borderRadius,
                backDrawRodData: rod.backDrawRodData,
                rodStackItems: rod.rodStackItems,
              );
            }).toList(),
            barsSpace: group.barsSpace,
            showingTooltipIndicators: group.showingTooltipIndicators,
          );
        }).toList();

        return SizedBox(
          height: widget.chartHeight,
          child: Stack(
            children: [
              // Zona verde de referencia PRIMERO (detrás de las barras)
              if (widget.minSafeZone != null &&
                  widget.maxSafeZone >= chartMinY &&
                  widget.minSafeZone! <= chartMaxY)
                Positioned(
                  left: 0,
                  right: 0,
                  top: _calculateNormalZoneTop(chartMinY, chartMaxY),
                  child: Container(
                    height: _calculateNormalZoneHeight(chartMinY, chartMaxY),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSettingSaveColorWithOpacity,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

              // Gráfico de barras ENCIMA de la zona segura
              BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      // Mismo estilo que chart_card: fondo gris claro
                      getTooltipColor: (group) => Colors.grey.shade50,
                      tooltipPadding: const EdgeInsets.all(16),
                      tooltipMargin: 12,
                      tooltipBorderRadius: BorderRadius.circular(16),
                      // Borde más visible para crear contraste
                      tooltipBorder: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                      fitInsideHorizontally: true,
                      fitInsideVertically: false,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        // Obtener el valor real de la barra (no el animado)
                        double realValue = widget.dataBarGroups[groupIndex].barRods[rodIndex].toY;
                        String formattedValue = realValue.toStringAsFixed(0);

                        // Obtener el rango de fechas real desde el controlador
                        String timeRange = controller.getGlucoseTimeRangeForPoint(groupIndex);

                        // Determinar si está en rango y el color correspondiente
                        bool inRange = (widget.minSafeZone != null && realValue >= widget.minSafeZone! && realValue <= widget.maxSafeZone) ||
                            (widget.minSafeZone == null && realValue <= widget.maxSafeZone);

                        Color valueColor = inRange ? Colors.green : Colors.amber.shade700;

                        return BarTooltipItem(
                          "",
                          const TextStyle(fontSize: 0),
                          children: [
                            TextSpan(
                              text: "$timeRange\n",
                              style: AppTextStyle.normal14W400ContentTextStyle,
                            ),
                            TextSpan(
                              text: "$formattedValue ${widget.unit}",
                              style: TextStyle(
                                color: valueColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      // Callback opcional para manejar interacciones adicionales
                    },
                  ),
                  minY: chartMinY,
                  maxY: chartMaxY,
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
                  barGroups: animatedBarGroups,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Método auxiliar para obtener el mes con formato correcto (Ene, Feb, Mar, etc.)
  String _getFormattedMonth(int month) {
    String monthAbbr = obtenerAbreviaturaMes(month);
    // Convertir a formato: Primera letra mayúscula, resto minúsculas
    return monthAbbr[0].toUpperCase() + monthAbbr.substring(1).toLowerCase();
  }

  // Método para obtener el texto del rango de tiempo
  String _getTimeRangeText(String selectedTime) {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedTime) {
      case "1 semana":
        startDate = now.subtract(const Duration(days: 7));
        break;
      case "1 mes":
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case "6 meses":
        startDate = DateTime(now.year, now.month - 6, now.day);
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    // Obtener nombres de meses formateados correctamente
    String startMonth = _getFormattedMonth(startDate.month);
    String endMonth = _getFormattedMonth(now.month);

    String startDay = startDate.day.toString();
    String endDay = now.day.toString();

    // Si es el mismo día, mostrar solo una fecha
    if (startDate.day == now.day && startDate.month == now.month && startDate.year == now.year) {
      return "$startMonth $startDay";
    }

    // Si es el mismo mes, mostrar "Mes Día - Día"
    if (startDate.month == now.month && startDate.year == now.year) {
      return "$startMonth $startDay - $endDay";
    }

    // Si son meses diferentes, mostrar "Mes Día - Mes Día"
    return "$startMonth $startDay - $endMonth $endDay";
  }

  // Método para obtener el estado del valor
  String _getValueStatus(double value) {
    bool inRange = (widget.minSafeZone != null && value >= widget.minSafeZone! && value <= widget.maxSafeZone) ||
        (widget.minSafeZone == null && value <= widget.maxSafeZone);

    if (inRange) {
      return "✓ En rango seguro";
    } else if (value > widget.maxSafeZone) {
      return "⚠ Por encima del rango";
    } else if (widget.minSafeZone != null && value < widget.minSafeZone!) {
      return "⚠ Por debajo del rango";
    } else {
      return "⚠ Fuera del rango";
    }
  }

  // Métodos actualizados para calcular la posición y altura de la zona normal con rango dinámico
  double _calculateNormalZoneTop(double chartMinY, double chartMaxY) {
    // Calcular la posición top de la zona normal relativa al rango dinámico
    double chartRange = chartMaxY - chartMinY;
    double normalRangeTop = widget.maxSafeZone.clamp(chartMinY, chartMaxY);
    return (widget.chartHeight * (chartMaxY - normalRangeTop)) / chartRange;
  }

  double _calculateNormalZoneHeight(double chartMinY, double chartMaxY) {
    // Calcular la altura de la zona normal relativa al rango dinámico
    double chartRange = chartMaxY - chartMinY;

    if (widget.minSafeZone == null) return 0;

    // Asegurar que las zonas estén dentro del rango visible
    double visibleMinSafe = widget.minSafeZone!.clamp(chartMinY, chartMaxY);
    double visibleMaxSafe = widget.maxSafeZone.clamp(chartMinY, chartMaxY);

    double normalRangeHeight = visibleMaxSafe - visibleMinSafe;
    return (widget.chartHeight * normalRangeHeight) / chartRange;
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
