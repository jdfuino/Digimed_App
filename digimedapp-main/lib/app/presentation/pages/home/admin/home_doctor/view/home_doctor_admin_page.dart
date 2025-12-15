import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/form_new_doctor.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_patient/view/form_new_patient_sheet.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_doctor/controller/home_doctor_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_doctor/controller/state/home_doctor_admin_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_doctor/view/widget/list_patients.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDoctorAdminPage extends StatelessWidget {
  final int doctorId;
  final Doctor doctor;

  const HomeDoctorAdminPage(
      {super.key, required this.doctorId, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => HomeDoctorAdminController(
          HomeDoctorAdminState(),
          sessionController: context.read(),
          accountRepository: Repositories.account,
      doctor: doctor)
        ..init(),
      child: Builder(
          builder: (context) {
            final controller = Provider.of<HomeDoctorAdminController>(
              context,
              listen: true,
            );
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
                        builder: (_) => FormNewPatientSheet(onFinish: (){
                          controller.loadListPatients(
                              associatePatients: AssociatePatients.loading());
                        }, idDoctor: doctor.idDoctor,));
                  },
                  backgroundColor: AppColors.backgroundColor,
                  child: const Icon(DigimedIcon.add_user),
                ),
                body:Column(
                  children: [
                    BannerDigimed(
                        textLeft: "Pacientes",
                        iconLeft: DigimedIcon.detail_user,
                        iconRight: DigimedIcon.back,
                        onClickIconRight: () {
                          Navigator.of(context).pop();
                        },
                        firstLine: "Médico",
                        secondLine:
                        (doctor.user.gender.isEmpty ||
                            doctor.user.gender == "Male" )
                        ?"Dr. ${doctor.user.fullName}"
                        :"Dra. ${doctor.user.fullName}",
                        lastLine:
                        "${doctor.user.identificationType}. ${doctor.user.identificationNumber}",
                        imageProvider: isValidUrl(doctor.user.urlImageProfile)
                           ?NetworkImage(doctor.user.urlImageProfile!)
                            :Assets.images.logo.provider()
                    ),
                    controller.state.associatePatients.when(loading: () {
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
                    const ListPatients()
                  ],
                )
            );
          }
      ),
    );
  }
}
