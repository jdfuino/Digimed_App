import 'dart:math' as math;
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/profile_cardiovascular/profile_cardiovascular.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/state/historic_patients_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:flutter/material.dart';

class HistoricPatientsController extends StateNotifier<HistoricPatientsState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int patientId;

  HistoricPatientsController(super._state,
      {required this.accountRepository,
      required this.sessionController,
      required this.patientId});

  // ===================================
  // CONFIGURACIONES GENERALES
  // ===================================

  static const int MIN_GRAPH_POINTS_BLOOD_PRESSURE = 5;
  static const int MIN_GRAPH_POINTS_GLUCOSE = 3;

  // ===================================
  // DATOS DE PRESIÓN ARTERIAL
  // ===================================

  String valueSelectedSystolic = "6 meses";
  double promSistolica = 0;
  double promDiastolic = 0;

  // Datos para gráficas de barras
  List<BarChartGroupData> listBarDataSystolic = [];
  List<BarChartGroupData> listBarDataDiastolic = [];

  // Datos para gráficas de líneas
  List<FlSpot> systolicSpots = [];
  List<FlSpot> diastolicSpots = [];
  List<String> bloodPressureXLabels = [];
  List<String> timeRangeLabels = [];

  // Fechas del período
  DateTime? bloodPressureOldestDate;
  DateTime? bloodPressureNewestDate;

  // ===================================
  // DATOS DE FRECUENCIA CARDÍACA
  // ===================================

  String valueSelectedRate = "6 meses";
  double promRate = 0;

  List<BarChartGroupData> listBarDataRate = [];
  List<FlSpot> heartRateSpots = [];
  List<String> heartRateXLabels = [];
  List<String> heartRateTimeRangeLabels = [];

  DateTime? heartRateOldestDate;
  DateTime? heartRateNewestDate;

  // ===================================
  // DATOS DE GLUCOSA
  // ===================================

  String valueSelectedGlucose = "6 meses";
  double promGlucose = 0;

  List<BarChartGroupData> listBarDataGlucose = [];
  List<FlSpot> glucoseSpots = [];
  List<String> glucoseXLabels = [];
  List<String> glucoseTimeRangeLabels = [];

  DateTime? glucoseOldestDate;
  DateTime? glucoseNewestDate;

  // ===================================
  // DATOS DE TRIGLICÉRIDOS
  // ===================================

  String valueSelectedTriglycerides = "6 meses";
  double promTriglycerides = 0;
  List<BarChartGroupData> listBarDataTriglycerides = [];
  List<String> triglyceridesTimeRangeLabels = []; // Labels de tiempo para triglicéridos

  // ===================================
  // DATOS DE COLESTEROL
  // ===================================

  String valueSelectedCholesterol = "6 meses";
  double promCholesterol = 0;
  List<BarChartGroupData> listBarDataCholesterol = [];
  List<String> cholesterolTimeRangeLabels = []; // Labels de tiempo para colesterol

  // ===================================
  // DATOS DE HEMOGLOBINA
  // ===================================

  String valueSelectedHemoglobin = "6 meses";
  double promHemoglobin = 0;
  List<BarChartGroupData> listBarDataHemoglobin = [];
  List<String> hemoglobinTimeRangeLabels = []; // Labels de tiempo para hemoglobina

  // ===================================
  // DATOS DE ÁCIDO ÚRICO
  // ===================================

  String valueSelectedUricAcid = "6 meses";
  double promUricAcid = 0;
  List<BarChartGroupData> listBarDataUricAcid = [];

  // ===================================
  // MÉTODOS DE INICIALIZACIÓN
  // ===================================

  Future<void> init() async {
    await getDataBloodPressure();
    await getDataHeartFrequency();
    await getDataGlucose();
    await getDataTriglycerides();
    await getDataCholesterol();
    await getDataHemoglobin();
    await getDataUricAcid();
  }

  // ===================================
  // MÉTODOS DE OBTENCIÓN DE DATOS
  // ===================================

  Future<void> getDataBloodPressure({BloodPressureDataState? bloodPressureDataState}) async {
    if (bloodPressureDataState != null) {
      state = state.copyWith(bloodPressureDataState: bloodPressureDataState);
    }

    final result = await accountRepository.getDataBloodPressure(
        patientId, rangeGraph[valueSelectedSystolic]!);

    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () => sessionController.globalCloseSession(),
          orElse: () {});
      return state.copyWith(
          bloodPressureDataState: BloodPressureDataState.failed(failed));
    }, right: (list) {
      if (list != null) {
        getParamsGraphSystolic(list);
        return state.copyWith(
            bloodPressureDataState: BloodPressureDataState.loaded(list));
      }
      return state.copyWith(
          bloodPressureDataState: const BloodPressureDataState.nullData());
    });
  }

  Future<void> getDataHeartFrequency({HeartFrequencyDataState? heartFrequencyDataState}) async {
    if (heartFrequencyDataState != null) {
      state = state.copyWith(heartFrequencyDataState: heartFrequencyDataState);
    }

    final result = await accountRepository.getDataHeartFrequency(
        patientId, rangeGraph[valueSelectedRate]!);

    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () => sessionController.globalCloseSession(),
          orElse: () {});
      return state.copyWith(
          heartFrequencyDataState: HeartFrequencyDataState.failed(failed));
    }, right: (list) {
      if (list != null) {
        getParamsGraphHeartRate(list);
        return state.copyWith(
            heartFrequencyDataState: HeartFrequencyDataState.loaded(list));
      }
      return state.copyWith(
          heartFrequencyDataState: const HeartFrequencyDataState.nullData());
    });
  }

  Future<void> getDataGlucose({GlucoseDataState? glucoseDataState}) async {
    if (glucoseDataState != null) {
      state = state.copyWith(glucoseDataState: glucoseDataState);
    }

    final result = await accountRepository.getDataGlucose(
        patientId, rangeGraph[valueSelectedGlucose]!);

    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () => sessionController.globalCloseSession(),
          orElse: () {});
      return state.copyWith(glucoseDataState: GlucoseDataState.failed(failed));
    }, right: (list) {
      if (list != null) {
        getParamsGraphGlucose(list);
        return state.copyWith(glucoseDataState: GlucoseDataState.loaded(list));
      }
      return state.copyWith(glucoseDataState: const GlucoseDataState.nullData());
    });
  }

  Future<void> getDataTriglycerides({TriglyceridesDataState? triglyceridesDataState}) async {
    if (triglyceridesDataState != null) {
      state = state.copyWith(triglyceridesDataState: triglyceridesDataState);
    }

    final result = await accountRepository.getDataTriglycerides(
        patientId, rangeGraph[valueSelectedTriglycerides]!);

    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () => sessionController.globalCloseSession(),
          orElse: () {});
      return state.copyWith(
          triglyceridesDataState: TriglyceridesDataState.failed(failed));
    }, right: (list) {
      if (list != null) {
        getParamsGraphTriglycerides(list);
        return state.copyWith(
            triglyceridesDataState: TriglyceridesDataState.loaded(list));
      }
      return state.copyWith(
          triglyceridesDataState: const TriglyceridesDataState.nullData());
    });
  }

  Future<void> getDataCholesterol({CholesterolDataState? cholesterolDataState}) async {
    if (cholesterolDataState != null) {
      state = state.copyWith(cholesterolDataState: cholesterolDataState);
    }

    final result = await accountRepository.getDataCholesterol(
        patientId, rangeGraph[valueSelectedCholesterol]!);

    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () => sessionController.globalCloseSession(),
          orElse: () {});
      return state.copyWith(
          cholesterolDataState: CholesterolDataState.failed(failed));
    }, right: (list) {
      if (list != null) {
        getParamsGraphCholesterol(list);
        return state.copyWith(
            cholesterolDataState: CholesterolDataState.loaded(list));
      }
      return state.copyWith(
          cholesterolDataState: const CholesterolDataState.nullData());
    });
  }

  Future<void> getDataHemoglobin({HemoglobinDataState? hemoglobinDataState}) async {
    if (hemoglobinDataState != null) {
      state = state.copyWith(hemoglobinDataState: hemoglobinDataState);
    }

    final result = await accountRepository.getDataHemoglobin(
        patientId, rangeGraph[valueSelectedHemoglobin]!);

    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () => sessionController.globalCloseSession(),
          orElse: () {});
      return state.copyWith(
          hemoglobinDataState: HemoglobinDataState.failed(failed));
    }, right: (list) {
      if (list != null) {
        getParamsGraphHemoglobin(list);
        return state.copyWith(
            hemoglobinDataState: HemoglobinDataState.loaded(list));
      }
      return state.copyWith(
          hemoglobinDataState: const HemoglobinDataState.nullData());
    });
  }

  Future<void> getDataUricAcid({UricAcidDataState? uricAcidDataState}) async {
    if (uricAcidDataState != null) {
      state = state.copyWith(uricAcidDataState: uricAcidDataState);
    }

    final result = await accountRepository.getDataUricAcid(
        patientId, rangeGraph[valueSelectedUricAcid]!);

    state = result.when(left: (failed) {
      failed.maybeWhen(
          tokenInvalided: () => sessionController.globalCloseSession(),
          orElse: () {});
      return state.copyWith(
          uricAcidDataState: UricAcidDataState.failed(failed));
    }, right: (list) {
      if (list != null) {
        getParamsGraphUricAcid(list);
        if (listBarDataUricAcid.isEmpty) {
          return state.copyWith(
              uricAcidDataState: const UricAcidDataState.nullData());
        }
        return state.copyWith(
            uricAcidDataState: UricAcidDataState.loaded(list));
      }
      return state.copyWith(
          uricAcidDataState: const UricAcidDataState.nullData());
    });
  }

  // ===================================
  // PROCESAMIENTO DE PRESIÓN ARTERIAL
  // ===================================

  void getParamsGraphSystolic(List<ProfileCardiovascular> list) {
    _resetBloodPressureData();

    if (list.isEmpty) return;

    list.sort((a, b) => DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    bloodPressureOldestDate = DateTime.parse(list.first.createdAt);
    bloodPressureNewestDate = DateTime.parse(list.last.createdAt);

    logger.i("getParamsGraphSystolic: ${list.length} records found");

    _generateBloodPressureDataPoints(list);
    _calculateBloodPressureAverages();
  }

  void _resetBloodPressureData() {
    listBarDataSystolic = [];
    listBarDataDiastolic = [];
    systolicSpots = [];
    diastolicSpots = [];
    bloodPressureXLabels = [];
    timeRangeLabels = [];
    bloodPressureOldestDate = null;
    bloodPressureNewestDate = null;
  }

  void _generateBloodPressureDataPoints(List<ProfileCardiovascular> list) {
    if (list.length < MIN_GRAPH_POINTS_BLOOD_PRESSURE) {
      logger.i("Datos insuficientes para graficar presión arterial: ${list.length} registros. Mínimo: $MIN_GRAPH_POINTS_BLOOD_PRESSURE");
      return;
    }

    final DateTime startDate = DateTime.parse(list.first.createdAt);
    final DateTime endDate = DateTime.parse(list.last.createdAt);
    final Duration totalDuration = endDate.difference(startDate);

    int optimalPoints = _calculateOptimalPointCount(list.length, totalDuration.inDays, valueSelectedSystolic);
    List<List<ProfileCardiovascular>> dataGroups = _createDataGroups(list, optimalPoints);

    _processBloodPressureGroups(dataGroups);
  }

  void _processBloodPressureGroups(List<List<ProfileCardiovascular>> dataGroups) {
    for (int i = 0; i < dataGroups.length; i++) {
      List<ProfileCardiovascular> group = dataGroups[i];

      // Crear etiqueta de rango de tiempo
      DateTime groupStartDate = DateTime.parse(group.first.createdAt);
      DateTime groupEndDate = DateTime.parse(group.last.createdAt);
      String timeRangeLabel = _generateTimeRangeLabel(groupStartDate, groupEndDate);
      timeRangeLabels.add(timeRangeLabel);

      // Procesar valores sistólicos
      List<double> systolicValues = group
          .where((e) => e.systolicPressure != null)
          .map((e) => e.systolicPressure!)
          .toList();

      if (systolicValues.isNotEmpty) {
        double avgSystolic = systolicValues.reduce((a, b) => a + b) / systolicValues.length;
        listBarDataSystolic.add(BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: avgSystolic, width: 10, color: AppColors.backgroundColor)],
          showingTooltipIndicators: [1],
        ));
        systolicSpots.add(FlSpot(i.toDouble(), avgSystolic));
      }

      // Procesar valores diastólicos
      List<double> diastolicValues = group
          .where((e) => e.diastolicPressure != null)
          .map((e) => e.diastolicPressure!)
          .toList();

      if (diastolicValues.isNotEmpty) {
        double avgDiastolic = diastolicValues.reduce((a, b) => a + b) / diastolicValues.length;
        listBarDataDiastolic.add(BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: avgDiastolic, width: 10, color: AppColors.backgroundColor)],
          showingTooltipIndicators: [1],
        ));
        diastolicSpots.add(FlSpot(i.toDouble(), avgDiastolic));
      }

      // Etiqueta del eje X
      DateTime groupMidDate = DateTime.parse(group.first.createdAt);
      bloodPressureXLabels.add(_generateXAxisLabel(groupMidDate, i, dataGroups.length, valueSelectedSystolic));
    }
  }

  void _calculateBloodPressureAverages() {
    if (listBarDataSystolic.isNotEmpty) {
      double total = listBarDataSystolic.fold(0, (sum, barGroup) => sum + barGroup.barRods.first.toY);
      promSistolica = total / listBarDataSystolic.length;
    } else {
      promSistolica = 0;
    }

    if (listBarDataDiastolic.isNotEmpty) {
      double total = listBarDataDiastolic.fold(0, (sum, barGroup) => sum + barGroup.barRods.first.toY);
      promDiastolic = total / listBarDataDiastolic.length;
    } else {
      promDiastolic = 0;
    }
  }

  // ===================================
  // PROCESAMIENTO DE FRECUENCIA CARDÍACA
  // ===================================

  void getParamsGraphHeartRate(List<ProfileCardiovascular> list) {
    _resetHeartRateData();

    if (list.isEmpty) return;

    list.sort((a, b) => DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    heartRateOldestDate = DateTime.parse(list.first.createdAt);
    heartRateNewestDate = DateTime.parse(list.last.createdAt);

    logger.i("getParamsGraphHeartRate: ${list.length} records found");

    _generateHeartRateDataPoints(list);
    _calculateHeartRateAverage();
  }

  void _resetHeartRateData() {
    listBarDataRate = [];
    heartRateSpots = [];
    heartRateXLabels = [];
    heartRateTimeRangeLabels = [];
    heartRateOldestDate = null;
    heartRateNewestDate = null;
  }

  void _generateHeartRateDataPoints(List<ProfileCardiovascular> list) {
    if (list.length < MIN_GRAPH_POINTS_BLOOD_PRESSURE) {
      logger.i("Datos insuficientes para graficar frecuencia cardíaca: ${list.length} registros. Mínimo: $MIN_GRAPH_POINTS_BLOOD_PRESSURE");
      return;
    }

    final DateTime startDate = DateTime.parse(list.first.createdAt);
    final DateTime endDate = DateTime.parse(list.last.createdAt);
    final Duration totalDuration = endDate.difference(startDate);

    int optimalPoints = _calculateOptimalPointCount(list.length, totalDuration.inDays, valueSelectedRate);
    List<List<ProfileCardiovascular>> dataGroups = _createDataGroups(list, optimalPoints);

    _processHeartRateGroups(dataGroups);
  }

  void _processHeartRateGroups(List<List<ProfileCardiovascular>> dataGroups) {
    for (int i = 0; i < dataGroups.length; i++) {
      List<ProfileCardiovascular> group = dataGroups[i];

      // Crear etiqueta de rango de tiempo
      DateTime groupStartDate = DateTime.parse(group.first.createdAt);
      DateTime groupEndDate = DateTime.parse(group.last.createdAt);
      String timeRangeLabel = _generateTimeRangeLabel(groupStartDate, groupEndDate);
      heartRateTimeRangeLabels.add(timeRangeLabel);

      // Procesar valores de frecuencia cardíaca
      List<double> heartRateValues = group
          .where((e) => e.heartFrequency != null)
          .map((e) => e.heartFrequency!)
          .toList();

      if (heartRateValues.isNotEmpty) {
        double avgHeartRate = heartRateValues.reduce((a, b) => a + b) / heartRateValues.length;

        listBarDataRate.add(BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: avgHeartRate, width: 10, color: AppColors.backgroundColor)],
          showingTooltipIndicators: [1],
        ));
        heartRateSpots.add(FlSpot(i.toDouble(), avgHeartRate));
      }

      // Etiqueta del eje X
      DateTime groupMidDate = DateTime.parse(group.first.createdAt);
      heartRateXLabels.add(_generateXAxisLabel(groupMidDate, i, dataGroups.length, valueSelectedRate));
    }
  }

  void _calculateHeartRateAverage() {
    if (listBarDataRate.isNotEmpty) {
      double total = listBarDataRate.fold(0, (sum, barGroup) => sum + barGroup.barRods.first.toY);
      promRate = total / listBarDataRate.length;
    } else {
      promRate = 0;
    }
  }

  // ===================================
  // PROCESAMIENTO DE GLUCOSA
  // ===================================

  void getParamsGraphGlucose(List<ProfileLaboratory> list) {
    listBarDataGlucose = [];
    glucoseTimeRangeLabels = []; // Limpiar labels anteriores

    if (list.isEmpty) return;

    list.sort((a, b) =>
        DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    logger.i("getParamsGraphGlucose: ${list.length} records found");
    logger.i(list);

    // Generar datos para gráficos de barras según el rango seleccionado
    switch (rangeGraph[valueSelectedGlucose]) {
      case "WEEK":
        _generateWeeklyGlucoseData(list);
        break;
      case "MONTH":
        _generateMonthlyGlucoseData(list);
        break;
      case "HALF_YEAR":
      case "YEAR":
        _generateSixMonthsGlucoseData(list);
        break;
      default:
        _generateSixMonthsGlucoseData(list);
    }

    // Calcular promedio general
    _calculateGlucoseAverage();
  }

  void _generateWeeklyGlucoseData(List<ProfileLaboratory> list) {
    Map<int, List<double>> glucoseByDay = {};
    Map<int, List<DateTime>> datesByDay = {}; // Para almacenar las fechas por día

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int day = elementDate.day;
      glucoseByDay.putIfAbsent(day, () => []).add(element.glucose);
      datesByDay.putIfAbsent(day, () => []).add(elementDate);
    }

    int index = 0;
    List<int> sortedDays = glucoseByDay.keys.toList()..sort();

    for (int day in sortedDays) {
      double avgGlucose = glucoseByDay[day]!.reduce((a, b) => a + b) / glucoseByDay[day]!.length;

      // Generar label de fecha para este día
      List<DateTime> dayDates = datesByDay[day]!;
      dayDates.sort();
      DateTime dayDate = dayDates.first;
      String dayLabel = "${obtenerAbreviaturaMes(dayDate.month)} ${dayDate.day}";
      glucoseTimeRangeLabels.add(dayLabel);

      listBarDataGlucose.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgGlucose,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _generateMonthlyGlucoseData(List<ProfileLaboratory> list) {
    Map<int, List<double>> glucoseByWeek = {};
    Map<int, List<DateTime>> datesByWeek = {}; // Para almacenar las fechas por semana
    DateTime dateInit = DateTime.parse(list[0].createdAt).add(const Duration(days: 7));

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int weekIndex;

      if (dateInit.isAfter(elementDate)) {
        weekIndex = 0;
      } else if (dateInit.add(const Duration(days: 7)).isAfter(elementDate)) {
        weekIndex = 1;
      } else if (dateInit.add(const Duration(days: 14)).isAfter(elementDate)) {
        weekIndex = 2;
      } else {
        weekIndex = 3;
      }

      glucoseByWeek.putIfAbsent(weekIndex, () => []).add(element.glucose);
      datesByWeek.putIfAbsent(weekIndex, () => []).add(elementDate);
    }

    List<int> sortedWeeks = glucoseByWeek.keys.toList()..sort();

    for (int week in sortedWeeks) {
      double avgGlucose = glucoseByWeek[week]!.reduce((a, b) => a + b) / glucoseByWeek[week]!.length;

      // Generar label de fecha para esta semana
      List<DateTime> weekDates = datesByWeek[week]!;
      weekDates.sort();
      DateTime startDate = weekDates.first;
      DateTime endDate = weekDates.last;

      String weekLabel;
      if (startDate.day == endDate.day && startDate.month == endDate.month) {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day}";
      } else if (startDate.month == endDate.month) {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day} - ${endDate.day}";
      } else {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day} - ${obtenerAbreviaturaMes(endDate.month)} ${endDate.day}";
      }
      glucoseTimeRangeLabels.add(weekLabel);

      listBarDataGlucose.add(
        BarChartGroupData(
          x: week,
          barRods: [
            BarChartRodData(
              toY: avgGlucose,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
    }
  }

  void _generateSixMonthsGlucoseData(List<ProfileLaboratory> list) {
    Map<int, List<double>> glucoseByMonth = {};
    Map<int, List<DateTime>> datesByMonth = {}; // Para almacenar las fechas por mes

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int month = elementDate.month;
      glucoseByMonth.putIfAbsent(month, () => []).add(element.glucose);
      datesByMonth.putIfAbsent(month, () => []).add(elementDate);
    }

    int index = 0;
    List<int> sortedMonths = glucoseByMonth.keys.toList()..sort();

    for (int month in sortedMonths) {
      double avgGlucose = glucoseByMonth[month]!.reduce((a, b) => a + b) / glucoseByMonth[month]!.length;

      // Generar label de fecha para este mes
      List<DateTime> monthDates = datesByMonth[month]!;
      monthDates.sort();
      DateTime startDate = monthDates.first;
      DateTime endDate = monthDates.last;

      String monthLabel;
      if (startDate.day == endDate.day) {
        // Un solo día en el mes
        monthLabel = "${obtenerAbreviaturaMes(month)} ${startDate.day}";
      } else {
        // Rango de días en el mes
        monthLabel = "${obtenerAbreviaturaMes(month)} ${startDate.day} - ${endDate.day}";
      }
      glucoseTimeRangeLabels.add(monthLabel);

      listBarDataGlucose.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgGlucose,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _calculateGlucoseAverage() {
    if (listBarDataGlucose.isNotEmpty) {
      double total = 0;
      for (var barGroup in listBarDataGlucose) {
        total += barGroup.barRods.first.toY;
      }
      promGlucose = total / listBarDataGlucose.length;
    } else {
      promGlucose = 0;
    }
  }

  // ===================================
  // PROCESAMIENTO DE TRIGLICÉRIDOS
  // ===================================

  void getParamsGraphTriglycerides(List<ProfileLaboratory> list) {
    listBarDataTriglycerides = [];
    triglyceridesTimeRangeLabels = []; // Limpiar labels anteriores

    if (list.isEmpty) return;

    list.sort((a, b) =>
        DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    // Generar datos para gráficos de barras según el rango seleccionado
    switch (rangeGraph[valueSelectedTriglycerides]) {
      case "WEEK":
        _generateWeeklyTriglyceridesData(list);
        break;
      case "MONTH":
        _generateMonthlyTriglyceridesData(list);
        break;
      case "HALF_YEAR":
      case "YEAR":
        _generateSixMonthsTriglyceridesData(list);
        break;
      default:
        _generateSixMonthsTriglyceridesData(list);
    }

    // Calcular promedio general
    _calculateTriglyceridesAverage();
  }

  void _generateWeeklyTriglyceridesData(List<ProfileLaboratory> list) {
    Map<int, List<double>> triglyceridesByDay = {};
    Map<int, List<DateTime>> datesByDay = {}; // Para almacenar las fechas por día

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int day = elementDate.day;
      triglyceridesByDay.putIfAbsent(day, () => []).add(element.triglycerides);
      datesByDay.putIfAbsent(day, () => []).add(elementDate);
    }

    int index = 0;
    List<int> sortedDays = triglyceridesByDay.keys.toList()..sort();

    for (int day in sortedDays) {
      double avgTriglycerides = triglyceridesByDay[day]!.reduce((a, b) => a + b) / triglyceridesByDay[day]!.length;

      // Generar label de fecha para este día
      List<DateTime> dayDates = datesByDay[day]!;
      dayDates.sort();
      DateTime dayDate = dayDates.first;
      String dayLabel = "${obtenerAbreviaturaMes(dayDate.month)} ${dayDate.day}";
      triglyceridesTimeRangeLabels.add(dayLabel);

      listBarDataTriglycerides.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgTriglycerides,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _generateMonthlyTriglyceridesData(List<ProfileLaboratory> list) {
    Map<int, List<double>> triglyceridesByWeek = {};
    Map<int, List<DateTime>> datesByWeek = {}; // Para almacenar las fechas por semana
    DateTime dateInit = DateTime.parse(list[0].createdAt).add(const Duration(days: 7));

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int weekIndex;

      if (dateInit.isAfter(elementDate)) {
        weekIndex = 0;
      } else if (dateInit.add(const Duration(days: 7)).isAfter(elementDate)) {
        weekIndex = 1;
      } else if (dateInit.add(const Duration(days: 14)).isAfter(elementDate)) {
        weekIndex = 2;
      } else {
        weekIndex = 3;
      }

      triglyceridesByWeek.putIfAbsent(weekIndex, () => []).add(element.triglycerides);
      datesByWeek.putIfAbsent(weekIndex, () => []).add(elementDate);
    }

    List<int> sortedWeeks = triglyceridesByWeek.keys.toList()..sort();

    for (int week in sortedWeeks) {
      double avgTriglycerides = triglyceridesByWeek[week]!.reduce((a, b) => a + b) / triglyceridesByWeek[week]!.length;

      // Generar label de fecha para esta semana
      List<DateTime> weekDates = datesByWeek[week]!;
      weekDates.sort();
      DateTime startDate = weekDates.first;
      DateTime endDate = weekDates.last;

      String weekLabel;
      if (startDate.day == endDate.day && startDate.month == endDate.month) {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day}";
      } else if (startDate.month == endDate.month) {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day} - ${endDate.day}";
      } else {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day} - ${obtenerAbreviaturaMes(endDate.month)} ${endDate.day}";
      }
      triglyceridesTimeRangeLabels.add(weekLabel);

      listBarDataTriglycerides.add(
        BarChartGroupData(
          x: week,
          barRods: [
            BarChartRodData(
              toY: avgTriglycerides,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
    }
  }

  void _generateSixMonthsTriglyceridesData(List<ProfileLaboratory> list) {
    Map<int, List<double>> triglyceridesByMonth = {};
    Map<int, List<DateTime>> datesByMonth = {}; // Para almacenar las fechas por mes

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int month = elementDate.month;
      triglyceridesByMonth.putIfAbsent(month, () => []).add(element.triglycerides);
      datesByMonth.putIfAbsent(month, () => []).add(elementDate);
    }

    int index = 0;
    List<int> sortedMonths = triglyceridesByMonth.keys.toList()..sort();

    for (int month in sortedMonths) {
      double avgTriglycerides = triglyceridesByMonth[month]!.reduce((a, b) => a + b) / triglyceridesByMonth[month]!.length;

      // Generar label de fecha para este mes
      List<DateTime> monthDates = datesByMonth[month]!;
      monthDates.sort();
      DateTime startDate = monthDates.first;
      DateTime endDate = monthDates.last;

      String monthLabel;
      if (startDate.day == endDate.day) {
        // Un solo día en el mes
        monthLabel = "${obtenerAbreviaturaMes(month)} ${startDate.day}";
      } else {
        // Rango de días en el mes
        monthLabel = "${obtenerAbreviaturaMes(month)} ${startDate.day} - ${endDate.day}";
      }
      triglyceridesTimeRangeLabels.add(monthLabel);

      listBarDataTriglycerides.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgTriglycerides,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _calculateTriglyceridesAverage() {
    if (listBarDataTriglycerides.isNotEmpty) {
      double total = 0;
      for (var barGroup in listBarDataTriglycerides) {
        total += barGroup.barRods.first.toY;
      }
      promTriglycerides = total / listBarDataTriglycerides.length;
    } else {
      promTriglycerides = 0;
    }
  }

  // ===================================
  // PROCESAMIENTO DE COLESTEROL
  // ===================================

  void getParamsGraphCholesterol(List<ProfileLaboratory> list) {
    listBarDataCholesterol = [];
    cholesterolTimeRangeLabels = []; // Limpiar labels anteriores

    if (list.isEmpty) return;

    list.sort((a, b) =>
        DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    // Generar datos para gráficos de barras según el rango seleccionado
    switch (rangeGraph[valueSelectedCholesterol]) {
      case "WEEK":
        _generateWeeklyCholesterolData(list);
        break;
      case "MONTH":
        _generateMonthlyCholesterolData(list);
        break;
      case "HALF_YEAR":
      case "YEAR":
        _generateSixMonthsCholesterolData(list);
        break;
      default:
        _generateSixMonthsCholesterolData(list);
    }

    // Calcular promedio general
    _calculateCholesterolAverage();
  }

  void _generateWeeklyCholesterolData(List<ProfileLaboratory> list) {
    Map<int, List<double>> cholesterolByDay = {};
    Map<int, List<DateTime>> datesByDay = {}; // Para almacenar las fechas por día

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int day = elementDate.day;
      cholesterolByDay.putIfAbsent(day, () => []).add(element.cholesterol);
      datesByDay.putIfAbsent(day, () => []).add(elementDate);
    }

    int index = 0;
    List<int> sortedDays = cholesterolByDay.keys.toList()..sort();

    for (int day in sortedDays) {
      double avgCholesterol = cholesterolByDay[day]!.reduce((a, b) => a + b) / cholesterolByDay[day]!.length;

      // Generar label de fecha para este día
      List<DateTime> dayDates = datesByDay[day]!;
      dayDates.sort();
      DateTime dayDate = dayDates.first;
      String dayLabel = "${obtenerAbreviaturaMes(dayDate.month)} ${dayDate.day}";
      cholesterolTimeRangeLabels.add(dayLabel);

      listBarDataCholesterol.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgCholesterol,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _generateMonthlyCholesterolData(List<ProfileLaboratory> list) {
    Map<int, List<double>> cholesterolByWeek = {};
    Map<int, List<DateTime>> datesByWeek = {}; // Para almacenar las fechas por semana
    DateTime dateInit = DateTime.parse(list[0].createdAt).add(const Duration(days: 7));

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int weekIndex;

      if (dateInit.isAfter(elementDate)) {
        weekIndex = 0;
      } else if (dateInit.add(const Duration(days: 7)).isAfter(elementDate)) {
        weekIndex = 1;
      } else if (dateInit.add(const Duration(days: 14)).isAfter(elementDate)) {
        weekIndex = 2;
      } else {
        weekIndex = 3;
      }

      cholesterolByWeek.putIfAbsent(weekIndex, () => []).add(element.cholesterol);
      datesByWeek.putIfAbsent(weekIndex, () => []).add(elementDate);
    }

    List<int> sortedWeeks = cholesterolByWeek.keys.toList()..sort();

    for (int week in sortedWeeks) {
      double avgCholesterol = cholesterolByWeek[week]!.reduce((a, b) => a + b) / cholesterolByWeek[week]!.length;

      // Generar label de fecha para esta semana
      List<DateTime> weekDates = datesByWeek[week]!;
      weekDates.sort();
      DateTime startDate = weekDates.first;
      DateTime endDate = weekDates.last;

      String weekLabel;
      if (startDate.day == endDate.day && startDate.month == endDate.month) {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day}";
      } else if (startDate.month == endDate.month) {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day} - ${endDate.day}";
      } else {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day} - ${obtenerAbreviaturaMes(endDate.month)} ${endDate.day}";
      }
      cholesterolTimeRangeLabels.add(weekLabel);

      listBarDataCholesterol.add(
        BarChartGroupData(
          x: week,
          barRods: [
            BarChartRodData(
              toY: avgCholesterol,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
    }
  }

  void _generateSixMonthsCholesterolData(List<ProfileLaboratory> list) {
    Map<int, List<double>> cholesterolByMonth = {};
    Map<int, List<DateTime>> datesByMonth = {}; // Para almacenar las fechas por mes

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int month = elementDate.month;
      cholesterolByMonth.putIfAbsent(month, () => []).add(element.cholesterol);
      datesByMonth.putIfAbsent(month, () => []).add(elementDate);
    }

    int index = 0;
    List<int> sortedMonths = cholesterolByMonth.keys.toList()..sort();

    for (int month in sortedMonths) {
      double avgCholesterol = cholesterolByMonth[month]!.reduce((a, b) => a + b) / cholesterolByMonth[month]!.length;

      // Generar label de fecha para este mes
      List<DateTime> monthDates = datesByMonth[month]!;
      monthDates.sort();
      DateTime startDate = monthDates.first;
      DateTime endDate = monthDates.last;

      String monthLabel;
      if (startDate.day == endDate.day) {
        // Un solo día en el mes
        monthLabel = "${obtenerAbreviaturaMes(month)} ${startDate.day}";
      } else {
        // Rango de días en el mes
        monthLabel = "${obtenerAbreviaturaMes(month)} ${startDate.day} - ${endDate.day}";
      }
      cholesterolTimeRangeLabels.add(monthLabel);

      listBarDataCholesterol.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgCholesterol,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _calculateCholesterolAverage() {
    if (listBarDataCholesterol.isNotEmpty) {
      double total = 0;
      for (var barGroup in listBarDataCholesterol) {
        total += barGroup.barRods.first.toY;
      }
      promCholesterol = total / listBarDataCholesterol.length;
    } else {
      promCholesterol = 0;
    }
  }

  // ===================================
  // PROCESAMIENTO DE HEMOGLOBINA
  // ===================================

  void getParamsGraphHemoglobin(List<ProfileLaboratory> list) {
    listBarDataHemoglobin = [];
    hemoglobinTimeRangeLabels = []; // Limpiar labels anteriores

    if (list.isEmpty) return;

    list.sort((a, b) =>
        DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    logger.i("Hemoglobin: ${list.length} records found");
    for (var element in list) {
      logger.i(
          "Hemoglobin: ${element.hemoglobin}, Date: ${element.createdAt}");
    }

    // Generar datos para gráficos de barras según el rango seleccionado
    switch (rangeGraph[valueSelectedHemoglobin]) {
      case "WEEK":
        _generateWeeklyHemoglobinData(list);
        break;
      case "MONTH":
        _generateMonthlyHemoglobinData(list);
        break;
      case "HALF_YEAR":
      case "YEAR":
        _generateSixMonthsHemoglobinData(list);
        break;
      default:
        _generateSixMonthsHemoglobinData(list);
    }

    // Calcular promedio general
    _calculateHemoglobinAverage();
  }

  void _generateWeeklyHemoglobinData(List<ProfileLaboratory> list) {
    Map<int, List<double>> hemoglobinByDay = {};
    Map<int, List<DateTime>> datesByDay = {}; // Para almacenar las fechas por día

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int day = elementDate.day;
      hemoglobinByDay.putIfAbsent(day, () => []).add(element.hemoglobin);
      datesByDay.putIfAbsent(day, () => []).add(elementDate);
    }

    int index = 0;
    List<int> sortedDays = hemoglobinByDay.keys.toList()..sort();

    for (int day in sortedDays) {
      double avgHemoglobin = hemoglobinByDay[day]!.reduce((a, b) => a + b) /
          hemoglobinByDay[day]!.length;

      // Generar label de fecha para este día
      List<DateTime> dayDates = datesByDay[day]!;
      dayDates.sort();
      DateTime dayDate = dayDates.first;
      String dayLabel = "${obtenerAbreviaturaMes(dayDate.month)} ${dayDate.day}";
      hemoglobinTimeRangeLabels.add(dayLabel);

      listBarDataHemoglobin.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgHemoglobin,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _generateMonthlyHemoglobinData(List<ProfileLaboratory> list) {
    Map<int, List<double>> hemoglobinByWeek = {};
    Map<int, List<DateTime>> datesByWeek = {}; // Para almacenar las fechas por semana
    DateTime dateInit = DateTime.parse(list[0].createdAt).add(
        const Duration(days: 7));

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int weekIndex;

      if (dateInit.isAfter(elementDate)) {
        weekIndex = 0;
      } else if (dateInit.add(const Duration(days: 7)).isAfter(elementDate)) {
        weekIndex = 1;
      } else if (dateInit.add(const Duration(days: 14)).isAfter(elementDate)) {
        weekIndex = 2;
      } else {
        weekIndex = 3;
      }

      hemoglobinByWeek.putIfAbsent(weekIndex, () => []).add(element.hemoglobin);
      datesByWeek.putIfAbsent(weekIndex, () => []).add(elementDate);
    }

    List<int> sortedWeeks = hemoglobinByWeek.keys.toList()
      ..sort();

    for (int week in sortedWeeks) {
      double avgHemoglobin = hemoglobinByWeek[week]!.reduce((a, b) => a + b) /
          hemoglobinByWeek[week]!.length;
      listBarDataHemoglobin.add(
        BarChartGroupData(
          x: week,
          barRods: [
            BarChartRodData(
              toY: avgHemoglobin,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );

      // Generar label de fecha para esta semana
      List<DateTime> weekDates = datesByWeek[week]!;
      weekDates.sort();
      DateTime startDate = weekDates.first;
      DateTime endDate = weekDates.last;

      String weekLabel;
      if (startDate.day == endDate.day && startDate.month == endDate.month) {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day}";
      } else if (startDate.month == endDate.month) {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day} - ${endDate.day}";
      } else {
        weekLabel = "${obtenerAbreviaturaMes(startDate.month)} ${startDate.day} - ${obtenerAbreviaturaMes(endDate.month)} ${endDate.day}";
      }
      hemoglobinTimeRangeLabels.add(weekLabel);
    }
  }

  void _generateSixMonthsHemoglobinData(List<ProfileLaboratory> list) {
    Map<int, List<double>> hemoglobinByMonth = {};
    Map<int, List<DateTime>> datesByMonth = {}; // Para almacenar las fechas por mes

    for (var element in list) {
      DateTime elementDate = DateTime.parse(element.createdAt);
      int month = elementDate.month;
      hemoglobinByMonth.putIfAbsent(month, () => []).add(element.hemoglobin);
      datesByMonth.putIfAbsent(month, () => []).add(elementDate);
    }

    int index = 0;
    List<int> sortedMonths = hemoglobinByMonth.keys.toList()..sort();

    for (int month in sortedMonths) {
      double avgHemoglobin = hemoglobinByMonth[month]!.reduce((a, b) => a + b) /
          hemoglobinByMonth[month]!.length;
      listBarDataHemoglobin.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgHemoglobin,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );

      // Generar label de fecha para este mes
      List<DateTime> monthDates = datesByMonth[month]!;
      monthDates.sort();
      DateTime startDate = monthDates.first;
      DateTime endDate = monthDates.last;

      String monthLabel;
      if (startDate.day == endDate.day) {
        // Un solo día en el mes
        monthLabel = "${obtenerAbreviaturaMes(month)} ${startDate.day}";
      } else {
        // Rango de días en el mes
        monthLabel = "${obtenerAbreviaturaMes(month)} ${startDate.day} - ${endDate.day}";
      }
      hemoglobinTimeRangeLabels.add(monthLabel);
      index++;
    }
  }

  void _calculateHemoglobinAverage() {
    if (listBarDataHemoglobin.isNotEmpty) {
      double total = 0;
      for (var barGroup in listBarDataHemoglobin) {
        total += barGroup.barRods.first.toY;
      }
      promHemoglobin = total / listBarDataHemoglobin.length;
    } else {
      promHemoglobin = 0;
    }
  }

  // ===================================
  // PROCESAMIENTO DE ÁCIDO ÚRICO
  // ===================================

  void getParamsGraphUricAcid(List<ProfileLaboratory> list) {
    listBarDataUricAcid = [];

    if (list.isEmpty) return;

    list.sort((a, b) =>
        DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    // Generar datos para gráficos de barras según el rango seleccionado
    switch (rangeGraph[valueSelectedUricAcid]) {
      case "WEEK":
        _generateWeeklyUricAcidData(list);
        break;
      case "MONTH":
        _generateMonthlyUricAcidData(list);
        break;
      case "HALF_YEAR":
      case "YEAR":
        _generateSixMonthsUricAcidData(list);
        break;
      default:
        _generateSixMonthsUricAcidData(list);
    }

    // Calcular promedio general
    _calculateUricAcidAverage();
  }

  void _generateWeeklyUricAcidData(List<ProfileLaboratory> list) {
    Map<int, List<double>> uricAcidByDay = {};

    for (var element in list) {
      if (element.uricAcid != null) {
        int day = DateTime
            .parse(element.createdAt)
            .day;
        uricAcidByDay.putIfAbsent(day, () => []).add(element.uricAcid!);
      }
    }

    int index = 0;
    List<int> sortedDays = uricAcidByDay.keys.toList()
      ..sort();

    for (int day in sortedDays) {
      double avgUricAcid = uricAcidByDay[day]!.reduce((a, b) => a + b) /
          uricAcidByDay[day]!.length;
      listBarDataUricAcid.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgUricAcid,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _generateMonthlyUricAcidData(List<ProfileLaboratory> list) {
    Map<int, List<double>> uricAcidByWeek = {};
    DateTime dateInit = DateTime.parse(list[0].createdAt).add(
        const Duration(days: 7));

    for (var element in list) {
      if (element.uricAcid != null) {
        DateTime elementDate = DateTime.parse(element.createdAt);
        int weekIndex;

        if (dateInit.isAfter(elementDate)) {
          weekIndex = 0;
        } else if (dateInit.add(const Duration(days: 7)).isAfter(elementDate)) {
          weekIndex = 1;
        } else
        if (dateInit.add(const Duration(days: 14)).isAfter(elementDate)) {
          weekIndex = 2;
        } else {
          weekIndex = 3;
        }

        uricAcidByWeek.putIfAbsent(weekIndex, () => []).add(element.uricAcid!);
      }
    }

    List<int> sortedWeeks = uricAcidByWeek.keys.toList()
      ..sort();

    for (int week in sortedWeeks) {
      double avgUricAcid = uricAcidByWeek[week]!.reduce((a, b) => a + b) /
          uricAcidByWeek[week]!.length;
      listBarDataUricAcid.add(
        BarChartGroupData(
          x: week,
          barRods: [
            BarChartRodData(
              toY: avgUricAcid,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
    }
  }

  void _generateSixMonthsUricAcidData(List<ProfileLaboratory> list) {
    Map<int, List<double>> uricAcidByMonth = {};

    for (var element in list) {
      if (element.uricAcid != null) {
        int month = DateTime
            .parse(element.createdAt)
            .month;
        uricAcidByMonth.putIfAbsent(month, () => []).add(element.uricAcid!);
      }
    }

    int index = 0;
    List<int> sortedMonths = uricAcidByMonth.keys.toList()
      ..sort();

    for (int month in sortedMonths) {
      double avgUricAcid = uricAcidByMonth[month]!.reduce((a, b) => a + b) /
          uricAcidByMonth[month]!.length;
      listBarDataUricAcid.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: avgUricAcid,
              width: 10,
              color: AppColors.backgroundColor,
            )
          ],
          showingTooltipIndicators: [1],
        ),
      );
      index++;
    }
  }

  void _calculateUricAcidAverage() {
    if (listBarDataUricAcid.isNotEmpty) {
      double total = 0;
      for (var barGroup in listBarDataUricAcid) {
        total += barGroup.barRods.first.toY;
      }
      promUricAcid = total / listBarDataUricAcid.length;
    } else {
      promUricAcid = 0;
    }
  }

  // ===================================
  // MÉTODOS AUXILIARES COMUNES
  // ===================================

  List<List<ProfileCardiovascular>> _createDataGroups(List<ProfileCardiovascular> list, int optimalPoints) {
    List<List<ProfileCardiovascular>> dataGroups = [];
    int groupSize = (list.length / optimalPoints).ceil();

    for (int i = 0; i < optimalPoints; i++) {
      int startIndex = i * groupSize;
      int endIndex = math.min(startIndex + groupSize, list.length);

      if (startIndex < list.length) {
        List<ProfileCardiovascular> group = list.sublist(startIndex, endIndex);
        if (group.isNotEmpty) {
          dataGroups.add(group);
        }
      }
    }

    return dataGroups;
  }

  String _generateTimeRangeLabel(DateTime startDate, DateTime endDate) {
    String formatDate(DateTime date) {
      List<String> months = [
        '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ];
      return "${months[date.month]} ${date.day}";
    }

    if (startDate.day == endDate.day &&
        startDate.month == endDate.month &&
        startDate.year == endDate.year) {
      return formatDate(startDate);
    } else if (startDate.month == endDate.month && startDate.year == endDate.year) {
      return "${formatDate(startDate)} - ${endDate.day}";
    } else {
      return "${formatDate(startDate)} - ${formatDate(endDate)}";
    }
  }

  String _generateXAxisLabel(DateTime intervalDate, int index, int totalPoints, String selectedRange) {
    switch (rangeGraph[selectedRange]) {
      case "WEEK":
        return "${intervalDate.day}/${intervalDate.month}";
      case "MONTH":
        return "Sem ${index + 1}";
      case "HALF_YEAR":
        return obtenerAbreviaturaMes(intervalDate.month);
      case "YEAR":
        return obtenerAbreviaturaMes(intervalDate.month);
      default:
        return "${intervalDate.day}/${intervalDate.month}";
    }
  }

  int _calculateOptimalPointCount(int dataCount, int durationInDays, String selectedRange) {
    if (dataCount <= 5) return 5;
    if (dataCount <= 10) return math.min(dataCount, 7);

    switch (rangeGraph[selectedRange]) {
      case "WEEK":
        return math.min(7, math.max(5, durationInDays));
      case "MONTH":
        return 8;
      case "HALF_YEAR":
        return 6;
      case "YEAR":
        return 10;
      default:
        return 7;
    }
  }


  // ===================================
  // MÉTODOS PÚBLICOS PARA ACCESO A RANGOS
  // ===================================

  String getTimeRangeForPoint(int pointIndex) {
    if (pointIndex >= 0 && pointIndex < timeRangeLabels.length) {
      return timeRangeLabels[pointIndex];
    }
    return "Rango no disponible";
  }

  String getHeartRateTimeRangeForPoint(int pointIndex) {
    if (pointIndex >= 0 && pointIndex < heartRateTimeRangeLabels.length) {
      return heartRateTimeRangeLabels[pointIndex];
    }
    return "Rango ${pointIndex + 1}";
  }

  String getGlucoseTimeRangeForPoint(int pointIndex) {
    if (pointIndex >= 0 && pointIndex < glucoseTimeRangeLabels.length) {
      return glucoseTimeRangeLabels[pointIndex];
    }
    return "Rango no disponible";
  }

  String getTriglyceridesTimeRangeForPoint(int pointIndex) {
    if (pointIndex >= 0 && pointIndex < triglyceridesTimeRangeLabels.length) {
      return triglyceridesTimeRangeLabels[pointIndex];
    }
    return "Rango no disponible";
  }

  String getCholesterolTimeRangeForPoint(int pointIndex) {
    if (pointIndex >= 0 && pointIndex < cholesterolTimeRangeLabels.length) {
      return cholesterolTimeRangeLabels[pointIndex];
    }
    return "Rango no disponible";
  }

  String getHemoglobinTimeRangeForPoint(int pointIndex) {
    if (pointIndex >= 0 && pointIndex < hemoglobinTimeRangeLabels.length) {
      return hemoglobinTimeRangeLabels[pointIndex];
    }
    return "Rango no disponible";
  }

}
