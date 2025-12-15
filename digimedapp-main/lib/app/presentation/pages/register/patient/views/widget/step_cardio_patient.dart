import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/pages/new_profile_cardio/patient/view/new_profile_cardio_page.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepCardioPatient extends StatefulWidget {
  const StepCardioPatient({super.key});

  @override
  State<StepCardioPatient> createState() => _StepCardioPatientState();
}

class _StepCardioPatientState extends State<StepCardioPatient> {
  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 24, left: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 9,
            lastStep: 10,
            onTab: () async {
              controller.step = 8;
              await controller.changeState();
            },
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            margin: const EdgeInsets.only(right: 24, left: 24),
            child: Text(
              "¡Felicidades! ya estás listo para actualizar tu perfil cardiovascular.",
              textAlign: TextAlign.center,
              style: AppTextStyle.normal17ContentTextStyle,
            ),
          ),
          SizedBox(
            height: 64,
          ),
          Assets.svgs.testDigimed.svg(),
          SizedBox(
            height: 48,
          ),
          ButtonDigimed(
              child: Text(
                "Actualizar",
                style: AppTextStyle.normalWhiteContentTextStyle,
              ),
              onTab: () async {
                bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewProfileCardioPage(
                              id: controller.patientsTemp!.patientID,
                              doctorID:
                                  controller.patientsTemp!.meDoctorID != null
                                      ? controller.patientsTemp!.meDoctorID!
                                      : 1,
                            )));
                if (result != null && result) {
                  try {
                    await controller.goToNewStep(8);
                    if (!mounted) {
                      return;
                    }
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.homePatient,
                    );
                  } catch (e) {
                    print(e);
                  }
                }
              }),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
