import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/contact_doctor/patient/view/contact_doctor_patient_page.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/controller/info_patient_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CardInfoDoctor extends StatelessWidget {
  const CardInfoDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
      child: CardDigimed(
          child: controller.state.dataDoctorState.when(loading: () {
            return Container(
              height: 70,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }, failed: () {
            return Container();
          }, loaded: (doctor) {
            return Container(
              margin: const EdgeInsets.only(
                  right: 24, left: 24, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.backgroundColor,
                                radius: 5,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              const Text(
                                "Tu doctor",
                                style: AppTextStyle.normalContentTextStyle,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 140,
                            child: Text(
                              (doctor!.user.gender.isEmpty ||
                                  doctor.user.gender == "Male" )
                                  ?"Dr.${doctor.user.fullName}"
                                  :"Dra.${doctor.user.fullName}"
                              ,
                              style: AppTextStyle.boldContentTextStyle,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 140,
                            child: Text(
                              doctor.user.occupation,
                              style: AppTextStyle.sub17W400NormalContentTextStyle,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: AppColors.backgroundColor,
                        radius: size.width * 0.12,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: (size.width * 0.12) - 3,
                          child: CircleAvatar(
                            radius: (size.width * 0.12) - 6,
                            backgroundImage: isValidUrl(doctor.user.urlImageProfile)
                                ? NetworkImage(
                                    doctor.user.urlImageProfile!)
                                : Assets.images.logo.provider(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Divider(),
                  Text(
                    "Horario de atención",
                    style: AppTextStyle.subNormalContentTextStyle,
                  ),
                  Row(
                    children: [
                      Icon(
                        DigimedIcon.clock,
                        size: 19,
                        color: AppColors.backgroundColor,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextButton(
                          onPressed: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen:
                                    ContactDoctorPatientPage(myDoctor: doctor),
                                withNavBar: false);
                          },
                          child: Text(
                            "Más información",
                            style: AppTextStyle.normalBlue16W500TextStyle,
                          )),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen:
                                    ContactDoctorPatientPage(myDoctor: doctor),
                                withNavBar: false);
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.backgroundColor,
                          ))
                    ],
                  )
                ],
              ),
            );
          })),
    );
  }
}
