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
import 'package:digimed/app/presentation/pages/home/doctor/home/controller/home_doctor_controller.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home/controller/state/home_doctor_state.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home/view/widget/list_patients_doctor.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDoctor extends StatelessWidget {
  final Doctor doctor;

  const HomeDoctor({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => HomeDoctorController(HomeDoctorState(),
          accountRepository: Repositories.account,
      sessionController: context.read(),
      context: context,
      positionRepository: Repositories.positionService,
      doctor: doctor)
        ..init(),
      child: MyScaffold(
          resizeToAvoidBottomInset: false,
          body: Builder(builder: (fContext) {
            final controller = Provider.of<HomeDoctorController>(
              fContext,
              listen: true,
            );
            return Column(
              children: [
                BannerDigimed(
                    textLeft: "Mis pacientes",
                    iconLeft: DigimedIcon.detail_user,
                    iconRight: Icons.arrow_circle_left_sharp,
                    widgetRight: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          controller.state.associatePatients.when(
                              loading: (){},
                              failed: (){},
                              loaded: (_){
                                return showModalBottomSheet(
                                    context: fContext,
                                    isScrollControlled: true,
                                    useRootNavigator: true,
                                    constraints:
                                    BoxConstraints(maxWidth: size.width * 0.92),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (_) => FormNewPatientSheet(
                                      onFinish: () async {
                                        controller.loadListPatients(
                                            associatePatients:
                                            const AssociateDoctorPatientsLoading());
                                      },idDoctor: doctor.idDoctor,
                                    ));
                              });
                        },
                        icon: Icon(
                          DigimedIcon.add_user,
                          color: AppColors.backgroundColor,
                          size: 18,
                        ),
                      ),
                    ),
                    onClickIconRight: () {},
                    firstLine: "Médico",
                    secondLine:
                    (doctor.user.gender.isEmpty ||
                        doctor.user.gender == "Male" )
                    ?"Dr.${doctor.user.fullName}"
                    :"Dra.${doctor.user.fullName}",
                    lastLine: "estos son tus pacientes",
                    imageProvider: isValidUrl(doctor.user.urlImageProfile)
                        ? NetworkImage(
                        doctor.user.urlImageProfile!)
                        : Assets.images.logo.provider()
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
                const ListPatientsDoctor()
              ],
            );
          })),
    );
  }
}
