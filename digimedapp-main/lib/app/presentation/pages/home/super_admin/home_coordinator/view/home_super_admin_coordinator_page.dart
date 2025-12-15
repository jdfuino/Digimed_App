import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/button_error_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/form_new_doctor.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_coordinator/controller/home_super_admin_coordinator_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_coordinator/controller/state/super_admin_home_coordinator_state.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_coordinator/view/widget/list_item_super_admin.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSuperAdminCoordinatorPage extends StatelessWidget {
  final int idMedicalCenter;
  final User coordinadorMedicalCenter;

  const HomeSuperAdminCoordinatorPage(
      {Key? key,
      required this.idMedicalCenter,
      required this.coordinadorMedicalCenter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final SessionController sessionController = context.read();
    sessionController.setContext(context);
    return ChangeNotifierProvider(
      create: (_) => SuperAdminHomeCoordinatorController(
        SuperAdminHomeCoordinatorState(),
        authenticationRepository: Repositories.authentication,
        sessionController: sessionController,
        idMedicalCenter: idMedicalCenter,
        accountRepository: Repositories.account,
      )..init(),
      child: Builder(builder: (context) {
        final controller = Provider.of<SuperAdminHomeCoordinatorController>(
            context,
            listen: true);
        return MyScaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  constraints: BoxConstraints(maxWidth: size.width * 0.92),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (_) => FormNewDoctor(
                        onFinish: () async {
                          await controller.loadListDoctors(
                              listDoctors: const ListDoctors.loading());
                        },
                      ));
            },
            backgroundColor: AppColors.backgroundColor,
            child: const Icon(DigimedIcon.add_doctor),
          ),
          body: Column(
            children: [
              BannerDigimed(
                textLeft: "Tus Usuarios",
                iconLeft: DigimedIcon.user_doctor,
                iconRight: DigimedIcon.back,
                onClickIconRight: () {
                  Navigator.pop(context);
                },
                firstLine: "Coordinador",
                secondLine: "${coordinadorMedicalCenter.fullName}",
                lastLine: "Estos son sus medicos",
                imageProvider: isValidUrl(coordinadorMedicalCenter.urlImageProfile)
                    ? NetworkImage(coordinadorMedicalCenter.urlImageProfile!)
                    : Assets.images.logo.provider(),
              ),
              Center(
                child: controller.state.listDoctors.when(
                  loading: () => Container(),
                  failed: (failed) {
                    failed.maybeWhen(
                        tokenInvalided: () {
                          closeSession(context: context);
                        },
                        orElse: () {});
                  },
                  loaded: (list) => Text(
                    "Médicos Creados: ${list.length}",
                    style: AppTextStyle.normalTextStyle2,
                  ),
                ),
              ),
              const ListItemSuperAdmin()
            ],
          ),
        );
      }),
    );
  }

  Widget errorHomeAdmin(BuildContext context) {
    final SuperAdminHomeCoordinatorController controller = context.read();
    showToast("Hemos tenido un problema");
    return Center(
      child: ButtonErrorDigimed(
        onTab: () {
          controller.loadListDoctors(listDoctors: const ListDoctors.loading());
        },
      ),
    );
  }
}
