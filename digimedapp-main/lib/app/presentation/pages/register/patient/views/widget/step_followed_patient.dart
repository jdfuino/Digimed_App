import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepFollowedPatient extends StatelessWidget {
  const StepFollowedPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StepIndicator(
            step: 7,
            lastStep: 10,
            onTab: () async {
              controller.step = 6;
              await controller.changeState();
            },
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: Text(
              '''¿De qué forma hace seguimiento a su estado de salud actual?''',
              textAlign: TextAlign.center,
              style: AppTextStyle.normal17ContentTextStyle,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: GestureDetector(
              onTap: () {
                controller.changeFollowed(followUpMethod[0]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[0])
                        ? AppColors.backgroundColor
                        : Colors.white
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Consulta médica regular",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                                    .contains(followUpMethod[0])
                                ? AppTextStyle.normalWhite16W500ContentTextStyle
                                : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: GestureDetector(
              onTap: () {
                controller.changeFollowed(followUpMethod[1]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[1])
                        ? AppColors.backgroundColor
                        : Colors.white
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Telemedicina",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                                    .contains(followUpMethod[1])
                                ? AppTextStyle.normalWhite16W500ContentTextStyle
                                : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: GestureDetector(
              onTap: () {
                controller.changeFollowed(followUpMethod[2]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[2])
                        ? AppColors.backgroundColor
                        : Colors.white
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Atención primaria de salud (APS)",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                                    .contains(followUpMethod[2])
                                ? AppTextStyle.normalWhite16W500ContentTextStyle
                                : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: GestureDetector(
              onTap: () {
                controller.changeFollowed(followUpMethod[3]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[3])
                        ? AppColors.backgroundColor
                        : Colors.white
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Soy asegurado",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                                    .contains(followUpMethod[3])
                                ? AppTextStyle.normalWhite16W500ContentTextStyle
                                : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: GestureDetector(
              onTap: () {
                controller.changeFollowed(followUpMethod[4]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[4])
                        ? AppColors.backgroundColor
                        : Colors.white
                    : AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No poseo control médico",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                                    .contains(followUpMethod[4])
                                ? AppTextStyle.normalWhite16W500ContentTextStyle
                                : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normalWhite16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          controller.state.requestState.when(fetch: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, normal: () {
            return ButtonDigimed(
                child: Text(
                  "Siguiente",
                  style: AppTextStyle.normalWhite16W500ContentTextStyle,
                ),
                onTab: () async {
                  await controller.uploadFollowedMethod();

                  if(controller.nexStep){
                    controller.nexStep = false;
                    controller.step = 8;
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
