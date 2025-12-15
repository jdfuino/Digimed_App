import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/icons/tools_dimed_icons.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardPDataAdmin extends StatelessWidget {
  const CardPDataAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 24, bottom: 8, top: 10),
      height: size.height * 0.25,
      child: Column(
        crossAxisAlignment: controller.noteP != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                "Plan de tratamiento",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              _dropMenu(context),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ...getDataSoap(controller.noteP, controller.dateP)
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
    onSelected: (String value) {
      if (value == "ver_registros") {
        pushNewNoteHistory(context, controller.userID, controller.patients,
            soapId: "p");
      }
    },
    itemBuilder: (BuildContext context) {
      return [
        PopupMenuItem<String>(
          value: "ver_registros",
          child: Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                color: AppColors.backgroundColor,
                size: 25,
              ),
              const SizedBox(width: 8),
              const Text('Ver historial'),
            ],
          ),
        ),
      ];
    },
  );
}
