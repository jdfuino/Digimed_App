import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepFoodPatient extends StatelessWidget {
  const StepFoodPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 5,
            lastStep: 10,
            onTab: () async {
              controller.step = 4;
              await controller.changeState();
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "¿Consume estos alimentos más de dos veces por semana?" ,
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
                          "¿Comidas rápida?",
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
                            controller.formConsumeCannedFood(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumeCannedFood !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumeCannedFood!
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
                                          .consumeCannedFood !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .consumeCannedFood!
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
                            controller.formConsumeCannedFood(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumeCannedFood !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumeCannedFood!
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
                                        .consumeCannedFood !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .consumeCannedFood!
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
                          "¿Alimentos y bebidas azucarados?",
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
                            controller.formConsumeSugaryFood(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumeSugaryFood !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumeSugaryFood!
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
                                          .consumeSugaryFood !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .consumeSugaryFood!
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
                            controller.formConsumeSugaryFood(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumeSugaryFood !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumeSugaryFood!
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
                                        .consumeSugaryFood !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .consumeSugaryFood!
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
                          "¿Grasas saturadas?",
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
                            controller.formConsumeSaturedFood(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumeSaturedFood !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumeSaturedFood!
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
                                          .consumeSaturedFood !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .consumeSaturedFood!
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
                            controller.formConsumeSaturedFood(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumeSaturedFood !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumeSaturedFood!
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
                                        .consumeSaturedFood !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .consumeSaturedFood!
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
                          "¿Alimentos salados o muy condimentados?",
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
                            controller.formConsumeHighlySeasonedFoods(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumeHighlySeasonedFoods !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumeHighlySeasonedFoods!
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
                                          .consumeHighlySeasonedFoods !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .consumeHighlySeasonedFoods!
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
                            controller.formConsumeHighlySeasonedFoods(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumeHighlySeasonedFoods !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumeHighlySeasonedFoods!
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
                                        .consumeHighlySeasonedFoods !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .consumeHighlySeasonedFoods!
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
                          "¿Alimentos preparados?",
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
                            controller.formConsumePreparedFoods(true);
                          },
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: controller.patientsTemp!.medicalHistory !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumePreparedFoods !=
                                  null
                                  ? controller.patientsTemp!.medicalHistory!
                                  .consumePreparedFoods!
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
                                          .consumePreparedFoods !=
                                          null
                                          ? controller
                                          .patientsTemp!
                                          .medicalHistory!
                                          .consumePreparedFoods!
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
                            controller.formConsumePreparedFoods(false);
                          },
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: controller.patientsTemp!.medicalHistory !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumePreparedFoods !=
                                null
                                ? controller.patientsTemp!.medicalHistory!
                                .consumePreparedFoods!
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
                                        .consumePreparedFoods !=
                                        null
                                        ? controller
                                        .patientsTemp!
                                        .medicalHistory!
                                        .consumePreparedFoods!
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
                      await controller.checkFoodHabit();
                      if(controller.nexStep){
                        controller.nexStep = false;
                        controller.step = 6;
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
