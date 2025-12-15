import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/icons/i_a_icons_icons.dart';
import 'package:digimed/app/presentation/global/icons/tools_dimed_icons.dart';
import 'package:digimed/app/presentation/global/widgets/form_create_new_note_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/form_using_ia_note_dialog.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardOData extends StatelessWidget {
  const CardOData({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 24, bottom: 8),
      height: size.height * 0.25,
      child: Column(
        crossAxisAlignment: controller.noteO != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                "Riesgos objetivos",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              controller.state.requestState.when(fetch: () {
                return const CircularProgressIndicator();
              }, normal: () {
                return _dropMenu(context);
              })
            ],
          ),
          ...getDataSoap(controller.noteO, controller.dateO)
        ],
      ),
    );
  }
}

Widget _dropMenu(BuildContext context) {
  final HomePatientAdminController controller = Provider.of(context);
  return PopupMenuButton<String>(
    icon: const Icon(
      ToolsDimed.icon_tools,
      color: AppColors.backgroundColor,
      size: 22,
    ),
    onSelected: (String value) async {
      if (value == "ver_registros") {
        pushNewNoteHistory(context, controller.userID, controller.patients,
            soapId: "o");
      } else if (value == "Crear_nota") {
        var result = await showDialog(
            context: context,
            builder: (BuildContext contextF) {
              return FormCreateNewNoteDialog(
                title: "Riesgos objetivos",
                patientID: controller.patients.patientID,
                soapID: "o",
                onSaved: (inputNote) async {
                  await controller.setNewNoteO(inputNote);
                },
              );
            });
        var resultString = result as String;
        if (resultString == "create_ia") {
          controller.getHealthSummary(() {
            showDialog(
                context: context,
                builder: (BuildContext contextF) {
                  return FormUsingIaNoteDialog(
                      title: "Riesgos objetivos",
                      soapID: "o",
                      subTitle:
                          "Crearé un perfil de riesgo objetivo con la información almacenada de tu paciente",
                      body: controller.healthSummary,
                      patientID: controller.patients.patientID,
                      onSaved: (inputNote) async {
                        await controller.setNewNoteO(inputNote);
                      });
                });
          });
        }
      } else if (value == "Editar_nota") {
        var result = await showDialog(
            context: context,
            builder: (BuildContext contextF) {
              return FormCreateNewNoteDialog(
                title: "Riesgos objetivos",
                soapID: "o",
                patientID: controller.patients.patientID,
                note: controller.noteO,
                onSaved: (inputNote) async {
                  await controller.setNewNoteO(inputNote);
                },
              );
            });
        var resultString = result as String;
        if (resultString == "create_ia") {
          controller.getHealthSummary(() {
            showDialog(
                context: context,
                builder: (BuildContext contextF) {
                  return FormUsingIaNoteDialog(
                      title: "Riesgos objetivos",
                      soapID: "o",
                      subTitle:
                          "Crearé un perfil de riesgo objetivo con la información almacenada de tu paciente",
                      body: controller.healthSummary,
                      patientID: controller.patients.patientID,
                      onSaved: (inputNote) async {
                        await controller.setNewNoteO(inputNote);
                      });
                });
          });
        }
      } else if (value == "ia_nota") {
        controller.getHealthSummary(() {
          showDialog(
              context: context,
              builder: (BuildContext contextF) {
                return FormUsingIaNoteDialog(
                    title: "Riesgos objetivos",
                    soapID: "o",
                    subTitle:
                        "Crearé un perfil de riesgo objetivo con la información almacenada de tu paciente",
                    body: controller.healthSummary,
                    patientID: controller.patients.patientID,
                    onSaved: (inputNote) async {
                      await controller.setNewNoteO(inputNote);
                    });
              });
        });
      }
    },
    itemBuilder: (BuildContext context) {
      return [
        const PopupMenuItem<String>(
          value: "ia_nota",
          child: Row(
            children: [
              Icon(
                IAIcons.vector,
                color: AppColors.backgroundColor,
                size: 25,
              ),
              SizedBox(width: 8),
              Text('Crear con IA'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: "Crear_nota",
          child: Row(
            children: [
              Icon(
                DigimedIcon.exam,
                color: AppColors.backgroundColor,
                size: 25,
              ),
              SizedBox(width: 8),
              Text('Crear nota'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: "Editar_nota",
          child: Row(
            children: [
              Icon(
                DigimedIcon.edit,
                color: AppColors.backgroundColor,
                size: 25,
              ),
              SizedBox(width: 8),
              Text('Editar nota'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: "ver_registros",
          child: Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                color: AppColors.backgroundColor,
                size: 25,
              ),
              SizedBox(width: 8),
              Text('Ver historial'),
            ],
          ),
        ),
      ];
    },
  );
}
