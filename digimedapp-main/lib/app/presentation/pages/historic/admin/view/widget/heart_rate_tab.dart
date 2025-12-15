import 'package:digimed/app/domain/constants/value_range.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/heart_rate_info_dialog.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/state/historic_patients_state.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/chart_card.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/graph_heart_rate.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeartRateTab extends StatelessWidget {
  const HeartRateTab({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoricPatientsController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 16),
        width: double.infinity,
        child: Column(
          children: [
            GraphHeartRate(
              title: "Frecuencia Cardiaca",
              valueProm: controller.promRate,
              maxSafeZone: ValueRange.heartRateMax,
              minSafeZone: ValueRange.heartRateMin,
              unit: "ppm",
              maxValue: 250,
              // Nuevos parámetros para gráfico de líneas
              heartRateSpots: controller.heartRateSpots,
              xLabels: controller.heartRateXLabels,
              // Pasar las fechas reales de los registros
              oldestRecordDate: controller.heartRateOldestDate,
              newestRecordDate: controller.heartRateNewestDate,
              onInfoPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => HeartRateInfoDialog(),
                );
              },
              buildStatusMessage: () {
                return controller.state.heartFrequencyDataState.when(
                    loading: () => const SizedBox.shrink(),
                    failed: (failed) => const SizedBox.shrink(),
                    nullData: () => const SizedBox.shrink(),
                    loaded: (_) => getHeartRateMessageWidget(
                      controller.promRate,
                      isPatientView: false, // Cambia a true si es vista del paciente
                    ));
              },
              onTimeSelected: (value) {
                controller.valueSelectedRate = value;
                controller.getDataHeartFrequency(
                    heartFrequencyDataState:
                    const HeartFrequencyDataState.loading());
              },
            )
          ],
        ),
      ),
    );
  }
}
