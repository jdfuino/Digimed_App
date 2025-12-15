import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/info_medical_center/controller/info_medical_center_controller.dart';
import 'package:digimed/app/presentation/pages/info_medical_center/controller/state/info_medical_center_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoCoordinatorPage extends StatelessWidget {
  final CoordinatorMedicalCenter coordinatorMedicalCenter;

  const InfoCoordinatorPage({
    Key? key,
    required this.coordinatorMedicalCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    sessionController.setContext(context);
    return ChangeNotifierProvider(
      create: (_) => InfoMedicalCenterController(
        InfoMedicalCenterState(),
        sessionController: sessionController,
        accountRepository: Repositories.account,
        authenticationRepository: Repositories.authentication,
        medicalCenterId: 1,
      )..init(),
      child: Builder(builder: (context) {
        final controller =
            Provider.of<InfoMedicalCenterController>(context, listen: true);
        return MyScaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(
              children: [
                BannerDigimed(
                  textLeft: "Centro Medico",
                  iconLeft: DigimedIcon.user_doctor,
                  iconRight: DigimedIcon.back,
                  onClickIconRight: () {
                    Navigator.pop(context);
                  },
                  firstLine: "Centro Medico,",
                  secondLine: "${coordinatorMedicalCenter.name}",
                  lastLine: "${coordinatorMedicalCenter.department}",
                  imageProvider: isValidUrl(coordinatorMedicalCenter.imagenLogo)
                      ? NetworkImage(coordinatorMedicalCenter.imagenLogo!)
                      : Assets.images.logo.provider(),
                ),
                // cardInfo(medicalCenter),
                SizedBox(
                  height: 16,
                ),
                // cardInfo2(medicalCenter),
                SizedBox(
                  height: 16,
                ),
                Container(
                  margin:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 15),
                  child: ButtonDigimed(
                    child: const Text(
                      "Ver Coordinadores",
                      style: AppTextStyle.normalWhiteContentTextStyle,
                    ),
                    onTab: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
