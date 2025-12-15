import 'package:digimed/app/domain/models/recipe/recipe.dart';
import 'package:digimed/app/domain/models/report/report.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/icons/i_a_icons_icons.dart';
import 'package:digimed/app/presentation/global/icons/tools_dimed_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/error_ia_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/status_ia_dialog.dart';
import 'package:digimed/app/presentation/global/widgets/waiting_ia_dialog.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardPrescriptionAdmin extends StatelessWidget {
  const CardPrescriptionAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
      child: CardDigimed(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8, left: 16, bottom: 8),
              child: const Row(
                children: [
                  Text(
                    "Récipe médico",
                    style: AppTextStyle.normal16W500ContentTextStyle,
                  ),
                  Spacer(),
                  // controller.state.requestState.when(
                  //   fetch: () => const CircularProgressIndicator(),
                  //   normal: () => _dropMenu(context),
                  // ),
                ],
              ),
            ),
            // Aseguramos que el ListView tenga un tamaño definido
            Container(
              height: size.height * 0.5,
              margin: const EdgeInsets.only(right: 8, left: 8),
              child: controller.state.recipeFetchState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (list) {
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      // Permite que el ListView se ajuste al contenido
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return _itemReport(item, context);
                      },
                    );
                  } else {
                    return const Center(
                        child: Text("No hay reportes disponibles"));
                  }
                },
              ),
            ),
          ],
        ),
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
            soapId: "a");
      } else if (value == "Crear_nota") {
        controller.verificationCreateNewRecipe((message) {
          showDialog(
              context: context,
              builder: (BuildContext contextF) {
                return ErrorIaDialog(body: message);
              });
        }, () {
          showDialog(
              context: context,
              builder: (BuildContext contextF) {
                return const StatusIaDialog(
                  title: "¡Tarea Completada!",
                  body: "Se ha creado un nuevo récipe médico.",
                  icon: IAIcons.vector,
                );
              });
        });
      }
    },
    itemBuilder: (BuildContext context) {
      return [
        const PopupMenuItem<String>(
          value: "Crear_nota",
          child: Row(
            children: [
              Icon(
                IAIcons.vector,
                color: AppColors.backgroundColor,
                size: 25,
              ),
              SizedBox(width: 8),
              Text('Crear récipe médico'),
            ],
          ),
        ),
      ];
    },
  );
}

Widget _itemReport(Recipe item, BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  final HomePatientSuperAdminController controller = Provider.of(context);
  return Card(
    color: AppColors.scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Container(
      margin: const EdgeInsets.only(right: 16, left: 24, bottom: 8, top: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      height: size.height * 0.1,
      // Ajusté la altura para que se vea mejor
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Fecha y título a la izquierda
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  convertDateCaracas(item.createdAt),
                  style: AppTextStyle.boldBlueTextStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  style: AppTextStyle.normal16W500ContentTextStyle.copyWith(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // Botón "Descargar" a la derecha
          ElevatedButton.icon(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                // Impide que el usuario lo cierre tocando fuera
                builder: (BuildContext dialogContext) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    // Impide que el usuario lo cierre con el botón de retroceso
                    child: const WaitingIaDialog(
                      icon: IAIcons.vector, // Ícono de espera (puedes cambiarlo)
                    ),
                  );
                },
              );
              try {
                await controller.getRecipeBase64(
                    reportID: item.reportID);
              } catch (e) {
                showToast("Error al compartir el PDF: $e");
              } finally {
                Navigator.pop(context);
              }
            },
            icon: const Icon(
              Icons.download, // Ícono de descarga
              size: 18,
              color: Colors.white,
            ),
            label: const Text(
              "Descargar",
              style: AppTextStyle.normalWhite15W600ContentTextStyle,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundSettingSaveColor,
              // Color verde como en la imagen
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    ),
  );
}

// Widget auxiliar para mensajes de error (ajústalo según tu diseño)
Widget errorMessage() {
  return const Center(child: Text("Error al cargar los reportes"));
}
