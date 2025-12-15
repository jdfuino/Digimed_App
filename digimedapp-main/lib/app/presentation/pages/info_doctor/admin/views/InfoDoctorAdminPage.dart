import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_point/card_point.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/form_new_doctor.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_patient/view/form_new_patient_sheet.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/controller/info_doctor_admin_controller.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/controller/state/info_doctor_admin_state.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/views/widget/card_hour.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/views/widget/card_setting.dart';
import 'package:digimed/app/presentation/pages/scored_activity/doctor/page/scored_activity_patient_page.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoDoctorAdminPage extends StatelessWidget {
  final int id;

  const InfoDoctorAdminPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => InfoDoctorAdminController(InfoDoctorAdminState(),
          sessionController: context.read(),
          accountRepository: Repositories.account,
          fatherId: id)
        ..init(),
      child: MyScaffold(
        body: Builder(builder: (context) {
          final controller = Provider.of<InfoDoctorAdminController>(
            context,
            listen: true,
          );
          return SingleChildScrollView(
            child: Column(
              children: [
                BannerDigimed(
                    textLeft: "Tus Usuarios",
                    iconLeft: DigimedIcon.user_doctor,
                    iconRight: DigimedIcon.back,
                    onClickIconRight: () {
                      Navigator.of(context).pop();
                    },
                    firstLine: "Médico",
                    secondLine:
                        controller.state.doctorDataState.when(loading: () {
                      return "";
                    }, faild: (_) {
                      return "";
                    }, sucess: (user, list, _) {
                      if (user.gender.isEmpty || user.gender == "Male") {
                        return "Dr.${user.fullName}";
                      } else {
                        return "Dra.${user.fullName}";
                      }
                    }),
                    lastLine:
                        controller.state.doctorDataState.when(loading: () {
                      return "";
                    }, faild: (failed) {
                      return failed.maybeWhen(tokenInvalided: () {
                        closeSession(context: context);
                        return "";
                      }, orElse: () {
                        return "";
                      });
                    }, sucess: (user, list, _) {
                      return "${user.identificationType}${user.identificationNumber}";
                    }),
                    imageProvider:
                        controller.state.doctorDataState.when(loading: () {
                      return AssetImage(Assets.images.logo.path);
                    }, faild: (_) {
                      return AssetImage(Assets.images.logo.path);
                    }, sucess: (user, _, __) {
                      if (user.urlImageProfile != null) {
                        return isValidUrl(user.urlImageProfile)
                            ? NetworkImage(user.urlImageProfile!)
                            : Assets.images.logo.provider();
                      }
                      return AssetImage(Assets.images.logo.path);
                    })),
                controller.state.doctorDataState.when(loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, faild: (failed) {
                  return CardPoint(
                    point: 0,
                    open: () {},
                  );
                }, sucess: (_, doctor, __) {
                  return CardPoint(
                    point: doctor.totalScore,
                    open: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScoredActivityDoctorPage(
                            userID: doctor.user.id,
                            totalScored: doctor.totalScore,
                          ),
                        ),
                      );
                    },
                  );
                }),
                SizedBox(
                  height: 8,
                ),
                const CardSetting(),
                SizedBox(
                  height: 8,
                ),
                const CardHours(),
                SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
