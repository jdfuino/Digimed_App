import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
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
import 'package:digimed/app/presentation/pages/home/admin/home/controller/admin_home_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home/controller/state/admin_home_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home/views/widget/list_item.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final SessionController sessionController = context.read();
    sessionController.setContext(context);
    return ChangeNotifierProvider(
      create: (_) => AdminHomeController(
        AdminHomeState(),
        authenticationRepository: Repositories.authentication,
        sessionController: sessionController,
        accountRepository: Repositories.account,
      )..init(),
      child: Builder(builder: (context) {
        final controller =
            Provider.of<AdminHomeController>(context, listen: true);
        return MyScaffold(
          resizeToAvoidBottomInset: false,
          // floatingActionButton:
          // FloatingActionButton(
          //   elevation: 0,
          //   onPressed: () {
          //     showModalBottomSheet(
          //         context: context,
          //         isScrollControlled: true,
          //         constraints: BoxConstraints(maxWidth: size.width * 0.92),
          //         shape: const RoundedRectangleBorder(
          //           borderRadius: BorderRadius.vertical(
          //             top: Radius.circular(25.0),
          //           ),
          //         ),
          //         builder: (_) => FormNewDoctor(
          //               onFinish: () async {
          //                 await controller.loadListDoctors(
          //                     associateDoctors:
          //                         const AssociateDoctors.loading());
          //               },
          //             ));
          //   },
          //   backgroundColor: AppColors.backgroundColor,
          //   child: const Icon(DigimedIcon.add_doctor),
          // ),
          body: Column(
            children: [
              BannerDigimed(
                  textLeft: "Tus Usuarios",
                  iconLeft: DigimedIcon.user_doctor,
                  iconRight: DigimedIcon.exit,
                  onClickIconRight: () {
                    closeSession(context: context, mounted: controller.mounted);
                  },
                  firstLine: "Hola,",
                  secondLine: "Coordinador",
                  lastLine: "Estos son tus medicos",
                  imageProvider: isValidUrl(controller.urlImage)
                      ? NetworkImage(controller.urlImage!)
                      : Assets.images.logo.provider()),
              Center(
                child: controller.state.associateDoctors.when(
                  loading: () => Container(),
                  failed: (failed) {
                    failed.maybeWhen(tokenInvalided: () {
                      closeSession(context: context);
                    }, orElse: () {
                      return errorHomeAdmin(context);
                    });
                  },
                  loaded: (list) => Text(
                    "Médicos Creados: ${list.length}",
                    style: AppTextStyle.normalTextStyle2,
                  ),
                ),
              ),
              const ListItem()
            ],
          ),
        );
      }),
    );
  }

  Widget errorHomeAdmin(BuildContext context) {
    final AdminHomeController controller = context.read();
    showToast("Hemos tenido un problema");
    return Center(
      child: ButtonErrorDigimed(
        onTab: () {
          controller.loadListDoctors(
              associateDoctors: const AssociateDoctors.loading());
        },
      ),
    );
  }
}
// comentario para probar la conexion con el proyecto en GitHub.
