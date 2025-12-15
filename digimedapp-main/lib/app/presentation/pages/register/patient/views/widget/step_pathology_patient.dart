import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepPathologyPatient extends StatelessWidget {
  const StepPathologyPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 2,
            lastStep: 10,
            onTab: () async {
              controller.step = 1;
              await controller.changeState();
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Antecedentes Personales",
            style: AppTextStyle.normal17ContentTextStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          CardDigimed(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 16, top: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          "Cardiovasculares",
                          style: AppTextStyle.normal16W500ContentTextStyle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyCardio(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasCardiovascularProblems !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasCardiovascularProblems!
                                          ? AppColors.backgroundColor
                                          : AppColors
                                              .buttonDisableBackgroundColor
                                      : AppColors.buttonDisableBackgroundColor
                                  : AppColors.buttonDisableBackgroundColor,
                              child: Center(
                                  child: Text("Si",
                                      style: controller.patientsTemp!
                                                  .medicalHistory !=
                                              null
                                          ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasCardiovascularProblems !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasCardiovascularProblems!
                                                  ? AppTextStyle
                                                      .boldWhiteContentTextStyle
                                                  : AppTextStyle
                                                      .boldContentTextStyle
                                              : AppTextStyle
                                                  .boldContentTextStyle
                                          : AppTextStyle
                                              .boldContentTextStyle))),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyCardio(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasCardiovascularProblems !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasCardiovascularProblems!
                                        ? AppColors.buttonDisableBackgroundColor
                                        : AppColors.backgroundColor
                                    : AppColors.buttonDisableBackgroundColor
                                : AppColors.buttonDisableBackgroundColor,
                            child: Center(
                                child: Text("No",
                                    style: controller
                                                .patientsTemp!.medicalHistory !=
                                            null
                                        ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasCardiovascularProblems !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasCardiovascularProblems!
                                                ? AppTextStyle
                                                    .boldContentTextStyle
                                                : AppTextStyle
                                                    .boldWhiteContentTextStyle
                                            : AppTextStyle.boldContentTextStyle
                                        : AppTextStyle.boldContentTextStyle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          "Cáncer",
                          style: AppTextStyle.normal16W500ContentTextStyle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyCancer(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasCancerProblems !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasCancerProblems!
                                          ? AppColors.backgroundColor
                                          : AppColors
                                              .buttonDisableBackgroundColor
                                      : AppColors.buttonDisableBackgroundColor
                                  : AppColors.buttonDisableBackgroundColor,
                              child: Center(
                                  child: Text("Si",
                                      style: controller.patientsTemp!
                                                  .medicalHistory !=
                                              null
                                          ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasCancerProblems !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasCancerProblems!
                                                  ? AppTextStyle
                                                      .boldWhiteContentTextStyle
                                                  : AppTextStyle
                                                      .boldContentTextStyle
                                              : AppTextStyle
                                                  .boldContentTextStyle
                                          : AppTextStyle
                                              .boldContentTextStyle))),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyCancer(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasCancerProblems !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasCancerProblems!
                                        ? AppColors.buttonDisableBackgroundColor
                                        : AppColors.backgroundColor
                                    : AppColors.buttonDisableBackgroundColor
                                : AppColors.buttonDisableBackgroundColor,
                            child: Center(
                                child: Text("No",
                                    style: controller
                                                .patientsTemp!.medicalHistory !=
                                            null
                                        ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasCancerProblems !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasCancerProblems!
                                                ? AppTextStyle
                                                    .boldContentTextStyle
                                                : AppTextStyle
                                                    .boldWhiteContentTextStyle
                                            : AppTextStyle.boldContentTextStyle
                                        : AppTextStyle.boldContentTextStyle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          "Diábetes",
                          style: AppTextStyle.normal16W500ContentTextStyle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyDiabetic(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasDiabeticsProblems !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasDiabeticsProblems!
                                          ? AppColors.backgroundColor
                                          : AppColors
                                              .buttonDisableBackgroundColor
                                      : AppColors.buttonDisableBackgroundColor
                                  : AppColors.buttonDisableBackgroundColor,
                              child: Center(
                                  child: Text("Si",
                                      style: controller.patientsTemp!
                                                  .medicalHistory !=
                                              null
                                          ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasDiabeticsProblems !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasDiabeticsProblems!
                                                  ? AppTextStyle
                                                      .boldWhiteContentTextStyle
                                                  : AppTextStyle
                                                      .boldContentTextStyle
                                              : AppTextStyle
                                                  .boldContentTextStyle
                                          : AppTextStyle
                                              .boldContentTextStyle))),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyDiabetic(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasDiabeticsProblems !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasDiabeticsProblems!
                                        ? AppColors.buttonDisableBackgroundColor
                                        : AppColors.backgroundColor
                                    : AppColors.buttonDisableBackgroundColor
                                : AppColors.buttonDisableBackgroundColor,
                            child: Center(
                                child: Text("No",
                                    style: controller
                                                .patientsTemp!.medicalHistory !=
                                            null
                                        ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasDiabeticsProblems !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasDiabeticsProblems!
                                                ? AppTextStyle
                                                    .boldContentTextStyle
                                                : AppTextStyle
                                                    .boldWhiteContentTextStyle
                                            : AppTextStyle.boldContentTextStyle
                                        : AppTextStyle.boldContentTextStyle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          "Obesidad",
                          style: AppTextStyle.normal16W500ContentTextStyle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyObesity(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasObesityProblems !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasObesityProblems!
                                          ? AppColors.backgroundColor
                                          : AppColors
                                              .buttonDisableBackgroundColor
                                      : AppColors.buttonDisableBackgroundColor
                                  : AppColors.buttonDisableBackgroundColor,
                              child: Center(
                                  child: Text("Si",
                                      style: controller.patientsTemp!
                                                  .medicalHistory !=
                                              null
                                          ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasObesityProblems !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasObesityProblems!
                                                  ? AppTextStyle
                                                      .boldWhiteContentTextStyle
                                                  : AppTextStyle
                                                      .boldContentTextStyle
                                              : AppTextStyle
                                                  .boldContentTextStyle
                                          : AppTextStyle
                                              .boldContentTextStyle))),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyObesity(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasObesityProblems !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasObesityProblems!
                                        ? AppColors.buttonDisableBackgroundColor
                                        : AppColors.backgroundColor
                                    : AppColors.buttonDisableBackgroundColor
                                : AppColors.buttonDisableBackgroundColor,
                            child: Center(
                                child: Text("No",
                                    style: controller
                                                .patientsTemp!.medicalHistory !=
                                            null
                                        ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasObesityProblems !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasObesityProblems!
                                                ? AppTextStyle
                                                    .boldContentTextStyle
                                                : AppTextStyle
                                                    .boldWhiteContentTextStyle
                                            : AppTextStyle.boldContentTextStyle
                                        : AppTextStyle.boldContentTextStyle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          "Respiratorios",
                          style: AppTextStyle.normal16W500ContentTextStyle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyRespiratory(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasRespiratoryProblems !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasRespiratoryProblems!
                                          ? AppColors.backgroundColor
                                          : AppColors
                                              .buttonDisableBackgroundColor
                                      : AppColors.buttonDisableBackgroundColor
                                  : AppColors.buttonDisableBackgroundColor,
                              child: Center(
                                  child: Text("Si",
                                      style: controller.patientsTemp!
                                                  .medicalHistory !=
                                              null
                                          ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasRespiratoryProblems !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasRespiratoryProblems!
                                                  ? AppTextStyle
                                                      .boldWhiteContentTextStyle
                                                  : AppTextStyle
                                                      .boldContentTextStyle
                                              : AppTextStyle
                                                  .boldContentTextStyle
                                          : AppTextStyle
                                              .boldContentTextStyle))),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyRespiratory(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasRespiratoryProblems !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasRespiratoryProblems!
                                        ? AppColors.buttonDisableBackgroundColor
                                        : AppColors.backgroundColor
                                    : AppColors.buttonDisableBackgroundColor
                                : AppColors.buttonDisableBackgroundColor,
                            child: Center(
                                child: Text("No",
                                    style: controller
                                                .patientsTemp!.medicalHistory !=
                                            null
                                        ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasRespiratoryProblems !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasRespiratoryProblems!
                                                ? AppTextStyle
                                                    .boldContentTextStyle
                                                : AppTextStyle
                                                    .boldWhiteContentTextStyle
                                            : AppTextStyle.boldContentTextStyle
                                        : AppTextStyle.boldContentTextStyle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          "Mentales",
                          style: AppTextStyle.normal16W500ContentTextStyle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyMental(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasMentalProblems !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasMentalProblems!
                                          ? AppColors.backgroundColor
                                          : AppColors
                                              .buttonDisableBackgroundColor
                                      : AppColors.buttonDisableBackgroundColor
                                  : AppColors.buttonDisableBackgroundColor,
                              child: Center(
                                  child: Text("Si",
                                      style: controller.patientsTemp!
                                                  .medicalHistory !=
                                              null
                                          ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasMentalProblems !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasMentalProblems!
                                                  ? AppTextStyle
                                                      .boldWhiteContentTextStyle
                                                  : AppTextStyle
                                                      .boldContentTextStyle
                                              : AppTextStyle
                                                  .boldContentTextStyle
                                          : AppTextStyle
                                              .boldContentTextStyle))),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyMental(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasMentalProblems !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasMentalProblems!
                                        ? AppColors.buttonDisableBackgroundColor
                                        : AppColors.backgroundColor
                                    : AppColors.buttonDisableBackgroundColor
                                : AppColors.buttonDisableBackgroundColor,
                            child: Center(
                                child: Text("No",
                                    style: controller
                                                .patientsTemp!.medicalHistory !=
                                            null
                                        ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasMentalProblems !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasMentalProblems!
                                                ? AppTextStyle
                                                    .boldContentTextStyle
                                                : AppTextStyle
                                                    .boldWhiteContentTextStyle
                                            : AppTextStyle.boldContentTextStyle
                                        : AppTextStyle.boldContentTextStyle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          "Gripes frecuentes",
                          style: AppTextStyle.normal16W500ContentTextStyle,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyFlu(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasFrequentFluProblems !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasFrequentFluProblems!
                                          ? AppColors.backgroundColor
                                          : AppColors
                                              .buttonDisableBackgroundColor
                                      : AppColors.buttonDisableBackgroundColor
                                  : AppColors.buttonDisableBackgroundColor,
                              child: Center(
                                  child: Text("Si",
                                      style: controller.patientsTemp!
                                                  .medicalHistory !=
                                              null
                                          ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasFrequentFluProblems !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasFrequentFluProblems!
                                                  ? AppTextStyle
                                                      .boldWhiteContentTextStyle
                                                  : AppTextStyle
                                                      .boldContentTextStyle
                                              : AppTextStyle
                                                  .boldContentTextStyle
                                          : AppTextStyle
                                              .boldContentTextStyle))),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyFlu(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasFrequentFluProblems !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasFrequentFluProblems!
                                        ? AppColors.buttonDisableBackgroundColor
                                        : AppColors.backgroundColor
                                    : AppColors.buttonDisableBackgroundColor
                                : AppColors.buttonDisableBackgroundColor,
                            child: Center(
                                child: Text("No",
                                    style: controller
                                                .patientsTemp!.medicalHistory !=
                                            null
                                        ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasFrequentFluProblems !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasFrequentFluProblems!
                                                ? AppTextStyle
                                                    .boldContentTextStyle
                                                : AppTextStyle
                                                    .boldWhiteContentTextStyle
                                            : AppTextStyle.boldContentTextStyle
                                        : AppTextStyle.boldContentTextStyle)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          controller.state.requestState.when(
              fetch: (){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              normal: (){
                return ButtonDigimed(
                    child: const Text(
                      "Siguiente",
                      style: AppTextStyle.normalWhiteContentTextStyle,
                    ),
                    onTab: () async {
                      await controller.checkDataCardio();
                      if(controller.nexStep){
                        controller.nexStep = false;
                        controller.step = 3;
                        await controller.changeState();
                      }
                    });
              }),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
