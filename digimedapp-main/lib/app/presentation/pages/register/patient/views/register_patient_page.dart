import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/widgets/banner_logo.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/state/register_patient_state.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_cardio_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_data_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_env_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_family_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_followed_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_food_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_habit_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_password_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_pathology_patient.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/widget/step_profile_image_patient.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPatientPage extends StatelessWidget {
  int step;

  RegisterPatientPage({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    sessionController.setContext(context);
    return ChangeNotifierProvider(
      create: (_) => RegisterPatientController(
          RegisterPatientState(
              patientState: PatientState.loaded(sessionController.patients!)),
          accountRepository: Repositories.account,
          sessionController: sessionController,
          step: step)
        ..init(),
      child: MyScaffold(
        body: Builder(
          builder: (context) {
            final controller = Provider.of<RegisterPatientController>(
              context,
              listen: true,
            );
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BannerLogo(),
                  controller.state.patientState.when(loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }, failed: (fail) {
                    fail.maybeWhen(
                        tokenInvalided: () {
                          closeSession(context: context);
                        },
                        orElse: () {});
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }, loaded: (patient) {
                    return controller.state.registerStepPatientState.when(
                      changePassword: () {
                        return const StepPasswordPatient();
                      },
                      changeData: () {
                        return const StepDataPatient();
                      },
                      changePathology: () {
                        return const StepPathologyPatient();
                      },
                      changeFamilyPathology: () {
                        return const StepFamilyPatient();
                      },
                      changeHabit: () {
                        return const StepHabitPatient();
                      },
                      newProfileCardiovascular: () {
                        return const StepCardioPatient();
                      },
                      changeFood: () {
                        return const StepFoodPatient();
                      },
                      changeEnv: () {
                        return const StepEnvPatient();
                      },
                      changeFollowed: () {
                        return const StepFollowedPatient();
                      },
                      changeProfileImage: () {
                        return const StepProfileImagePatient();
                      },
                    );
                  })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
