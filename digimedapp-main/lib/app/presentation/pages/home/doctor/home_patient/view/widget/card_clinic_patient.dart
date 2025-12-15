import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/data_ok_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/data_ok_dialog_doctor.dart';
import 'package:digimed/app/presentation/global/widgets/data_warning_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/data_warning_doctor_dialog.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_cardio_null.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_lab_data.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/card_lab_null.dart';
import 'package:digimed/app/presentation/pages/new_profile_cardio/patient/view/new_profile_cardio_page.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CardClinicPatient extends StatelessWidget {
  const CardClinicPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          CardDigimed(
            child: controller.state.patientState.when(loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }, failed: (_) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }, loaded: (patient) {
              if (patient.profileCardiovascular != null) {
                return Container(
                  margin: const EdgeInsets.only(
                      right: 24, left: 24, top: 16, bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Perfil cardiovascular",
                            style: AppTextStyle.semiBold18W500ContentTextStyle,
                          ),
                          const Spacer(),
                          Assets.svgs.iconPrsion.svg()
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Presión arterial",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  patient.profileCardiovascular != null &&
                                          patient.profileCardiovascular
                                                  ?.diastolicPressure !=
                                              null &&
                                          patient.profileCardiovascular
                                                  ?.systolicPressure !=
                                              null
                                      ? "${showNumber(patient.profileCardiovascular!.systolicPressure!)} / ${showNumber(patient.profileCardiovascular!.diastolicPressure!)} mmHg"
                                      : "0/0",
                                  style: AppTextStyle
                                      .semiBold17W500ContentTextStyle,
                                )
                              ],
                            ),
                            const Spacer(),
                            !systolicAltered(controller.patients
                                    .profileCardiovascular!.systolicPressure!)
                                ? !diastolicAltered(controller
                                        .patients
                                        .profileCardiovascular!
                                        .diastolicPressure!)
                                    ? IconButton(
                                        icon: Icon(
                                          DigimedIcon.good,
                                          color: AppColors
                                              .backgroundSettingSaveColor,
                                          size: size.width * 0.07,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const DataOkDoctorDialog());
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          DigimedIcon.alert,
                                          color: Colors.amber,
                                          size: size.width * 0.07,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DataWarningDialog(
                                                      title: titleWarningDialog,
                                                      word: "Presión arterial",
                                                      phone:
                                                          "${patient.user.countryCode}${patient.user.phoneNumber}"));
                                        },
                                      )
                                : IconButton(
                                    icon: Icon(
                                      DigimedIcon.alert,
                                      color: Colors.amber,
                                      size: size.width * 0.07,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => DataWarningDialog(
                                              title: titleWarningDialog,
                                              word: "Presión arterial",
                                              phone:
                                                  "${patient.user.countryCode}${patient.user.phoneNumber}"));
                                    },
                                  ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.dividerColor),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Frecuencia cardíaca",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  patient.profileCardiovascular != null &&
                                          patient.profileCardiovascular
                                                  ?.heartFrequency !=
                                              null
                                      ? "${showNumber(patient.profileCardiovascular!.heartFrequency!)} ppm"
                                      : "0 ppm",
                                  style: AppTextStyle
                                      .semiBold17W500ContentTextStyle,
                                )
                              ],
                            ),
                            const Spacer(),
                            !rateAltered(controller.patients
                                    .profileCardiovascular!.heartFrequency!)
                                ? IconButton(
                                    icon: Icon(
                                      DigimedIcon.good,
                                      color:
                                          AppColors.backgroundSettingSaveColor,
                                      size: size.width * 0.07,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const DataOkDoctorDialog());
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      DigimedIcon.alert,
                                      color: Colors.amber,
                                      size: size.width * 0.07,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => DataWarningDialog(
                                              title: titleWarningDialog,
                                              word: "Frecuencia cardíaca",
                                              phone:
                                                  "${patient.user.countryCode}${patient.user.phoneNumber}"));
                                    },
                                  ),
                          ],
                        ),
                      ),
                      const Divider(color: AppColors.dividerColor),
                      Container(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sueño",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  patient.profileCardiovascular != null &&
                                          patient.profileCardiovascular
                                                  ?.sleepingHours !=
                                              null
                                      ? "${showNumber2(patient.profileCardiovascular!.sleepingHours!)} horas"
                                      : "0 horas",
                                  style: AppTextStyle
                                      .semiBold17W500ContentTextStyle,
                                )
                              ],
                            ),
                            const Spacer(),
                            !sleepAltered(controller.patients
                                    .profileCardiovascular!.sleepingHours!)
                                ? IconButton(
                                    icon: Icon(
                                      DigimedIcon.good,
                                      color:
                                          AppColors.backgroundSettingSaveColor,
                                      size: size.width * 0.07,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const DataOkDoctorDialog());
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(
                                      DigimedIcon.alert,
                                      color: Colors.amber,
                                      size: size.width * 0.07,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => DataWarningDialog(
                                              title: titleWarningDialog,
                                              word: "Sueño",
                                              phone:
                                                  "${patient.user.countryCode}${patient.user.phoneNumber}"));
                                    },
                                  ),
                          ],
                        ),
                      ),
                      // HAbilidad de modificar el perfil cardiovascular del paciente por el Medico
                      const Divider(color: AppColors.dividerColor),
                      Container(
                        margin: const EdgeInsets.only(right: 24, left: 24),
                        child: ButtonDigimed(
                            height: 60,
                            child: const Text(
                              "Actualizar",
                              style: AppTextStyle.normalWhiteContentTextStyle,
                            ),
                            onTab: () async {
                              final result =
                                  await PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: NewProfileCardioPage(
                                          id: controller.patients.patientID,
                                          doctorID: controller
                                                      .patients.meDoctorID !=
                                                  null
                                              ? controller.patients.meDoctorID!
                                              : 1),
                                      withNavBar: false);
                              print(result);
                              if (result != null && result as bool) {
                                controller.getDataPatient(
                                    patientState: const PatientState.loading());
                              }
                            }),
                      ),
                      // Aqui acaba la modificacion
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    const CardCardioNull(),
                    Container(
                      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 16),
                      child: ButtonDigimed(
                          height: 60,
                          child: const Text(
                            "Actualizar",
                            style: AppTextStyle.normalWhiteContentTextStyle,
                          ),
                          onTab: () async {
                            final result =
                            await PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: NewProfileCardioPage(
                                    id: controller.patients.patientID,
                                    doctorID: controller
                                        .patients.meDoctorID !=
                                        null
                                        ? controller.patients.meDoctorID!
                                        : 1),
                                withNavBar: false);
                            print(result);
                            if (result != null && result as bool) {
                              controller.getDataPatient(
                                  patientState: const PatientState.loading());
                            }
                          }),
                    )
                  ],
                );
              }
            }),
          ),
          const SizedBox(
            height: 8,
          ),
          CardDigimed(
            child: controller.state.patientState.when(loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }, failed: (_) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }, loaded: (patient) {
              if (patient.profileLaboratory != null) {
                return Container(
                  margin: const EdgeInsets.only(
                      right: 24, left: 24, top: 16, bottom: 16),
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
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              Text(
                                patient.profileLaboratory != null &&
                                        patient.profileLaboratory?.glucose !=
                                            null
                                    ? "${showNumber2(patient.profileLaboratory!.glucose!)} mg/dl"
                                    : "0 mg/dl",
                                style:
                                    AppTextStyle.semiBold17W500ContentTextStyle,
                              )
                            ],
                          ),
                          const Spacer(),
                          !glucemiaAltered(controller
                                  .patients.profileLaboratory!.glucose!)
                              ? IconButton(
                                  icon: Icon(
                                    DigimedIcon.good,
                                    color: AppColors.backgroundSettingSaveColor,
                                    size: size.width * 0.07,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const DataOkDoctorDialog());
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    DigimedIcon.alert,
                                    color: Colors.amber,
                                    size: size.width * 0.07,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => DataWarningDialog(
                                            title: titleWarningDialog,
                                            word: "Glucemia",
                                            phone:
                                                "${patient.user.countryCode}${patient.user.phoneNumber}"));
                                  },
                                ),
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
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              Text(
                                patient.profileLaboratory != null &&
                                        patient.profileLaboratory
                                                ?.triglycerides !=
                                            null
                                    ? "${showNumber2(patient.profileLaboratory!.triglycerides!)} mg/dl"
                                    : "0 mg/dl",
                                style:
                                    AppTextStyle.semiBold17W500ContentTextStyle,
                              )
                            ],
                          ),
                          const Spacer(),
                          !trigliceriosAltered(controller
                                  .patients.profileLaboratory!.triglycerides!)
                              ? IconButton(
                                  icon: Icon(
                                    DigimedIcon.good,
                                    color: AppColors.backgroundSettingSaveColor,
                                    size: size.width * 0.07,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const DataOkDoctorDialog());
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    DigimedIcon.alert,
                                    color: Colors.amber,
                                    size: size.width * 0.07,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => DataWarningDialog(
                                            title: titleWarningDialog,
                                            word: "Triglicéridos",
                                            phone:
                                                "${patient.user.countryCode}${patient.user.phoneNumber}"));
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
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              Text(
                                patient.profileLaboratory != null &&
                                        patient.profileLaboratory
                                                ?.cholesterol !=
                                            null
                                    ? "${showNumber2(patient.profileLaboratory!.cholesterol!)} mg/dl"
                                    : "0 mg/dl",
                                style:
                                    AppTextStyle.semiBold17W500ContentTextStyle,
                              )
                            ],
                          ),
                          const Spacer(),
                          !colesterolAltered(controller
                                  .patients.profileLaboratory!.cholesterol!)
                              ? IconButton(
                                  icon: Icon(
                                    DigimedIcon.good,
                                    color: AppColors.backgroundSettingSaveColor,
                                    size: size.width * 0.07,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const DataOkDoctorDialog());
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    DigimedIcon.alert,
                                    color: Colors.amber,
                                    size: size.width * 0.07,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => DataWarningDialog(
                                            title: titleWarningDialog,
                                            word: "Colesterol",
                                            phone:
                                                "${patient.user.countryCode}${patient.user.phoneNumber}"));
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
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              Text(
                                patient.profileLaboratory != null &&
                                        patient.profileLaboratory?.hemoglobin !=
                                            null
                                    ? "${showNumber2(patient.profileLaboratory!.hemoglobin!)} g/dL"
                                    : "0 g/dL",
                                style:
                                    AppTextStyle.semiBold17W500ContentTextStyle,
                              )
                            ],
                          ),
                          const Spacer(),
                          !hemoglobinaAltered(
                                  controller
                                      .patients.profileLaboratory!.hemoglobin!,
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
                                        builder: (context) =>
                                            const DataOkDoctorDialog());
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    DigimedIcon.alert,
                                    color: Colors.amber,
                                    size: size.width * 0.07,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => DataWarningDialog(
                                            title: titleWarningDialog,
                                            word: "Hemoglobina",
                                            phone:
                                                "${patient.user.countryCode}${patient.user.phoneNumber}"));
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
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              Text(
                                "${showNumber2(controller.patients.profileLaboratory!.uricAcid ?? 0)} mg/dL",
                                style:
                                    AppTextStyle.semiBold17W500ContentTextStyle,
                              )
                            ],
                          ),
                          const Spacer(),
                          !acidoUricoAltered(
                                  controller.patients.profileLaboratory!
                                          .uricAcid ??
                                      0,
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
                                        builder: (context) =>
                                            const DataOkDialog());
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    DigimedIcon.alert,
                                    color: Colors.amber,
                                    size: size.width * 0.07,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => DataWarningDialog(
                                            title: titleWarningDialog,
                                            word: "Ácido úrico",
                                            phone:
                                                "${patient.user.countryCode}${patient.user.phoneNumber}"));
                                  },
                                ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const CardLabNull();
              }
            }),
          ),
          const SizedBox(
            height: 8,
          ),
          ButtonDigimed(
              height: 60,
              child: const Text(
                "Ver historial",
                style: AppTextStyle.normalWhiteContentTextStyle,
              ),
              onTab: () {
                logger.i("Ver historial del paciente 2 ${controller.fatherPatient.patientID}");
                pushNewPageAdminToHistoricPatient(
                    context, controller.fatherPatient.patientID);
              }),
          const SizedBox(
            height: 8,
          ),
          ButtonDigimed(
              height: 60,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Contactar paciente",
                    style: AppTextStyle.normalWhiteContentTextStyle,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Icon(
                    DigimedIcon.whatsapp,
                    color: Colors.white,
                  )
                ],
              ),
              onTab: () {
                launchWhatsapp(
                    "${controller.patients.user.countryCode}${controller.patients.user.phoneNumber}",
                    "");
              }),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
