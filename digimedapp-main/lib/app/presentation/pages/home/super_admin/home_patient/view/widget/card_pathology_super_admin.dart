import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardPathologyDataSuperAdmin extends StatelessWidget {
  const CardPathologyDataSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                child: Text(
                  "Patologías de base",
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.normal16W500ContentTextStyle,
                ),
              ),
              IconButton(
                icon: const Icon(
                  DigimedIcon.edit,
                  color: AppColors.backgroundColor,
                  size: 22,
                ),
                onPressed: () {
                  controller.changedSettingState();
                },
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                "Cardiovasculares",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ? controller.pathologyDataTemp["cardioTemp"] != null
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                      : AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: controller.patients.medicalHistory != null
                          ? controller.pathologyDataTemp["cardioTemp"] != null
                              ? controller.pathologyDataTemp["cardioTemp"]!
                                  ? Text(
                                      "Si",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                                  : Text(
                                      "No",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                              : Text(
                                  "N/D",
                                  style: AppTextStyle.boldContentTextStyle,
                                )
                          : Text(
                              "N/D",
                              style: AppTextStyle.boldContentTextStyle,
                            )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Cáncer",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ? controller.pathologyDataTemp["cancerTemp"] != null
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                      : AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: controller.patients.medicalHistory != null
                          ? controller.pathologyDataTemp["cancerTemp"] != null
                              ? controller.pathologyDataTemp["cancerTemp"]!
                                  ? Text(
                                      "Si",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                                  : Text(
                                      "No",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                              : Text(
                                  "N/D",
                                  style: AppTextStyle.boldContentTextStyle,
                                )
                          : Text(
                              "N/D",
                              style: AppTextStyle.boldContentTextStyle,
                            )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Diábetes",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ? controller.pathologyDataTemp["diabeticTemp"] != null
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                      : AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: controller.patients.medicalHistory != null
                          ? controller.pathologyDataTemp["diabeticTemp"] != null
                              ? controller.pathologyDataTemp["diabeticTemp"]!
                                  ? Text(
                                      "Si",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                                  : Text(
                                      "No",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                              : Text(
                                  "N/D",
                                  style: AppTextStyle.boldContentTextStyle,
                                )
                          : Text(
                              "N/D",
                              style: AppTextStyle.boldContentTextStyle,
                            )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Obesidad",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ? controller.pathologyDataTemp["obesyTemp"] != null
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                      : AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: controller.patients.medicalHistory != null
                          ? controller.pathologyDataTemp["obesyTemp"] != null
                              ? controller.pathologyDataTemp["obesyTemp"]!
                                  ? Text(
                                      "Si",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                                  : Text(
                                      "No",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                              : Text(
                                  "N/D",
                                  style: AppTextStyle.boldContentTextStyle,
                                )
                          : Text(
                              "N/D",
                              style: AppTextStyle.boldContentTextStyle,
                            )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Respiratorios",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ? controller.pathologyDataTemp["respTemp"] != null
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                      : AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: controller.patients.medicalHistory != null
                          ? controller.pathologyDataTemp["respTemp"] != null
                              ? controller.pathologyDataTemp["respTemp"]!
                                  ? Text(
                                      "Si",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                                  : Text(
                                      "No",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                              : Text(
                                  "N/D",
                                  style: AppTextStyle.boldContentTextStyle,
                                )
                          : Text(
                              "N/D",
                              style: AppTextStyle.boldContentTextStyle,
                            )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Mentales",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ? controller.pathologyDataTemp["mentalTemp"] != null
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                      : AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: controller.patients.medicalHistory != null
                          ? controller.pathologyDataTemp["mentalTemp"] != null
                              ? controller.pathologyDataTemp["mentalTemp"]!
                                  ? Text(
                                      "Si",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                                  : Text(
                                      "No",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                              : Text(
                                  "N/D",
                                  style: AppTextStyle.boldContentTextStyle,
                                )
                          : Text(
                              "N/D",
                              style: AppTextStyle.boldContentTextStyle,
                            )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Gripes frecuentes",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ? controller.pathologyDataTemp["fluxTemp"] != null
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                      : AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: controller.patients.medicalHistory != null
                          ? controller.pathologyDataTemp["fluxTemp"] != null
                              ? controller.pathologyDataTemp["fluxTemp"]!
                                  ? Text(
                                      "Si",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                                  : Text(
                                      "No",
                                      style: AppTextStyle
                                          .boldWhiteContentTextStyle,
                                    )
                              : Text(
                                  "N/D",
                                  style: AppTextStyle.boldContentTextStyle,
                                )
                          : Text(
                              "N/D",
                              style: AppTextStyle.boldContentTextStyle,
                            )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
