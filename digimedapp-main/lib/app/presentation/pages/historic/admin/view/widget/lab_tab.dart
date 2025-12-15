import 'package:digimed/app/domain/constants/value_range.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/glucose_info_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/triglycerides_info_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/cholesterol_info_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/hemoglobin_info_dialog.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/state/historic_patients_state.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/graph_cholesterol.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/graph_glucose.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/graph_hemoglobin.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/graph_triglycerides.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LabTab extends StatelessWidget {
  const LabTab({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoricPatientsController controller = Provider.of(context);
    final Size size = MediaQuery
        .of(context)
        .size;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 16),
        child: Column(
          children: [
            GraphGlucose(
              title: "Glucemia",
              valueProm: controller.promGlucose,
              maxSafeZone: ValueRange.glucoseMax,
              minSafeZone: ValueRange.glucoseMin,
              unit: "mg/dl",
              maxValue: 300,
              dataBarGroups: controller.listBarDataGlucose,
              onInfoPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const GlucoseInfoDialog(),
                );
              },
              buildStatusMessage: () {
                return controller.state.glucoseDataState.when(
                    loading: () => const SizedBox.shrink(),
                    failed: (failed) => const SizedBox.shrink(),
                    nullData: () => const SizedBox.shrink(),
                    loaded: (_) => getGlucoseMessageWidget(
                      controller.promGlucose,
                      ValueRange.glucoseMin,
                      ValueRange.glucoseMax,
                      isPatientView: false, // Vista del médico
                    ));
              },
              onTimeSelected: (value) {
                controller.valueSelectedGlucose = value;
                controller.getDataGlucose(
                    glucoseDataState:
                    const GlucoseDataState.loading());
              },
            ),
            const SizedBox(
              height: 16,
            ),
            GraphTriglycerides(
              title: "Triglicéridos",
              valueProm: controller.promTriglycerides,
              maxSafeZone: ValueRange.triglyceridesMax,
              unit: "mg/dl",
              maxValue: 500,
              dataBarGroups: controller.listBarDataTriglycerides,
              onInfoPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const TriglyceridesInfoDialog(),
                );
              },
              buildStatusMessage: () {
                return controller.state.triglyceridesDataState.when(
                    loading: () => const SizedBox.shrink(),
                    failed: (failed) => const SizedBox.shrink(),
                    nullData: () => const SizedBox.shrink(),
                    loaded: (_) => getTriglyceridesMessageWidget(
                      controller.promTriglycerides,
                      ValueRange.triglyceridesMax,
                      isPatientView: false, // Vista del médico
                    ));
              },
              onTimeSelected: (value) {
                controller.valueSelectedTriglycerides = value;
                controller.getDataTriglycerides(
                    triglyceridesDataState:
                    const TriglyceridesDataState.loading());
              },
            ),
            const SizedBox(
              height: 16,
            ),
            GraphCholesterol(
              title: "Colesterol No-HDL",
              valueProm: controller.promCholesterol,
              maxSafeZone: ValueRange.cholesterolMax,
              unit: "mg/dl",
              maxValue: 300,
              dataBarGroups: controller.listBarDataCholesterol,
              onInfoPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CholesterolInfoDialog(),
                );
              },
              buildStatusMessage: () {
                return controller.state.cholesterolDataState.when(
                    loading: () => const SizedBox.shrink(),
                    failed: (failed) => const SizedBox.shrink(),
                    nullData: () => const SizedBox.shrink(),
                    loaded: (_) => getCholesterolMessageWidget(
                      controller.promCholesterol,
                      ValueRange.cholesterolMax,
                      isPatientView: false, // Vista del médico
                    ));
              },
              onTimeSelected: (value) {
                controller.valueSelectedCholesterol = value;
                controller.getDataCholesterol(
                    cholesterolDataState:
                    const CholesterolDataState.loading());
              },
            ),
            const SizedBox(
              height: 16,
            ),
            GraphHemoglobin(
              title: "Hemoglobina",
              valueProm: controller.promHemoglobin,
              maxSafeZone: ValueRange.hemoglobinMaleMax, // Se puede ajustar según el género del paciente
              minSafeZone: ValueRange.hemoglobinMaleMin, // Se puede ajustar según el género del paciente
              unit: "g/dL",
              maxValue: 20,
              dataBarGroups: controller.listBarDataHemoglobin,
              onInfoPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const HemoglobinInfoDialog(),
                );
              },
              buildStatusMessage: () {
                return controller.state.hemoglobinDataState.when(
                    loading: () => const SizedBox.shrink(),
                    failed: (failed) => const SizedBox.shrink(),
                    nullData: () => const SizedBox.shrink(),
                    loaded: (_) => getHemoglobinMessageWidget(
                      controller.promHemoglobin,
                      ValueRange.hemoglobinMaleMin, // Se puede ajustar según el género del paciente
                      ValueRange.hemoglobinMaleMax, // Se puede ajustar según el género del paciente
                      isPatientView: false, // Vista del médico
                    ));
              },
              onTimeSelected: (value) {
                controller.valueSelectedHemoglobin = value;
                controller.getDataHemoglobin(
                    hemoglobinDataState:
                    const HemoglobinDataState.loading());
              },
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
