import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/data_ok_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/data_ok_dialog_doctor.dart';
import 'package:digimed/app/presentation/global/widgets/data_warning_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/data_warning_doctor_dialog.dart';
import 'package:digimed/app/presentation/pages/home/patient/controller/home_patient_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardCardioData extends StatelessWidget {
  const CardCardioData({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Perfil cardiovascular",
                style: AppTextStyle.semiBold18W500ContentTextStyle,
              ),
              Spacer(),
              Assets.svgs.iconPrsion.svg()
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Presión arterial",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    "${showNumber(controller.patients.profileCardiovascular!.systolicPressure!)} / ${showNumber(controller.patients.profileCardiovascular!.diastolicPressure!)} mmHg",
                    style: AppTextStyle.semiBold17W500ContentTextStyle,
                  )
                ],
              ),
              Spacer(),
              !systolicAltered(controller
                      .patients.profileCardiovascular!.systolicPressure!)
                  ? !diastolicAltered(controller
                          .patients.profileCardiovascular!.diastolicPressure!)
                      ? IconButton(
                        icon: Icon(
                          DigimedIcon.good,
                          color: AppColors.backgroundSettingSaveColor,
                          size: size.width * 0.07,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => DataOkDialog());
                        },
                      )
                      : IconButton(
                        icon: Icon(
                          DigimedIcon.alert,
                          color: Colors.amber,
                          size: size.width * 0.07,
                        ),
                        onPressed: () {
                          if (controller.patients.doctorCountryCode !=
                                  null &&
                              controller.patients.doctorPhoneNumber !=
                                  null) {
                            showDialog(
                                context: context,
                                builder: (context) => DataWarningDoctorDialog(
                                    title: titleWarningDialog,
                                    word: "Presión arterial",
                                    phone:
                                        "${controller.patients.doctorCountryCode}${controller.patients.doctorPhoneNumber}"));
                          }
                        },
                      )
                  : IconButton(
                    icon: Icon(
                      DigimedIcon.alert,
                      color: Colors.amber,
                      size: size.width * 0.07,
                    ),
                    onPressed: () {
                      if (controller.patients.doctorCountryCode != null &&
                          controller.patients.doctorPhoneNumber != null) {
                        showDialog(
                            context: context,
                            builder: (context) => DataWarningDoctorDialog(
                                title: titleWarningDialog,
                                word: "Presión arterial",
                                phone:
                                    "${controller.patients.doctorCountryCode}${controller.patients.doctorPhoneNumber}"));
                      }
                    },
                  )
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Frecuencia cardíaca",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    "${showNumber(controller.patients.profileCardiovascular!.heartFrequency!)} ppm",
                    style: AppTextStyle.semiBold17W500ContentTextStyle,
                  )
                ],
              ),
              Spacer(),
              !rateAltered(controller
                      .patients.profileCardiovascular!.heartFrequency!)
                  ? IconButton(
                    icon: Icon(
                      DigimedIcon.good,
                      color: AppColors.backgroundSettingSaveColor,
                      size: size.width * 0.07,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => DataOkDialog());
                    },
                  )
                  : IconButton(
                    icon: Icon(
                      DigimedIcon.alert,
                      color: Colors.amber,
                      size: size.width * 0.07,
                    ),
                    onPressed: () {
                      if (controller.patients.doctorCountryCode != null &&
                          controller.patients.doctorPhoneNumber != null) {
                        showDialog(
                            context: context,
                            builder: (context) => DataWarningDoctorDialog(
                                title: titleWarningDialog,
                                word: "Frecuencia cardíaca",
                                phone:
                                    "${controller.patients.doctorCountryCode}${controller.patients.doctorPhoneNumber}"));
                      }
                    },
                  ),
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sueño",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    "${showNumber2(controller.patients.profileCardiovascular!.sleepingHours!)} horas",
                    style: AppTextStyle.semiBold17W500ContentTextStyle,
                  )
                ],
              ),
              Spacer(),
              !sleepAltered(controller
                      .patients.profileCardiovascular!.sleepingHours!)
                  ? IconButton(
                    icon: Icon(
                      DigimedIcon.good,
                      color: AppColors.backgroundSettingSaveColor,
                      size: size.width * 0.07,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => DataOkDialog());
                    },
                  )
                  : IconButton(
                    icon: Icon(
                      DigimedIcon.alert,
                      color: Colors.amber,
                      size: size.width * 0.07,
                    ),
                    onPressed: () {
                      if (controller.patients.doctorCountryCode != null &&
                          controller.patients.doctorPhoneNumber != null) {
                        showDialog(
                            context: context,
                            builder: (context) => DataWarningDoctorDialog(
                                title: titleWarningDialog,
                                word: "Sueño",
                                phone:
                                    "${controller.patients.doctorCountryCode}${controller.patients.doctorPhoneNumber}"));
                      }
                    },
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
