import 'dart:math' as math;
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget que muestra un gráfico de líneas para datos de presión arterial
/// con animaciones, bandas de seguridad y tooltip interactivo
class ChartCard extends StatefulWidget {
  // Propiedades del gráfico
  final String title;
  final double valueProm; // Promedio sistólico
  final double valueDiastolicProm; // Promedio diastólico
  final String unit;

  // Configuración de zonas seguras
  final double? minSafeZone; // Zona segura sistólica min
  final double maxSafeZone; // Zona segura sistólica max
  final double? minSafeZone2; // Zona segura diastólica min
  final double maxSafeZone2; // Zona segura diastólica max
  final double maxValue; // Valor máximo del gráfico

  // Configuración de UI
  final Widget Function() buildStatusMessage;
  final bool? showSelectedTime;
  final Function(String) onTimeSelected;
  final VoidCallback? onInfoPressed; // Callback para el botón de información

  // Datos del gráfico
  final List<FlSpot> systolicSpots; // Puntos de presión sistólica
  final List<FlSpot> diastolicSpots; // Puntos de presión diastólica
  final List<String> xLabels; // Etiquetas del eje X (no usadas actualmente)

  // Fechas de los registros reales
  final DateTime? oldestRecordDate; // Fecha del registro más antiguo
  final DateTime? newestRecordDate; // Fecha del registro más reciente

  const ChartCard({
    super.key,
    required this.buildStatusMessage,
    required this.onTimeSelected,
    required this.title,
    this.showSelectedTime,
    required this.valueProm,
    required this.valueDiastolicProm,
    required this.unit,
    this.minSafeZone,
    required this.maxSafeZone,
    required this.maxValue,
    required this.minSafeZone2,
    required this.maxSafeZone2,
    required this.systolicSpots,
    required this.diastolicSpots,
    required this.xLabels,
    this.onInfoPressed, // Parámetro opcional para el callback de información
    this.oldestRecordDate, // Parámetro opcional para la fecha más antigua
    this.newestRecordDate, // Parámetro opcional para la fecha más reciente
  });

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> with TickerProviderStateMixin {
  // Configuración de animación
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Constantes
  static const double chartHeight = 200;
  static const Duration animationDuration = Duration(milliseconds: 2000);

  // Para detectar cambios en los datos y reactivar animación
  List<FlSpot>? _previousSystolicSpots;
  List<FlSpot>? _previousDiastolicSpots;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _saveInitialData();
  }

  /// Inicializa el controlador de animación
  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  /// Guarda los datos iniciales para detectar cambios
  void _saveInitialData() {
    _previousSystolicSpots = List.from(widget.systolicSpots);
    _previousDiastolicSpots = List.from(widget.diastolicSpots);
  }

  @override
  void didUpdateWidget(ChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detectar cambios en los datos para reiniciar animación
    if (_dataChanged(oldWidget)) {
      _restartAnimation();
      _saveInitialData();
    }
  }

  /// Verifica si los datos cambiaron
  bool _dataChanged(ChartCard oldWidget) {
    return !_listsEqual(oldWidget.systolicSpots, widget.systolicSpots) ||
           !_listsEqual(oldWidget.diastolicSpots, widget.diastolicSpots);
  }

  /// Reinicia la animación cuando cambian los datos
  void _restartAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  /// Compara dos listas de FlSpot para detectar cambios
  bool _listsEqual(List<FlSpot> list1, List<FlSpot> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].x != list2[i].x || list1[i].y != list2[i].y) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HistoricPatientsController controller = Provider.of(context);

    // Verificar si hay suficientes datos para graficar
    final bool hasSufficientData = _hasSufficientData();

    return CardDigimed(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(controller),
            const SizedBox(height: 16),
            // Solo mostrar estos widgets si hay suficientes datos
            if (hasSufficientData) ...[
              widget.buildStatusMessage(),
              const SizedBox(height: 16),
              const Divider(color: AppColors.dividerColor),
            ],
            _buildChart(controller),
            if (hasSufficientData) ...[
              const SizedBox(height: 16),
              _buildLegend(),
              const SizedBox(height: 16),
              _buildAverageDisplay(),
            ],
          ],
        ),
      ),
    );
  }

  /// Verifica si hay suficientes datos para mostrar el gráfico completo
  bool _hasSufficientData() {
    // Contar el número de puntos únicos, no la suma total
    final int maxSpots = math.max(widget.systolicSpots.length, widget.diastolicSpots.length);
    return maxSpots >= 5;
  }

  /// Construye el header con título y selector de tiempo
  Widget _buildHeader(HistoricPatientsController controller) {
    return Row(
      children: [
        // Indicador de información
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
        Text(widget.title, style: AppTextStyle.normalContentTextStyle),
        const Spacer(),
        if (widget.showSelectedTime ?? true) _buildTimeSelector(controller),
      ],
    );
  }

  /// Construye el selector de rango de tiempo
  Widget _buildTimeSelector(HistoricPatientsController controller) {
    return PopupMenuButton<String>(
      onSelected: widget.onTimeSelected,
      itemBuilder: (BuildContext context) {
        return ["1 semana", "1 mes", "6 meses"].map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: ListTile(
              title: Text(value),
              leading: Radio<String>(
                value: value,
                groupValue: controller.valueSelectedSystolic,
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
              controller.valueSelectedSystolic,
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
    );
  }

  /// Construye el gráfico principal
  Widget _buildChart(HistoricPatientsController controller) {
    return SizedBox(
      width: double.infinity,
      height: chartHeight,
      child: controller.state.bloodPressureDataState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        failed: (failure) => _buildErrorState(),
        nullData: () => _buildErrorState(),
        loaded: (_) => AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => _buildLineChart(),
        ),
      ),
    );
  }

  /// Construye el gráfico de líneas con datos
  Widget _buildLineChart() {
    // Validar que hay datos para mostrar
    if (widget.systolicSpots.isEmpty && widget.diastolicSpots.isEmpty) {
      return _buildErrorState();
    }

    // Calcular rango inteligente basado en los datos
    final chartRange = _calculateChartRange();

    return Stack(
      children: [
        _buildSafeZones(chartRange),
        _buildMainChart(chartRange),
      ],
    );
  }

  /// Calcula el rango óptimo para el gráfico basado en los datos
  _ChartRange _calculateChartRange() {
    final allYs = [
      ...widget.systolicSpots.map((e) => e.y),
      ...widget.diastolicSpots.map((e) => e.y),
    ];

    if (allYs.isEmpty) {
      return _ChartRange(minY: 0, maxY: 200, interval: 20);
    }

    final double dataMin = allYs.reduce((a, b) => a < b ? a : b);
    final double dataMax = allYs.reduce((a, b) => a > b ? a : b);

    // Agregar margen del 10%
    final double range = dataMax - dataMin;
    final double margin = range * 0.1;

    // Redondear a valores "agradables"
    final double yMin = math.max(_roundToNiceValue(dataMin - margin, isMin: true), 0.0);
    final double yMax = math.min(_roundToNiceValue(dataMax + margin, isMin: false), 200.0);
    final double interval = _calculateNiceInterval(yMin, yMax);

    return _ChartRange(minY: yMin, maxY: yMax, interval: interval);
  }

  /// Redondea valores a números "agradables" para los ejes
  double _roundToNiceValue(double value, {required bool isMin}) {
    if (value <= 0) return 0;

    double step;
    if (value <= 50) {
      step = 5; // Múltiplos de 5 para valores bajos
    } else if (value <= 100) {
      step = 10; // Múltiplos de 10 para valores medios
    } else {
      step = value > 150 ? 20 : 10; // Múltiplos de 10 o 20 para valores altos
    }

    return isMin
        ? (value / step).floor() * step
        : (value / step).ceil() * step;
  }

  /// Calcula un intervalo agradable para las líneas de la grilla
  double _calculateNiceInterval(double minY, double maxY) {
    final double range = maxY - minY;
    final double targetTicks = 5;
    double rough = range / targetTicks;

    final double magnitude = math.pow(10, (math.log(rough) / math.ln10).floor()).toDouble();
    final double residual = rough / magnitude;

    double nice;
    if (residual >= 5) {
      nice = 5 * magnitude;
    } else if (residual >= 2) {
      nice = 2 * magnitude;
    } else {
      nice = 1 * magnitude;
    }

    return math.max(nice, 5); // Mínimo intervalo de 5 para presión arterial
  }

  /// Construye las zonas de seguridad (bandas de fondo)
  Widget _buildSafeZones(_ChartRange range) {
    return AnimatedOpacity(
      opacity: _animation.value,
      duration: const Duration(milliseconds: 300),
      child: Stack(
        children: [
          // Zona segura sistólica
          if (widget.minSafeZone != null &&
              widget.maxSafeZone >= range.minY &&
              widget.minSafeZone! <= range.maxY)
            _buildSafeZone(
              widget.minSafeZone!,
              widget.maxSafeZone,
              range,
              AppColors.backgroundSettingSaveColorWithOpacity.withOpacity(0.3)
            ),

          // Zona segura diastólica
          if (widget.minSafeZone2 != null &&
              widget.maxSafeZone2 >= range.minY &&
              widget.minSafeZone2! <= range.maxY)
            _buildSafeZone(
              widget.minSafeZone2!,
              widget.maxSafeZone2,
              range,
              AppColors.backgroundSettingSaveColorWithOpacity.withOpacity(0.3)
            ),
        ],
      ),
    );
  }

  /// Construye una zona de seguridad individual
  Widget _buildSafeZone(double minRange, double maxRange, _ChartRange range, Color color) {
    return Positioned(
      left: 30, // Espacio para las etiquetas del eje Y
      right: 0,
      top: _calculateZoneTop(maxRange, range),
      child: Container(
        height: _calculateZoneHeight(minRange, maxRange, range),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// Calcula la posición superior de una zona de seguridad
  double _calculateZoneTop(double maxRange, _ChartRange range) {
    if (maxRange > range.maxY) return 0;
    return (chartHeight * (range.maxY - maxRange)) / (range.maxY - range.minY);
  }

  /// Calcula la altura de una zona de seguridad
  double _calculateZoneHeight(double minRange, double maxRange, _ChartRange range) {
    final double effectiveMin = math.max(minRange, range.minY);
    final double effectiveMax = math.min(maxRange, range.maxY);
    return (chartHeight * (effectiveMax - effectiveMin)) / (range.maxY - range.minY);
  }

  /// Construye el gráfico de líneas principal
  Widget _buildMainChart(_ChartRange range) {
    final double maxX = math.max(
      widget.systolicSpots.isNotEmpty ? widget.systolicSpots.length - 1 : 0,
      widget.diastolicSpots.isNotEmpty ? widget.diastolicSpots.length - 1 : 0,
    ).toDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: range.minY,
        maxY: range.maxY,
        gridData: _buildGridData(range),
        borderData: FlBorderData(show: false),
        titlesData: _buildTitlesData(range),
        lineBarsData: _buildLineBarsData(),
        lineTouchData: _buildTouchData(),
      ),
    );
  }

  /// Configuración de la grilla del gráfico
  FlGridData _buildGridData(_ChartRange range) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: range.interval,
      getDrawingHorizontalLine: (value) => FlLine(
        color: Colors.grey.withOpacity(0.15 * _animation.value),
        strokeWidth: 1,
      ),
    );
  }

  /// Configuración de los títulos de los ejes
  FlTitlesData _buildTitlesData(_ChartRange range) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: range.interval,
          getTitlesWidget: (value, meta) => _buildYAxisLabel(value, range),
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  /// Construye las etiquetas del eje Y
  Widget _buildYAxisLabel(double value, _ChartRange range) {
    if (value < range.minY - 1e-6 || value > range.maxY + 1e-6) {
      return const SizedBox.shrink();
    }

    final bool isTick = (value % range.interval).abs() < 1e-6 ||
                       (range.interval - (value % range.interval)).abs() < 1e-6;

    if (!isTick) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: _animation.value,
      duration: const Duration(milliseconds: 300),
      child: Text(
        value.round().toString(),
        style: const TextStyle(fontSize: 10, color: Colors.grey),
        textAlign: TextAlign.left,
      ),
    );
  }

  /// Configuración de las líneas de datos
  List<LineChartBarData> _buildLineBarsData() {
    const double lineWidth = 3;
    const double dotRadius = 6;
    const double strokeWidth = 2;

    return [
      // Línea sistólica (continua)
      if (widget.systolicSpots.isNotEmpty)
        LineChartBarData(
          spots: _getAnimatedSpots(widget.systolicSpots),
          isCurved: true,
          color: AppColors.backgroundColor.withOpacity(_animation.value),
          barWidth: lineWidth,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => _buildDotPainter(
              spot, widget.minSafeZone, widget.maxSafeZone, dotRadius, strokeWidth
            ),
          ),
        ),

      // Línea diastólica (punteada)
      if (widget.diastolicSpots.isNotEmpty)
        LineChartBarData(
          spots: _getAnimatedSpots(widget.diastolicSpots),
          isCurved: true,
          color: AppColors.backgroundColor.withOpacity(_animation.value),
          barWidth: lineWidth,
          isStrokeCapRound: true,
          dashArray: [8, 8], // Patrón de línea punteada
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => _buildDotPainter(
              spot, widget.minSafeZone2, widget.maxSafeZone2, dotRadius, strokeWidth
            ),
          ),
        ),
    ];
  }

  /// Construye el painter para los puntos de las líneas
  FlDotPainter _buildDotPainter(FlSpot spot, double? minSafe, double maxSafe, double radius, double strokeWidth) {
    final bool inRange = _inRange(spot.y, minSafe, maxSafe);
    final Color color = (inRange ? AppColors.backgroundColor : Colors.amber)
        .withOpacity(_animation.value);

    return FlDotCirclePainter(
      radius: radius * _animation.value,
      color: color,
      strokeWidth: strokeWidth,
      strokeColor: Colors.white.withOpacity(_animation.value),
    );
  }

  /// Configuración del tooltip interactivo
  LineTouchData _buildTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        // Usar un fondo ligeramente gris en lugar de blanco puro
        getTooltipColor: (touchedSpot) => Colors.grey.shade50,
        tooltipPadding: const EdgeInsets.all(16),
        tooltipMargin: 12,
        tooltipBorderRadius: BorderRadius.circular(16),
        // Borde más visible para crear contraste
        tooltipBorder: BorderSide(
          color: Colors.grey.shade400,
          width: 1.5,
        ),
        getTooltipItems: _buildTooltipItems,
        fitInsideHorizontally: true,
        fitInsideVertically: false,
      ),
    );
  }

  /// Construye los elementos del tooltip
  List<LineTooltipItem?> _buildTooltipItems(List<LineBarSpot> touchedSpots) {
    if (touchedSpots.isEmpty) return [];

    final barSpot = touchedSpots.first;
    final int pointIndex = barSpot.x.toInt();

    // Obtener valores de ambas presiones
    double? systolicValue;
    double? diastolicValue;

    if (widget.systolicSpots.isNotEmpty && pointIndex < widget.systolicSpots.length) {
      systolicValue = widget.systolicSpots[pointIndex].y;
    }
    if (widget.diastolicSpots.isNotEmpty && pointIndex < widget.diastolicSpots.length) {
      diastolicValue = widget.diastolicSpots[pointIndex].y;
    }

    // Generar información del tooltip
    final dateRange = _getDateRangeForPoint(pointIndex);
    final bool systolicInRange = systolicValue != null ?
        _inRange(systolicValue, widget.minSafeZone, widget.maxSafeZone) : false;
    final bool diastolicInRange = diastolicValue != null ?
        _inRange(diastolicValue, widget.minSafeZone2, widget.maxSafeZone2) : false;

    final Color valueColor = (systolicInRange && diastolicInRange)
        ? Colors.green
        : Colors.amber.shade700;

    final String pressureText = systolicValue != null && diastolicValue != null
        ? '${systolicValue.toStringAsFixed(0)} / ${diastolicValue.toStringAsFixed(0)} mmHg'
        : systolicValue != null
            ? '${systolicValue.toStringAsFixed(0)} / -- mmHg'
            : '-- / ${diastolicValue?.toStringAsFixed(0) ?? '--'} mmHg';

    // Solo mostrar tooltip para el primer punto tocado
    return touchedSpots.map((spot) {
      if (spot == touchedSpots.first) {
        return LineTooltipItem(
          "",
          const TextStyle(fontSize: 0),
          children: [
            TextSpan(
              text: "$dateRange\n",
              style: AppTextStyle.normal14W400ContentTextStyle,
            ),
            TextSpan(
              text: pressureText,
              style: TextStyle(
                color: valueColor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        );
      } else {
        return const LineTooltipItem('', TextStyle(fontSize: 0));
      }
    }).toList();
  }

  /// Construye la leyenda del gráfico
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem("Sistolica", isSystemic: true),
        const SizedBox(width: 24),
        _buildLegendItem("Diastolica", isSystemic: false),
      ],
    );
  }

  /// Construye un elemento individual de la leyenda
  Widget _buildLegendItem(String label, {required bool isSystemic}) {
    return Row(
      children: [
        if (isSystemic)
          // Línea continua para sistólica
          Container(
            width: 24,
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(1),
            ),
          )
        else
          // Línea punteada para diastólica
          Row(
            children: List.generate(3, (index) => Container(
              margin: EdgeInsets.only(right: index < 2 ? 2 : 0),
              width: 6,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(1),
              ),
            )),
          ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyle.normal14W400ContentTextStyle),
      ],
    );
  }

  /// Construye la visualización del promedio con rango de fechas
  Widget _buildAverageDisplay() {
    final String dateRange = _getDateRangeForChart();

    return Center(
      child: Column(
        children: [
          // Mostrar rango de fechas
          Text(
            dateRange,
            style: AppTextStyle.normal14W400ContentTextStyle.copyWith(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Promedio de presión arterial
          RichText(
            text: TextSpan(
              text: "Presion Arterial promedio: ",
              style: AppTextStyle.normal14W400ContentTextStyle,
              children: [
                TextSpan(
                  text: "${widget.valueProm.round()}/${widget.valueDiastolicProm.round()} ${widget.unit}",
                  style: AppTextStyle.normal14W400ContentTextStyle.copyWith(
                    color: AppColors.backgroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text: ".",
                  style: AppTextStyle.normal14W400ContentTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Obtiene el rango de fechas de los registros graficados
  String _getDateRangeForChart() {
    // Si tenemos las fechas reales de los registros, usarlas
    if (widget.oldestRecordDate != null && widget.newestRecordDate != null) {
      return "${_formatDate(widget.oldestRecordDate!)} - ${_formatDate(widget.newestRecordDate!)}";
    }

    // Fallback: usar fechas basadas en la selección de tiempo (comportamiento anterior)
    final HistoricPatientsController controller = Provider.of(context, listen: false);
    final String selectedTime = controller.valueSelectedSystolic;
    final DateTime now = DateTime.now();
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
        startDate = now.subtract(const Duration(days: 30));
    }

    return "${_formatDate(startDate)} - ${_formatDate(now)}";
  }

  /// Formatea una fecha en formato "MMM dd, yyyy"
  String _formatDate(DateTime date) {
    const List<String> months = [
      'Ene', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];

    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  /// Estado de error cuando no hay datos suficientes
  Widget _buildErrorState() {
    return const SizedBox(
      height: chartHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, color: Colors.grey, size: 48),
            SizedBox(height: 8),
            Text(
              "Datos insuficientes para graficar",
              style: AppTextStyle.grey13W500ContentTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              "Se requieren al menos 5 registros para mostrar el gráfico.",
              style: AppTextStyle.grey13W500ContentTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // === MÉTODOS AUXILIARES ===

  /// Obtiene los spots animados según el progreso de la animación
  List<FlSpot> _getAnimatedSpots(List<FlSpot> originalSpots) {
    if (originalSpots.isEmpty) return originalSpots;

    final int visibleCount = (originalSpots.length * _animation.value).ceil();
    return originalSpots.take(visibleCount).toList();
  }

  /// Obtiene el rango de fechas para un punto específico del gráfico
  String _getDateRangeForPoint(int pointIndex) {
    final HistoricPatientsController controller = Provider.of(context, listen: false);

    // Usar el método del controlador que genera las etiquetas de rango de tiempo
    // El controlador ya calcula estos rangos en _generateTimeRangeLabel
    return controller.getTimeRangeForPoint(pointIndex);
  }

  /// Verifica si un valor está dentro del rango seguro
  bool _inRange(double value, double? minSafe, double maxSafe) {
    if (minSafe == null) return value <= maxSafe;
    return value >= minSafe && value <= maxSafe;
  }
}

/// Clase auxiliar para definir el rango del gráfico
class _ChartRange {
  final double minY;
  final double maxY;
  final double interval;

  const _ChartRange({
    required this.minY,
    required this.maxY,
    required this.interval,
  });
}
