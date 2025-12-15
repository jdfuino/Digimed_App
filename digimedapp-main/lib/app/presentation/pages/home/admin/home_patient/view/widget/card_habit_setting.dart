import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardHabitSetting extends StatelessWidget {
  const CardHabitSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
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
              Expanded(
                child: const Text(
                  "Hábitos de paciente",
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
                  final result = await controller.checkHabitData();
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
                        .copyWith(isSettingDataHabit: false);
                  });
                },
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                "Bebe alcohol",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.habitDataTemp["0"] == null ||
                        !controller.habitDataTemp["0"]!) {
                      controller.onChangedDatePathology("0", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.habitDataTemp["0"] != null
                          ? controller.habitDataTemp["0"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.habitDataTemp["0"] != null
                              ? controller.habitDataTemp["0"]!
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
                    if (controller.habitDataTemp["0"] == null ||
                        controller.habitDataTemp["0"]!) {
                      controller.onChangedDatePathology("0", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.habitDataTemp["0"] != null
                        ? controller.habitDataTemp["0"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.habitDataTemp["0"] != null
                            ? controller.habitDataTemp["0"]!
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
                "Fuma",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.habitDataTemp["1"] == null ||
                        !controller.habitDataTemp["1"]!) {
                      controller.onChangedDatePathology("1", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.habitDataTemp["1"] != null
                          ? controller.habitDataTemp["1"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.habitDataTemp["1"] != null
                              ? controller.habitDataTemp["1"]!
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
                    if (controller.habitDataTemp["1"] == null ||
                        controller.habitDataTemp["1"]!) {
                      controller.onChangedDatePathology("1", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.habitDataTemp["1"] != null
                        ? controller.habitDataTemp["1"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.habitDataTemp["1"] != null
                            ? controller.habitDataTemp["1"]!
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
                "Consume cafeína",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.habitDataTemp["2"] == null ||
                        !controller.habitDataTemp["2"]!) {
                      controller.onChangedDatePathology("2", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.habitDataTemp["2"] != null
                          ? controller.habitDataTemp["2"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.habitDataTemp["2"] != null
                              ? controller.habitDataTemp["2"]!
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
                    if (controller.habitDataTemp["2"] == null ||
                        controller.habitDataTemp["2"]!) {
                      controller.onChangedDatePathology("2", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.habitDataTemp["2"] != null
                        ? controller.habitDataTemp["2"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.habitDataTemp["2"] != null
                            ? controller.habitDataTemp["2"]!
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
              SizedBox(
                width: 150,
                child: const Text(
                  "Toma medicamentos",
                  style: AppTextStyle.normal16W500ContentTextStyle,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.habitDataTemp["3"] == null ||
                        !controller.habitDataTemp["3"]!) {
                      controller.onChangedDatePathology("3", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.habitDataTemp["3"] != null
                          ? controller.habitDataTemp["3"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.habitDataTemp["3"] != null
                              ? controller.habitDataTemp["3"]!
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
                    if (controller.habitDataTemp["3"] == null ||
                        controller.habitDataTemp["3"]!) {
                      controller.onChangedDatePathology("3", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.habitDataTemp["3"] != null
                        ? controller.habitDataTemp["3"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.habitDataTemp["3"] != null
                            ? controller.habitDataTemp["3"]!
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
                "No hace ejercicio",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.habitDataTemp["4"] == null ||
                        !controller.habitDataTemp["4"]!) {
                      controller.onChangedDatePathology("4", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.habitDataTemp["4"] != null
                          ? controller.habitDataTemp["4"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.habitDataTemp["4"] != null
                              ? controller.habitDataTemp["4"]!
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
                    if (controller.habitDataTemp["4"] == null ||
                        controller.habitDataTemp["4"]!) {
                      controller.onChangedDatePathology("4", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.habitDataTemp["4"] != null
                        ? controller.habitDataTemp["4"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.habitDataTemp["4"] != null
                            ? controller.habitDataTemp["4"]!
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
                "Come a deshoras",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    if (controller.habitDataTemp["5"] == null ||
                        !controller.habitDataTemp["5"]!) {
                      controller.onChangedDatePathology("5", true);
                    }
                  },
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color:
                      controller.habitDataTemp["5"] != null
                          ? controller.habitDataTemp["5"]!
                          ? AppColors.backgroundColor
                          : AppColors.buttonDisableBackgroundColor
                          : AppColors.buttonDisableBackgroundColor,
                      child: Center(
                          child:
                          Text("Si", style:
                          controller.habitDataTemp["5"] != null
                              ? controller.habitDataTemp["5"]!
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
                    if (controller.habitDataTemp["5"] == null ||
                        controller.habitDataTemp["5"]!) {
                      controller.onChangedDatePathology("5", false);
                    }
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color:
                    controller.habitDataTemp["5"] != null
                        ? controller.habitDataTemp["5"]!
                        ? AppColors.buttonDisableBackgroundColor
                        : AppColors.backgroundColor
                        : AppColors.buttonDisableBackgroundColor,
                    child: Center(
                        child:
                        Text("No", style:
                        controller.habitDataTemp["5"] != null
                            ? controller.habitDataTemp["5"]!
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
