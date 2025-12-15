import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_card_patient.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/controller/info_patient_controller.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/controller/state/info_patient_state.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/view/widget/card_habit_patient.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/view/widget/card_info_doctor.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/view/widget/card_information_data_patient.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/view/widget/card_information_setting_patient.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/view/widget/card_my_treatment.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

class InfoPatientPage extends StatelessWidget {
  Patients patients;
  final VoidCallback close;

  InfoPatientPage({super.key, required this.patients, required this.close});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InfoPatientController(
          InfoPatientState(dataPatientState: DataPatientState.loaded(patients)),
          accountRepository: Repositories.account,
          sessionController: context.read(),
          patients: patients,
          authenticationRepository: Repositories.authentication)
        ..init(),
      child: MyScaffold(
        body: Builder(
          builder: (context) {
            final controller = Provider.of<InfoPatientController>(
              context,
              listen: true,
            );
            return SingleChildScrollView(
              child: Column(
                children: [
                  BannerDigimed(
                    onClickIconRight: () {
                      controller.authenticationRepository.signOut();
                      controller.sessionController.signOut();
                      close();
                    },
                    textLeft: "Información personal",
                    iconLeft: DigimedIcon.user,
                    iconRight: DigimedIcon.exit,
                    firstLine: "Hola,",
                    secondLine: "${patients.user.fullName}",
                    lastLine:
                        "${patients.user.identificationType}.${patients.user.identificationNumber}",
                    imageProvider: isValidUrl(patients.user.urlImageProfile)
                        ? NetworkImage(patients.user.urlImageProfile!)
                        : Assets.images.logo.provider(),
                  ),
                  //-----------------------------------------------------------------------
                  controller.state.isSettingDataBasic
                      ? const CardInformationSettingPatient()
                      : const CardInformationDataPatient(),
                  //-----------------------------------------------------------------------
                  controller.state.dataPatientState.when(loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }, failed: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }, loaded: (_) {
                    return const CardHabitPatient();
                  }),
                  //-----------------------------------------------------------------------

                  controller.sessionController.patients!.treatments.isNotEmpty
                      ? CardMyTreatment(
                          myTreatments:
                              controller.sessionController.patients!.treatments)
                      : const SizedBox.shrink(),
                  //-----------------------------------------------------------------------

                  const CardInfoDoctor(),
                  SizedBox(
                    height: 32,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
