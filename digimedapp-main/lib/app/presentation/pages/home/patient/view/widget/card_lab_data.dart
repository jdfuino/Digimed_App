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

class CardLabData extends StatelessWidget {
  const CardLabData({super.key});

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
              const Text(
                "Perfil de laboratorio",
                style: AppTextStyle.semiBold18W500ContentTextStyle,
              ),
              const Spacer(),
              Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: Assets.svgs.iconSangre.svg())
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Glucemia",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    "${showNumber2(controller.patients.profileLaboratory!.glucose)} mg/dL",
                    style: AppTextStyle.semiBold17W500ContentTextStyle,
                  )
                ],
              ),
              const Spacer(),
              !glucemiaAltered(controller.patients.profileLaboratory!.glucose!)
                  ? IconButton(
                      icon: Icon(
                        DigimedIcon.good,
                        color: AppColors.backgroundSettingSaveColor,
                        size: size.width * 0.07,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const DataOkDialog());
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
                                  word: "Glucemia",
                                  phone:
                                      "${controller.patients.doctorCountryCode}${controller.patients.doctorPhoneNumber}"));
                        }
                      },
                    )
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Triglicéridos",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    "${showNumber2(controller.patients.profileLaboratory!.triglycerides)}  mg/dL",
                    style: AppTextStyle.semiBold17W500ContentTextStyle,
                  )
                ],
              ),
              const Spacer(),
              !trigliceriosAltered(
                      controller.patients.profileLaboratory!.triglycerides!)
                  ? IconButton(
                      icon: Icon(
                        DigimedIcon.good,
                        color: AppColors.backgroundSettingSaveColor,
                        size: size.width * 0.07,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const DataOkDialog());
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
                                  word: "Triglicéridos",
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
                  const Text(
                    "Colesterol No-HDL",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    "${showNumber2(controller.patients.profileLaboratory!.cholesterol)} mg/dL",
                    style: AppTextStyle.semiBold17W500ContentTextStyle,
                  )
                ],
              ),
              const Spacer(),
              !colesterolAltered(
                      controller.patients.profileLaboratory!.cholesterol!)
                  ? IconButton(
                      icon: Icon(
                        DigimedIcon.good,
                        color: AppColors.backgroundSettingSaveColor,
                        size: size.width * 0.07,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const DataOkDialog());
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
                                  word: "Colesterol",
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
                  const Text(
                    "Hemoglobina (g/dL)",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    "${showNumber2(controller.patients.profileLaboratory!.hemoglobin)} g/dL",
                    style: AppTextStyle.semiBold17W500ContentTextStyle,
                  )
                ],
              ),
              const Spacer(),
              !hemoglobinaAltered(
                      controller.patients.profileLaboratory!.hemoglobin,
                      controller.patients.user.gender)
                  ? IconButton(
                      icon: Icon(
                        DigimedIcon.good,
                        color: AppColors.backgroundSettingSaveColor,
                        size: size.width * 0.07,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const DataOkDialog());
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
                                  word: "Hemoglobina",
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
                  const Text(
                    "Ácido úrico (mg/dL)",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    "${showNumber2(controller.patients.profileLaboratory!.uricAcid ?? 0)} mg/dL",
                    style: AppTextStyle.semiBold17W500ContentTextStyle,
                  )
                ],
              ),
              const Spacer(),
              !acidoUricoAltered(
                      controller.patients.profileLaboratory!.uricAcid ?? 0,
                      controller.patients.user.gender)
                  ? IconButton(
                      icon: Icon(
                        DigimedIcon.good,
                        color: AppColors.backgroundSettingSaveColor,
                        size: size.width * 0.07,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const DataOkDialog());
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
                                  word: "Ácido úrico",
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
