import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/tools_dimed_icons.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardSDataAdmin extends StatelessWidget {
  const CardSDataAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 16, left: 24, bottom: 8, top: 10),
      height: size.height * 0.25,
      child: Column(
        crossAxisAlignment: controller.noteS != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text(
                "Riesgos subjetivos",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              const Spacer(),
              _dropMenu(context),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ...getDataSoap(controller.noteS, controller.dateS)
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
            soapId: "s");
      }
    },
    itemBuilder: (BuildContext context) {
      return [
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
