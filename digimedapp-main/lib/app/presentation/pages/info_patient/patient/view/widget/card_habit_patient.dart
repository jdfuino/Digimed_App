import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/controller/info_patient_controller.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/view/widget/card_habit_setting.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/view/widget/card_hait_data_patient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardHabitPatient extends StatelessWidget {
  const CardHabitPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
      child: CardDigimed(
          child: controller.state.isSetting
              ?  const CardHabitPatientSetting()
              : const CardHabitDataPatient()
      ),
    );
  }
}
