import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_point/card_point.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/patient/controller/home_patient_controller.dart';
import 'package:digimed/app/presentation/pages/home/patient/controller/state/home_patient_state.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_cardio_patient.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_lab_patient.dart';
import 'package:digimed/app/presentation/pages/inbox/patient/view/inbox_page.dart';
import 'package:digimed/app/presentation/pages/scored_activity/patient/page/scored_activity_page.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as badges;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomePatient extends StatelessWidget {
  Patients patients;

  HomePatient({super.key, required this.patients});

  @override
  Widget build(BuildContext context) {
    logger.i("HomePatient build");
    return ChangeNotifierProvider(
        create: (_) => HomePatientController(HomePatientState(),
            accountRepository: Repositories.account,
            sessionController: context.read(),
            context: context,
            positionRepository: Repositories.positionService,
            patients: patients)
          ..init(),
        child: MyScaffold(
          body: Builder(
            builder: (context) {
              final controller = Provider.of<HomePatientController>(
                context,
                listen: true,
              );
              final int unreadNotifications = getCountUnreadNotification(
                  controller.sessionController.state!.notifications);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    BannerDigimed(
                        textLeft: "Estado clínico",
                        iconLeft: DigimedIcon.detail_user,
                        iconRight: DigimedIcon.whatsapp,
                        widgetRight: badges.Badge(
                          label: Text(
                            unreadNotifications.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          child: IconButton(
                            onPressed: () {
                              //Nevegar a la pantalla de inbox
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: const InboxPage(), withNavBar: false);
                            },
                            icon: const Icon(
                              Icons.notifications,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onClickIconRight: () {},
                        firstLine: "Hola,",
                        secondLine: "${patients.user.fullName}",
                        lastLine: "este es tu perfil de salud",
                        imageProvider: isValidUrl(patients.user.urlImageProfile)
                            ? NetworkImage(patients.user.urlImageProfile!)
                            : Assets.images.logo.provider()),
                    controller.state.associatePatients.when(loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }, failed: () {
                      return CardPoint(point: 0, open: () {});
                    }, loaded: (_) {
                      return CardPoint(
                          point: controller.patients.totalScore != null
                              ? controller.patients.totalScore!
                              : 0,
                          open: () async {
                            final result =
                                await PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: ScoredActivityPage(
                                        userID: controller.patients.user.id,
                                        totalScored: controller
                                                    .patients.totalScore !=
                                                null
                                            ? controller.patients.totalScore!
                                            : 0),
                                    withNavBar: false);
                          });
                    }),
                    const CardCardioPatient(),
                    const CardLabPatient(),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
