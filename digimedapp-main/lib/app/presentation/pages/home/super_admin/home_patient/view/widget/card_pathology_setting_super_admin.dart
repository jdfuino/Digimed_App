import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/state/home_patient_super_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardPathologySettingSuperAdmin extends StatelessWidget {
  const CardPathologySettingSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                child: Text(
                  "Patologías de base",
                  style: AppTextStyle.normal16W500ContentTextStyle,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
                  final result = await controller.checkPathologyData();
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
                        .copyWith(isSettingDataPathology: false);
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
                    if (controller.pathologyDataTemp["cardioTemp"] == null ||
                        !controller.pathologyDataTemp["cardioTemp"]!) {
                      controller.onChangedDatePathology("cardioTemp", true);
                    }
                  },
                  child: Card(
                    elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.pathologyDataTemp["cardioTemp"] != null
                          ? controller.pathologyDataTemp["cardioTemp"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.pathologyDataTemp["cardioTemp"] != null
                              ? controller.pathologyDataTemp["cardioTemp"]!
                              ? AppTextStyle.boldWhiteContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                          )
                      )
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.pathologyDataTemp["cardioTemp"] == null ||
                        controller.pathologyDataTemp["cardioTemp"]!) {
                      controller.onChangedDatePathology("cardioTemp", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.pathologyDataTemp["cardioTemp"] != null
                        ? controller.pathologyDataTemp["cardioTemp"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.pathologyDataTemp["cardioTemp"] != null
                            ? controller.pathologyDataTemp["cardioTemp"]!
                            ? AppTextStyle.boldContentTextStyle
                            : AppTextStyle.boldWhiteContentTextStyle
                            : AppTextStyle.boldContentTextStyle
                        )
                    ),
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
                    if (controller.pathologyDataTemp["cancerTemp"] == null ||
                        !controller.pathologyDataTemp["cancerTemp"]!) {
                      controller.onChangedDatePathology("cancerTemp", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.pathologyDataTemp["cancerTemp"] != null
                          ? controller.pathologyDataTemp["cancerTemp"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.pathologyDataTemp["cancerTemp"] != null
                              ? controller.pathologyDataTemp["cancerTemp"]!
                              ? AppTextStyle.boldWhiteContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                          )
                      )
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.pathologyDataTemp["cancerTemp"] == null ||
                        controller.pathologyDataTemp["cancerTemp"]!) {
                      controller.onChangedDatePathology("cancerTemp", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.pathologyDataTemp["cancerTemp"] != null
                        ? controller.pathologyDataTemp["cancerTemp"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.pathologyDataTemp["cancerTemp"] != null
                            ? controller.pathologyDataTemp["cancerTemp"]!
                            ? AppTextStyle.boldContentTextStyle
                            : AppTextStyle.boldWhiteContentTextStyle
                            : AppTextStyle.boldContentTextStyle
                        )
                    ),
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
                    if (controller.pathologyDataTemp["diabeticTemp"] == null ||
                        !controller.pathologyDataTemp["diabeticTemp"]!) {
                      controller.onChangedDatePathology("diabeticTemp", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.pathologyDataTemp["diabeticTemp"] != null
                          ? controller.pathologyDataTemp["diabeticTemp"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.pathologyDataTemp["diabeticTemp"] != null
                              ? controller.pathologyDataTemp["diabeticTemp"]!
                              ? AppTextStyle.boldWhiteContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                          )
                      )
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.pathologyDataTemp["diabeticTemp"] == null ||
                        controller.pathologyDataTemp["diabeticTemp"]!) {
                      controller.onChangedDatePathology("diabeticTemp", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.pathologyDataTemp["diabeticTemp"] != null
                        ? controller.pathologyDataTemp["diabeticTemp"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.pathologyDataTemp["diabeticTemp"] != null
                            ? controller.pathologyDataTemp["diabeticTemp"]!
                            ? AppTextStyle.boldContentTextStyle
                            : AppTextStyle.boldWhiteContentTextStyle
                            : AppTextStyle.boldContentTextStyle
                        )
                    ),
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
                    if (controller.pathologyDataTemp["obesyTemp"] == null ||
                        !controller.pathologyDataTemp["obesyTemp"]!) {
                      controller.onChangedDatePathology("obesyTemp", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.pathologyDataTemp["obesyTemp"] != null
                          ? controller.pathologyDataTemp["obesyTemp"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.pathologyDataTemp["obesyTemp"] != null
                              ? controller.pathologyDataTemp["obesyTemp"]!
                              ? AppTextStyle.boldWhiteContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                          )
                      )
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.pathologyDataTemp["obesyTemp"] == null ||
                        controller.pathologyDataTemp["obesyTemp"]!) {
                      controller.onChangedDatePathology("obesyTemp", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.pathologyDataTemp["obesyTemp"] != null
                        ? controller.pathologyDataTemp["obesyTemp"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.pathologyDataTemp["obesyTemp"] != null
                            ? controller.pathologyDataTemp["obesyTemp"]!
                            ? AppTextStyle.boldContentTextStyle
                            : AppTextStyle.boldWhiteContentTextStyle
                            : AppTextStyle.boldContentTextStyle
                        )
                    ),
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
                    if (controller.pathologyDataTemp["respTemp"] == null ||
                        !controller.pathologyDataTemp["respTemp"]!) {
                      controller.onChangedDatePathology("respTemp", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.pathologyDataTemp["respTemp"] != null
                          ? controller.pathologyDataTemp["respTemp"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.pathologyDataTemp["respTemp"] != null
                              ? controller.pathologyDataTemp["respTemp"]!
                              ? AppTextStyle.boldWhiteContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                          )
                      )
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.pathologyDataTemp["respTemp"] == null ||
                        controller.pathologyDataTemp["respTemp"]!) {
                      controller.onChangedDatePathology("respTemp", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.pathologyDataTemp["respTemp"] != null
                        ? controller.pathologyDataTemp["respTemp"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.pathologyDataTemp["respTemp"] != null
                            ? controller.pathologyDataTemp["respTemp"]!
                            ? AppTextStyle.boldContentTextStyle
                            : AppTextStyle.boldWhiteContentTextStyle
                            : AppTextStyle.boldContentTextStyle
                        )
                    ),
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
                    if (controller.pathologyDataTemp["mentalTemp"] == null ||
                        !controller.pathologyDataTemp["mentalTemp"]!) {
                      controller.onChangedDatePathology("mentalTemp", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.pathologyDataTemp["mentalTemp"] != null
                          ? controller.pathologyDataTemp["mentalTemp"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.pathologyDataTemp["mentalTemp"] != null
                              ? controller.pathologyDataTemp["mentalTemp"]!
                              ? AppTextStyle.boldWhiteContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                          )
                      )
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.pathologyDataTemp["mentalTemp"] == null ||
                        controller.pathologyDataTemp["mentalTemp"]!) {
                      controller.onChangedDatePathology("mentalTemp", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.pathologyDataTemp["mentalTemp"] != null
                        ? controller.pathologyDataTemp["mentalTemp"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.pathologyDataTemp["mentalTemp"] != null
                            ? controller.pathologyDataTemp["mentalTemp"]!
                            ? AppTextStyle.boldContentTextStyle
                            : AppTextStyle.boldWhiteContentTextStyle
                            : AppTextStyle.boldContentTextStyle
                        )
                    ),
                  ),
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
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.pathologyDataTemp["fluxTemp"] == null ||
                        !controller.pathologyDataTemp["fluxTemp"]!) {
                      controller.onChangedDatePathology("fluxTemp", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.pathologyDataTemp["fluxTemp"] != null
                          ? controller.pathologyDataTemp["fluxTemp"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.pathologyDataTemp["fluxTemp"] != null
                              ? controller.pathologyDataTemp["fluxTemp"]!
                              ? AppTextStyle.boldWhiteContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                              : AppTextStyle.boldContentTextStyle
                          )
                      )
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.pathologyDataTemp["fluxTemp"] == null ||
                        controller.pathologyDataTemp["fluxTemp"]!) {
                      controller.onChangedDatePathology("fluxTemp", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.pathologyDataTemp["fluxTemp"] != null
                        ? controller.pathologyDataTemp["fluxTemp"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.pathologyDataTemp["fluxTemp"] != null
                            ? controller.pathologyDataTemp["fluxTemp"]!
                            ? AppTextStyle.boldContentTextStyle
                            : AppTextStyle.boldWhiteContentTextStyle
                            : AppTextStyle.boldContentTextStyle
                        )
                    ),
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
