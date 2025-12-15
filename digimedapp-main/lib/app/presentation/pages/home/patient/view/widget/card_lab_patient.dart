import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/home/patient/controller/home_patient_controller.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_cardio_null.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_lab_data.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_lab_null.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardLabPatient extends StatelessWidget {
  const CardLabPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24),
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          CardDigimed(
            child: Column(
              children: [
                controller.state.associatePatients.when(loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, failed: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, loaded: (patient) {
                  if (patient != null && patient.profileLaboratory != null) {
                    return  const CardLabData();
                  } else {
                    return const CardLabNull();
                  }
                }),
              ],
            ),
          ),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
