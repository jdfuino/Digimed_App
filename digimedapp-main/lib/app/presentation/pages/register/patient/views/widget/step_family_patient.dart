import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepFamilyPatient extends StatelessWidget {
  const StepFamilyPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 3,
            lastStep: 10,
            onTab: () async {
              controller.step = 2;
              await controller.changeState();
            },
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "¿Tienes familiares con alguna de estas patologías?" ,
            textAlign: TextAlign.center,
            style: AppTextStyle.normal17ContentTextStyle,
          ),
          SizedBox(
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
                      SizedBox(
                        width: 150,
                        child: const Text(
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
                            controller.formPathologyFamilyCardio(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesCardiovascularProblems !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesCardiovascularProblems!
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
                                          .haveRelativesCardiovascularProblems !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveRelativesCardiovascularProblems!
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
                            controller.formPathologyFamilyCardio(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesCardiovascularProblems !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesCardiovascularProblems!
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
                                        .haveRelativesCardiovascularProblems !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveRelativesCardiovascularProblems!
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
                      SizedBox(
                        width: 150,
                        child: const Text(
                          "Cáncer",
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.normal16W500ContentTextStyle,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            controller.formPathologyFamilyCancer(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesCancerProblems !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesCancerProblems!
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
                                          .haveRelativesCancerProblems !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveRelativesCancerProblems!
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
                            controller.formPathologyFamilyCancer(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesCancerProblems !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesCancerProblems!
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
                                        .haveRelativesCancerProblems !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveRelativesCancerProblems!
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
                      SizedBox(
                        width: 150,
                        child: const Text(
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
                            controller.formPathologyFamilyDiabetic(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesDiabeticsProblems !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesDiabeticsProblems!
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
                                          .haveRelativesDiabeticsProblems !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveRelativesDiabeticsProblems!
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
                            controller.formPathologyFamilyDiabetic(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesDiabeticsProblems !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesDiabeticsProblems!
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
                                        .haveRelativesDiabeticsProblems !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveRelativesDiabeticsProblems!
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
                      SizedBox(
                        width: 150,
                        child: const Text(
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
                            controller.formPathologyFamilyObesity(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesObesityProblems !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesObesityProblems!
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
                                          .haveRelativesObesityProblems !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveRelativesObesityProblems!
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
                            controller.formPathologyFamilyObesity(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesObesityProblems !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesObesityProblems!
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
                                        .haveRelativesObesityProblems !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveRelativesObesityProblems!
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
                      SizedBox(
                        width: 150,
                        child: const Text(
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
                            controller.formPathologyFamilyRespiratory(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesRespiratoryProblems !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesRespiratoryProblems!
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
                                          .haveRelativesRespiratoryProblems !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveRelativesRespiratoryProblems!
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
                            controller.formPathologyFamilyRespiratory(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesRespiratoryProblems !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesRespiratoryProblems!
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
                                        .haveRelativesRespiratoryProblems !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveRelativesRespiratoryProblems!
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
                      SizedBox(
                        width: 150,
                        child: const Text(
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
                            controller.formPathologyFamilyMental(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesMentalProblems !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .haveRelativesMentalProblems!
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
                                          .haveRelativesMentalProblems !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .haveRelativesMentalProblems!
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
                            controller.formPathologyFamilyMental(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesMentalProblems !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .haveRelativesMentalProblems!
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
                                        .haveRelativesMentalProblems !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .haveRelativesMentalProblems!
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
          SizedBox(
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
                    child: Text(
                      "Siguiente",
                      style: AppTextStyle.normalWhiteContentTextStyle,
                    ),
                    onTab: () async{
                      await controller.checkDataFamily();
                      if(controller.nexStep){
                        controller.nexStep = false;
                        controller.step = 4;
                        await controller.changeState();
                      }
                    });
              }),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
