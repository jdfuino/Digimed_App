import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_point/card_point.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/info_doctor/doctor/controller/info_doctor_controller.dart';
import 'package:digimed/app/presentation/pages/info_doctor/doctor/controller/state/info_doctor_state.dart';
import 'package:digimed/app/presentation/pages/info_doctor/doctor/view/widget/card_hour_doctor.dart';
import 'package:digimed/app/presentation/pages/info_doctor/doctor/view/widget/card_setting_doctor.dart';
import 'package:digimed/app/presentation/pages/scored_activity/doctor/page/scored_activity_patient_page.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class InfoDoctor extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback close;
  final Function(int) goToResumeHours;

  const InfoDoctor(
      {super.key,
      required this.doctor,
      required this.close,
      required this.goToResumeHours});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => InfoDoctorController(
          InfoDoctorState(
              myDoctorDataState: MyDoctorDataState.sucess(
                  user: doctor.user, list: doctor.hours)),
          accountRepository: Repositories.account,
          fatherId: doctor.user.id,
          sessionController: context.read(),
          authenticationRepository: Repositories.authentication)
        ..init(),
      child: MyScaffold(
        body: Builder(builder: (context) {
          final controller = Provider.of<InfoDoctorController>(
            context,
            listen: true,
          );
          return SingleChildScrollView(
            child: Column(
              children: [
                BannerDigimed(
                    textLeft: "Mi perfil",
                    iconLeft: DigimedIcon.user,
                    iconRight: DigimedIcon.exit,
                    onClickIconRight: () {
                      controller.authenticationRepository.signOut();
                      controller.sessionController.signOut();
                      close();
                    },
                    firstLine: "Médico",
                    secondLine:
                        controller.state.myDoctorDataState.when(loading: () {
                      return "";
                    }, faild: (_) {
                      return "";
                    }, sucess: (user, list) {
                          if(user.gender.isEmpty || user.gender == "Male" ){
                            return "Dr.${user.fullName}";
                          }else{
                            return "Dra.${user.fullName}";
                          }
                    }),
                    lastLine:
                        controller.state.myDoctorDataState.when(loading: () {
                      return "";
                    }, faild: (_) {
                      return "";
                    }, sucess: (user, list) {
                      return "${user.identificationType}${user.identificationNumber}";
                    }),
                    imageProvider:
                        controller.state.myDoctorDataState.when(loading: () {
                      return AssetImage(Assets.images.logo.path);
                    }, faild: (_) {
                      return AssetImage(Assets.images.logo.path);
                    }, sucess: (user, _) {
                      if (user.urlImageProfile != null) {
                        return isValidUrl(user.urlImageProfile)
                            ? NetworkImage(user.urlImageProfile!)
                            : Assets.images.logo.provider();
                      }
                      return AssetImage(Assets.images.logo.path);
                    })),
                 CardPoint(
                  point: doctor.totalScore ?? 0,open: () async{
                   final result =
                       await PersistentNavBarNavigator.pushNewScreen(
                       context,
                       screen: ScoredActivityDoctorPage(
                           userID: doctor.user.id,
                           totalScored: doctor.totalScore !=
                               null
                               ? doctor.totalScore!
                               : 0),
                       withNavBar: false);
                 }
                ),
                const SizedBox(
                  height: 8,
                ),
                const CardSettingDoctor(),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                    onTap: ()async {
                      goToResumeHours(doctor.user.id);
                      // final result = await PersistentNavBarNavigator.pushNewScreen(
                      //     context,
                      //     screen: ResumeHoursPage(id: doctor.user.id,),
                      //     withNavBar: false
                      // );
                      // await controller.getDataDoctor(myDoctorDataState:
                      // const MyDoctorDataStateLoading());
                    },
                    child: const CardHourDoctor()),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 24, left: 24),
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      launchWhatsapp("${doctor.user.countryCode}${doctor.user.phoneNumber}", "");
                    },
                    child: const CardDigimed(
                      color: AppColors.contactColor,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "¿Necesitas ayuda?",
                                    style: AppTextStyle
                                        .normalWhiteContentTextStyle,
                                  ),
                                  Text(
                                    "Contacta a Digimed",
                                    style:
                                        AppTextStyle.boldWhiteContentTextStyle,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 32,
                              ),
                              Icon(
                                DigimedIcon.whatsapp,
                                color: Colors.white,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
