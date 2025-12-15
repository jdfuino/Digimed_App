import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/button_error_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home/controller/state/super_admin_home_state.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home/controller/super_admin_home_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home/view/widget/list_item_medical_center.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuperAdminHomePage extends StatelessWidget {
  const SuperAdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    sessionController.setContext(context);
    return ChangeNotifierProvider(
      create: (_) => SuperAdminHomeController(
        SuperAdminHomeState(),
        sessionController: sessionController,
        accountRepository: Repositories.account,
        authenticationRepository: Repositories.authentication,
      )..init(),
      child: Builder(builder: (context) {
        final controller =
            Provider.of<SuperAdminHomeController>(context, listen: true);
        return MyScaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              BannerDigimed(
                textLeft: "Centros Medicos",
                iconLeft: DigimedIcon.user_doctor,
                iconRight: DigimedIcon.exit,
                onClickIconRight: () {
                  closeSession(context: context, mounted: controller.mounted);
                },
                firstLine: "Hola,",
                secondLine: "Administrador",
                lastLine: "Estos son los centros medicos",
                imageProvider: isValidUrl(controller.urlImage)
                    ? NetworkImage(controller.urlImage!)
                    : Assets.images.logo.provider(),
              ),
              Center(
                child: controller.state.medicalCenterState.when(
                  loading: () => Container(),
                  failed: (failed) {
                    return failed.maybeWhen(tokenInvalided: () {
                      closeSession(context: context);
                    }, orElse: () {
                      return errorHomeSuperAdmin(context);
                    });
                  },
                  loaded: (list) {
                    return Text(
                      "Centros Medicos: ${list.length}",
                      style: AppTextStyle.normalTextStyle2,
                    );
                  },
                ),
              ),
              const ListItemMedicalCenter(),
            ],
          ),
        );
      }),
    );
  }
}

Widget errorHomeSuperAdmin(BuildContext context) {
  final SuperAdminHomeController controller = context.read();
  showToast("Hemos tenido un problema");
  return Center(
    child: ButtonErrorDigimed(
      onTab: () {
        controller.listMedicalCenter(
            medicalCenterState: const MedicalCenterState.loading());
      },
    ),
  );
}
