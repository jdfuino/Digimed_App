import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/button_error_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_medical_center/controller/home_medical_center_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_medical_center/controller/state/home_medical_center_state.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_medical_center/view/widget/list_item_coordinador_medical_center.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMedicalCenterCoordinatorPage extends StatelessWidget {
  final int idMedicalCenter;
  final MedicalCenter medicalCenter;

  const HomeMedicalCenterCoordinatorPage({
    Key? key,
    required this.idMedicalCenter,
    required this.medicalCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    sessionController.setContext(context);
    return ChangeNotifierProvider(
      create: (_) => HomeMedicalCenterController(
        HomeMedicalCenterState(),
        sessionController: sessionController,
        accountRepository: Repositories.account,
        idMedicalCenter: idMedicalCenter,
        authenticationRepository: Repositories.authentication,
      )..init(),
      child: Builder(builder: (context) {
        final controller =
            Provider.of<HomeMedicalCenterController>(context, listen: true);
        return MyScaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              BannerDigimed(
                textLeft: "Centro Medico",
                iconLeft: DigimedIcon.user_doctor,
                iconRight: DigimedIcon.back,
                onClickIconRight: () {
                  Navigator.pop(context);
                },
                firstLine: "Centro Medico,",
                secondLine: "${medicalCenter.name}",
                lastLine: "${medicalCenter.address}",
                imageProvider: isValidUrl(medicalCenter.logoUrl)
                    ? NetworkImage(medicalCenter.logoUrl!)
                    : Assets.images.logo.provider(),
              ),
              Center(
                child: controller.state.requestState.when(
                  loading: () => Container(),
                  failed: (failed) {
                    return failed.maybeWhen(tokenInvalided: () {
                      closeSession(context: context);
                    }, orElse: () {
                      return errorHomeCoordinator(context);
                    });
                  },
                  loaded: (list) {
                    return Text(
                      "Coordinadores: ${list.length}",
                      style: AppTextStyle.normalTextStyle2,
                    );
                  },
                ),
              ),
              const ListItemCoordinadorMedicalCenter(),
            ],
          ),
        );
      }),
    );
  }
}

Widget errorHomeCoordinator(BuildContext context) {
  final HomeMedicalCenterController controller = context.read();
  showToast("Hemos tenido un problema");
  return Center(
    child: ButtonErrorDigimed(
      onTab: () {
        controller.listMedicalCenterCoordinator(
            requestState: const RequestState.loading());
      },
    ),
  );
}
