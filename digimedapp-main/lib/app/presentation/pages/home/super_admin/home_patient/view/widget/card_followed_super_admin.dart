import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/state/home_patient_super_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardFollowedSuperAdmin extends StatelessWidget {
  const CardFollowedSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: const Text(
                  "Seguimiento de estado de salud",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.normal16W500ContentTextStyle,
                ),
              ),
              controller.patientsTemp != controller.patients
              ?const Spacer()
              :Container(),
              controller.patientsTemp != controller.patients
              ?ElevatedButton.icon(
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
                  final result = await controller.uploadFollowedMethod();
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
                  });
                },
              )
              :Container(),
            ],
          ),
          SizedBox(height: 16,),
          Container(
            width: double.infinity,
            height: 56,
            child: GestureDetector(
              onTap: (){
                controller.changeFollowed(followUpMethod[0]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                    .contains(followUpMethod[0])
                    ? AppColors.backgroundColor
                    : Colors.white
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Consulta médica regular",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[0])
                            ? AppTextStyle.normalWhite16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            child: GestureDetector(
              onTap: (){
                controller.changeFollowed(followUpMethod[1]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                    .contains(followUpMethod[1])
                    ? AppColors.backgroundColor
                    : Colors.white
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Telemedicina",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[1])
                            ? AppTextStyle.normalWhite16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            child: GestureDetector(
              onTap: (){
                controller.changeFollowed(followUpMethod[2]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                    .contains(followUpMethod[2])
                    ? AppColors.backgroundColor
                    : Colors.white
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Atención primaria de salud (APS)",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[2])
                            ? AppTextStyle.normalWhite16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            child: GestureDetector(
              onTap: (){
                controller.changeFollowed(followUpMethod[3]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                    .contains(followUpMethod[3])
                    ? AppColors.backgroundColor
                    : Colors.white
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Soy asegurado",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[3])
                            ? AppTextStyle.normalWhite16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            height: 56,
            child: GestureDetector(
              onTap: (){
                controller.changeFollowed(followUpMethod[4]!);
              },
              child: Card(
                color: controller.patientsTemp!.followUpMethod != null
                    ? controller.patientsTemp!.followUpMethod!
                    .contains(followUpMethod[4])
                    ? AppColors.backgroundColor
                    : Colors.white
                    : AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No poseo control médico",
                        style: controller.patientsTemp!.followUpMethod != null
                            ? controller.patientsTemp!.followUpMethod!
                            .contains(followUpMethod[4])
                            ? AppTextStyle.normalWhite16W500ContentTextStyle
                            : AppTextStyle.normal16W500ContentTextStyle
                            : AppTextStyle.normalWhite16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
