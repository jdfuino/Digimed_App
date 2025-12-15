import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepHabitPatient extends StatelessWidget {
  const StepHabitPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 4,
            lastStep: 10,
            onTab: () async {
              controller.step = 3;
              await controller.changeState();
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "¿Posees alguno de estos hábitos?",
            textAlign: TextAlign.center,
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
                          "Bebe alcohol",
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
                            controller.formHabitDrinking(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasDrinkingHabit !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasDrinkingHabit!
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
                                                      .hasDrinkingHabit !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasDrinkingHabit!
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
                            controller.formHabitDrinking(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasDrinkingHabit !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasDrinkingHabit!
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
                                                    .hasDrinkingHabit !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasDrinkingHabit!
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
                          "Fuma",
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
                            controller.formHabitSmoking(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasSmokingHabit !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasSmokingHabit!
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
                                                      .hasSmokingHabit !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasSmokingHabit!
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
                            controller.formHabitSmoking(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasSmokingHabit !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasSmokingHabit!
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
                                                    .hasSmokingHabit !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasSmokingHabit!
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
                          "Consume cafeína",
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
                            controller.formHabitDrinkingCaffeine(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasDrinkingCaffeineHabit !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasDrinkingCaffeineHabit!
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
                                                      .hasDrinkingCaffeineHabit !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasDrinkingCaffeineHabit!
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
                            controller.formHabitDrinkingCaffeine(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasDrinkingCaffeineHabit !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasDrinkingCaffeineHabit!
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
                                                    .hasDrinkingCaffeineHabit !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasDrinkingCaffeineHabit!
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
                          "Toma medicamentos",
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
                            controller.formHabitMedication(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasMedication !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasMedication!
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
                                                      .hasMedication !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasMedication!
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
                            controller.formHabitMedication(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasMedication !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasMedication!
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
                                                    .hasMedication !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasMedication!
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
                          "No hace ejercicio",
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
                            controller.formHabitFitness(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasFitnessHabit !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasFitnessHabit!
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
                                                      .hasFitnessHabit !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasFitnessHabit!
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
                            controller.formHabitFitness(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasFitnessHabit !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasFitnessHabit!
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
                                                    .hasFitnessHabit !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasFitnessHabit!
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
                          "Come a deshoras",
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
                            controller.formHabitEating(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                      null
                                  ? controller.patientsTemp!.medicalHistory!
                                              .hasEatingAfterHoursHabit !=
                                          null
                                      ? controller.patientsTemp!.medicalHistory!
                                              .hasEatingAfterHoursHabit!
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
                                                      .hasEatingAfterHoursHabit !=
                                                  null
                                              ? controller
                                                      .patientsTemp!
                                                      .medicalHistory!
                                                      .hasEatingAfterHoursHabit!
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
                            controller.formHabitEating(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                    null
                                ? controller.patientsTemp!.medicalHistory!
                                            .hasEatingAfterHoursHabit !=
                                        null
                                    ? controller.patientsTemp!.medicalHistory!
                                            .hasEatingAfterHoursHabit!
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
                                                    .hasEatingAfterHoursHabit !=
                                                null
                                            ? controller
                                                    .patientsTemp!
                                                    .medicalHistory!
                                                    .hasEatingAfterHoursHabit!
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
          controller.state.requestState.when(fetch: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, normal: () {
            return ButtonDigimed(
                child: const Text(
                  "Siguiente",
                  style: AppTextStyle.normalWhiteContentTextStyle,
                ),
                onTab: () async {
                  await controller.checkDataHabit();
                  print(controller.nexStep);
                  if (controller.nexStep) {
                    controller.nexStep = false;
                    controller.step = 5;
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
