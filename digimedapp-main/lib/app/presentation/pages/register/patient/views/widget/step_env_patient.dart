import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepEnvPatient extends StatelessWidget {
  const StepEnvPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 6,
            lastStep: 10,
            onTab: () async {
              controller.step = 5;
              await controller.changeState();
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Cuestionario sobre el entorno del usuario" ,
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
                          "¿Está satisfecho con su empleo actual?",
                          style: AppTextStyle.normal12W500ContentTextStyle,
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
                            controller.formSatisfiedWithJob(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .satisfiedWithJob !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .satisfiedWithJob!
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
                                          .satisfiedWithJob !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .satisfiedWithJob!
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
                            controller.formSatisfiedWithJob(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .satisfiedWithJob !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .satisfiedWithJob!
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
                                        .satisfiedWithJob !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .satisfiedWithJob!
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
                          "¿Logra sus metas personales y laborales?",
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.normal12W500ContentTextStyle,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formHavePersonalGoals(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .havePersonalGoals !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .havePersonalGoals!
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
                                          .havePersonalGoals !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .havePersonalGoals!
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
                            controller.formHavePersonalGoals(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .havePersonalGoals !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .havePersonalGoals!
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
                                        .havePersonalGoals !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .havePersonalGoals!
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
                          "¿Tiene acceso continuo a servicios básicos?",
                          style: AppTextStyle.normal12W500ContentTextStyle,
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
                            controller.formHaveAccessEssentialService(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveAccessEssentialService !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveAccessEssentialService!
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
                                          .haveAccessEssentialService !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveAccessEssentialService!
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
                            controller.formHaveAccessEssentialService(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveAccessEssentialService !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveAccessEssentialService!
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
                                        .haveAccessEssentialService !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveAccessEssentialService!
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
                          "¿Es dueño de su casa y auto familiar?",
                          style: AppTextStyle.normal12W500ContentTextStyle,
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
                            controller.formHaveProperties(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveProperties !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveProperties!
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
                                          .haveProperties !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveProperties!
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
                            controller.formHaveProperties(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveProperties !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveProperties!
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
                                        .haveProperties !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveProperties!
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
                          "¿Es la contaminación un problema local?",
                          style: AppTextStyle.normal12W500ContentTextStyle,
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
                            controller.formHaveProblemEnviromentalContamination(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveProblemEnviromentalContamination !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveProblemEnviromentalContamination!
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
                                          .haveProblemEnviromentalContamination !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveProblemEnviromentalContamination!
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
                            controller.formHaveProblemEnviromentalContamination(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveProblemEnviromentalContamination !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveProblemEnviromentalContamination!
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
                                        .haveProblemEnviromentalContamination !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveProblemEnviromentalContamination!
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
                    onTab: () async{
                      await controller.checkEnvHabit();
                      if(controller.nexStep){
                        controller.nexStep = false;
                        controller.step = 7;
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

