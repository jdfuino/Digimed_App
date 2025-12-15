import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/state/home_patient_super_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardFamilySettingSuperAdmin extends StatelessWidget {
  const CardFamilySettingSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: const Text(
                  "Antecedentes familiares",
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.normal16W500ContentTextStyle,
                ),
              ),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: AppColors.backgroundSettingSaveColor),
                icon: const Icon(
                  DigimedIcon.save,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  "Guardar",
                  style: AppTextStyle.normalTextStyle,
                ),
                onPressed: () async {
                  final result = await controller.checkFamilyData();
                  result.when(left: (failure) {
                    failure.when(
                        notFound: () => showToast("Datos no encontrado"),
                        network: () =>
                            showToast("No hay conexion con Internet"),
                        unauthorized: () => showToast(
                            "No estas autorizado para realizar esta accion"),
                        tokenInvalided: () {
                          showToast("Sesion expirada");
                          controller.sessionController.globalCloseSession();
                        },
                        unknown: () => showToast("Hemos tenido un problema"),
                        emailExist: () => showToast("Email ya registrado"),
                        formData: (String message) {
                          showToast(message);
                        });
                  }, right: (value) async {
                    showToast("Proceso completado correctamente.");
                    await controller.getDataPatient(
                        patientState: const PatientStateLoading());
                    controller.state = controller.state
                        .copyWith(isSettingDataFamilyHistoric: false);
                  });
                },
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                "Cardiovasculares",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["0"] == null ||
                        !controller.familyDataTemp["0"]!) {
                      controller.onChangedDatePathology("0", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: controller.familyDataTemp["0"] != null
                          ? controller.familyDataTemp["0"]!
                              ? AppColors.backgroundColor
                              : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child: Text("Si",
                              style: controller.familyDataTemp["0"] != null
                                  ? controller.familyDataTemp["0"]!
                                      ? AppTextStyle.boldWhiteContentTextStyle
                                      : AppTextStyle.boldContentTextStyle
                                  : AppTextStyle.boldContentTextStyle))),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["0"] == null ||
                        controller.familyDataTemp["0"]!) {
                      controller.onChangedDatePathology("0", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: controller.familyDataTemp["0"] != null
                        ? controller.familyDataTemp["0"]!
                            ? AppColors.buttonDisableBackgroundColor
                            : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child: Text("No",
                            style: controller.familyDataTemp["0"] != null
                                ? controller.familyDataTemp["0"]!
                                    ? AppTextStyle.boldContentTextStyle
                                    : AppTextStyle.boldWhiteContentTextStyle
                                : AppTextStyle.boldContentTextStyle)),
                  ),
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
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["1"] == null ||
                        !controller.familyDataTemp["1"]!) {
                      controller.onChangedDatePathology("1", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: controller.familyDataTemp["1"] != null
                          ? controller.familyDataTemp["1"]!
                              ? AppColors.backgroundColor
                              : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child: Text("Si",
                              style: controller.familyDataTemp["1"] != null
                                  ? controller.familyDataTemp["1"]!
                                      ? AppTextStyle.boldWhiteContentTextStyle
                                      : AppTextStyle.boldContentTextStyle
                                  : AppTextStyle.boldContentTextStyle))),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["1"] == null ||
                        controller.familyDataTemp["1"]!) {
                      controller.onChangedDatePathology("1", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: controller.familyDataTemp["1"] != null
                        ? controller.familyDataTemp["1"]!
                            ? AppColors.buttonDisableBackgroundColor
                            : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child: Text("No",
                            style: controller.familyDataTemp["1"] != null
                                ? controller.familyDataTemp["1"]!
                                    ? AppTextStyle.boldContentTextStyle
                                    : AppTextStyle.boldWhiteContentTextStyle
                                : AppTextStyle.boldContentTextStyle)),
                  ),
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
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["2"] == null ||
                        !controller.familyDataTemp["2"]!) {
                      controller.onChangedDatePathology("2", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: controller.familyDataTemp["2"] != null
                          ? controller.familyDataTemp["2"]!
                              ? AppColors.backgroundColor
                              : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child: Text("Si",
                              style: controller.familyDataTemp["2"] != null
                                  ? controller.familyDataTemp["2"]!
                                      ? AppTextStyle.boldWhiteContentTextStyle
                                      : AppTextStyle.boldContentTextStyle
                                  : AppTextStyle.boldContentTextStyle))),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["2"] == null ||
                        controller.familyDataTemp["2"]!) {
                      controller.onChangedDatePathology("2", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: controller.familyDataTemp["2"] != null
                        ? controller.familyDataTemp["2"]!
                            ? AppColors.buttonDisableBackgroundColor
                            : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child: Text("No",
                            style: controller.familyDataTemp["2"] != null
                                ? controller.familyDataTemp["2"]!
                                    ? AppTextStyle.boldContentTextStyle
                                    : AppTextStyle.boldWhiteContentTextStyle
                                : AppTextStyle.boldContentTextStyle)),
                  ),
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
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["3"] == null ||
                        !controller.familyDataTemp["3"]!) {
                      controller.onChangedDatePathology("3", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: controller.familyDataTemp["3"] != null
                          ? controller.familyDataTemp["3"]!
                              ? AppColors.backgroundColor
                              : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child: Text("Si",
                              style: controller.familyDataTemp["3"] != null
                                  ? controller.familyDataTemp["3"]!
                                      ? AppTextStyle.boldWhiteContentTextStyle
                                      : AppTextStyle.boldContentTextStyle
                                  : AppTextStyle.boldContentTextStyle))),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["3"] == null ||
                        controller.familyDataTemp["3"]!) {
                      controller.onChangedDatePathology("3", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: controller.familyDataTemp["3"] != null
                        ? controller.familyDataTemp["3"]!
                            ? AppColors.buttonDisableBackgroundColor
                            : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child: Text("No",
                            style: controller.familyDataTemp["3"] != null
                                ? controller.familyDataTemp["3"]!
                                    ? AppTextStyle.boldContentTextStyle
                                    : AppTextStyle.boldWhiteContentTextStyle
                                : AppTextStyle.boldContentTextStyle)),
                  ),
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
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["4"] == null ||
                        !controller.familyDataTemp["4"]!) {
                      controller.onChangedDatePathology("4", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: controller.familyDataTemp["4"] != null
                          ? controller.familyDataTemp["4"]!
                              ? AppColors.backgroundColor
                              : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child: Text("Si",
                              style: controller.familyDataTemp["4"] != null
                                  ? controller.familyDataTemp["4"]!
                                      ? AppTextStyle.boldWhiteContentTextStyle
                                      : AppTextStyle.boldContentTextStyle
                                  : AppTextStyle.boldContentTextStyle))),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["4"] == null ||
                        controller.familyDataTemp["4"]!) {
                      controller.onChangedDatePathology("4", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: controller.familyDataTemp["4"] != null
                        ? controller.familyDataTemp["4"]!
                            ? AppColors.buttonDisableBackgroundColor
                            : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child: Text("No",
                            style: controller.familyDataTemp["4"] != null
                                ? controller.familyDataTemp["4"]!
                                    ? AppTextStyle.boldContentTextStyle
                                    : AppTextStyle.boldWhiteContentTextStyle
                                : AppTextStyle.boldContentTextStyle)),
                  ),
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
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["5"] == null ||
                        !controller.familyDataTemp["5"]!) {
                      controller.onChangedDatePathology("5", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: controller.familyDataTemp["5"] != null
                          ? controller.familyDataTemp["5"]!
                              ? AppColors.backgroundColor
                              : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child: Text("Si",
                              style: controller.familyDataTemp["5"] != null
                                  ? controller.familyDataTemp["5"]!
                                      ? AppTextStyle.boldWhiteContentTextStyle
                                      : AppTextStyle.boldContentTextStyle
                                  : AppTextStyle.boldContentTextStyle))),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.familyDataTemp["5"] == null ||
                        controller.familyDataTemp["5"]!) {
                      controller.onChangedDatePathology("5", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: controller.familyDataTemp["5"] != null
                        ? controller.familyDataTemp["5"]!
                            ? AppColors.buttonDisableBackgroundColor
                            : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child: Text("No",
                            style: controller.familyDataTemp["5"] != null
                                ? controller.familyDataTemp["5"]!
                                    ? AppTextStyle.boldContentTextStyle
                                    : AppTextStyle.boldWhiteContentTextStyle
                                : AppTextStyle.boldContentTextStyle)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
