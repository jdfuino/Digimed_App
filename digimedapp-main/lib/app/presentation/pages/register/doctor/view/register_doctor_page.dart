import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/widgets/banner_logo.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/register/doctor/controller/register_doctor_controller.dart';
import 'package:digimed/app/presentation/pages/register/doctor/controller/state/register_doctor_state.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_data.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_password.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widget/step_profile_image.dart';

class RegisterDoctorPage extends StatelessWidget {
  int step;

  RegisterDoctorPage({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    SessionController session = context.read();
    session.setContext(context);
    return ChangeNotifierProvider(
      create: (_) => RegisterDoctorController(
          RegisterDoctorState(
              doctorData: DoctorDataSucess(doctor: session.doctor!)),
          accountRepository: Repositories.account,
          sessionController: session,
          step: step)
        ..init(),
      child: MyScaffold(
        body: Builder(
          builder: (context) {
            final controller = Provider.of<RegisterDoctorController>(
              context,
              listen: true,
            );
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BannerLogo(),
                  controller.state.doctorData.when(
                      loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }, faild: (fail) {
                    fail.maybeWhen(
                        tokenInvalided: () {
                          closeSession(context: context);
                        },
                        orElse: () {});
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }, sucess: (doctor) {
                    return controller.state.registerStepDoctorState.when(
                        changePassword: () {
                      return StepPassword();
                    }, changeData: () {
                      return StepData();
                    }, changeProfileImage: () {
                      return StepProfileImage();
                    });
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
