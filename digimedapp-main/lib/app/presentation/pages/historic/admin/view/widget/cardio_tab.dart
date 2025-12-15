import 'package:digimed/app/domain/constants/value_range.dart';
import 'package:digimed/app/presentation/global/widgets/blood_pressure_info_dialog.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/state/historic_patients_state.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/chart_card.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabCardio extends StatelessWidget {
  const TabCardio({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoricPatientsController controller = Provider.of(context);
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 24, left: 24, bottom: 16),
        child: Column(
          children: [
            // Chart blood pressure
            ChartCard(
              title: "Presión Arterial",
              valueProm: controller.promSistolica,
              valueDiastolicProm: controller.promDiastolic,
              maxSafeZone: ValueRange.systolicMax,
              minSafeZone: ValueRange.systolicMin,
              maxSafeZone2: ValueRange.diastolicMax,
              minSafeZone2: ValueRange.diastolicMin,
              maxValue: 200,
              unit: "mmHg",
              systolicSpots: controller.systolicSpots,
              diastolicSpots: controller.diastolicSpots,
              xLabels: controller.bloodPressureXLabels,
              // Pasar las fechas reales de los registros
              oldestRecordDate: controller.bloodPressureOldestDate,
              newestRecordDate: controller.bloodPressureNewestDate,
              onInfoPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const BloodPressureInfoDialog();
                  },
                );
              },
              buildStatusMessage: () {
                return controller.state.bloodPressureDataState.when(
                    loading: () => const SizedBox.shrink(),
                    failed: (failed) => const SizedBox.shrink(),
                    nullData: () => const SizedBox.shrink(),
                    loaded: (_) => getBloodPressureMessageWidget(
                      controller.promSistolica,
                      controller.promDiastolic,
                      isPatientView: false, // Cambia a true si es vista del paciente
                    ));
              },
              onTimeSelected: (String value) {
                controller.valueSelectedSystolic = value;
                controller.getDataBloodPressure(
                    bloodPressureDataState:
                    const BloodPressureDataState.loading());
              },
            ),
          ],
        ),
      ),
    );
  }
}
