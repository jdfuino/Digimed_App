import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_doctor/controller/home_doctor_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_doctor/controller/state/home_doctor_super_admin_state.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_doctor/view/widget/list_patients_super_admin.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDoctorSuperAdminPage extends StatelessWidget {
  final int doctorId;
  final Doctor doctor;

  const HomeDoctorSuperAdminPage(
      {super.key, required this.doctorId, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => HomeDoctorSuperAdminController(HomeDoctorSuperAdminState(),
          sessionController: context.read(),
          accountRepository: Repositories.account,
          doctor: doctor)
        ..init(),
      child: Builder(builder: (context) {
        final controller = Provider.of<HomeDoctorSuperAdminController>(
          context,
          listen: true,
        );
        return MyScaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                BannerDigimed(
                    textLeft: "Pacientes",
                    iconLeft: DigimedIcon.detail_user,
                    iconRight: DigimedIcon.back,
                    onClickIconRight: () {
                      Navigator.of(context).pop();
                    },
                    firstLine: "Médico",
                    secondLine: (doctor.user.gender.isEmpty ||
                            doctor.user.gender == "Male")
                        ? "Dr. ${doctor.user.fullName}"
                        : "Dra. ${doctor.user.fullName}",
                    lastLine:
                        "${doctor.user.identificationType}. ${doctor.user.identificationNumber}",
                    imageProvider: isValidUrl(doctor.user.urlImageProfile)
                        ? NetworkImage(doctor.user.urlImageProfile!)
                        : Assets.images.logo.provider()),
                controller.state.associatePatientState.when(loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, failed: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, loaded: (list) {
                  return Center(
                      child: Text(
                    "Pacientes asignados: ${list != null ? list.length : 0}",
                    style: AppTextStyle.normalTextStyle2,
                  ));
                }),
                const ListPatientSuperAdmin()
              ],
            ));
      }),
    );
  }
}
