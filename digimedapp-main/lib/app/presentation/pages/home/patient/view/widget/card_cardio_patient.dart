import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/home/patient/controller/home_patient_controller.dart';
import 'package:digimed/app/presentation/pages/home/patient/controller/state/home_patient_state.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_cardio_data.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_cardio_null.dart';
import 'package:digimed/app/presentation/pages/new_profile_cardio/patient/view/new_profile_cardio_page.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CardCardioPatient extends StatelessWidget {
  const CardCardioPatient({super.key});

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
                  if (patient != null && patient.profileCardiovascular != null) {
                    return const CardCardioData();
                  } else {
                    return const CardCardioNull();
                  }
                }),
                Container(
                  margin: const EdgeInsets.only(right: 24, left: 24),
                  child: ButtonDigimed(
                    height: 60,
                      child: Text(
                        "Actualizar",
                        style: AppTextStyle.normalWhiteContentTextStyle,
                      ),
                      onTab: () async {
                        final result = await PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: NewProfileCardioPage(
                              id: controller.patients.patientID,
                          doctorID: controller.patients.meDoctorID != null
                          ? controller.patients.meDoctorID!
                          : 1),
                          withNavBar: false
                        );
                        print(result);
                        if (result != null && result as bool) {
                          controller.refreshMePatient(
                              associatePatientPatients:
                              const AssociatePatientPatients.loading());
                        }
                      }),
                ),
                SizedBox(height: 16,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
