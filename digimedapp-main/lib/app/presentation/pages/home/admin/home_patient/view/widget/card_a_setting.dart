import 'package:digimed/app/domain/models/input_soap/input_soap.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardASetting extends StatelessWidget {
  const CardASetting({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    final _noteController = TextEditingController(
      text: controller.edit! ? controller.noteA : '',
    );
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24),
      height: size.height * 0.25,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Diagnóstico",
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.normal16W500ContentTextStyle,
                ),
              ),
              Spacer(),
              controller.state.requestState.when(fetch: (){
                return const CircularProgressIndicator();
              }, normal: (){
                return ElevatedButton.icon(
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
                    if(_noteController.text.isNotEmpty){
                      final input = InputSOAP(
                          patientID: controller.patients.patientID,
                          assessmentNote: _noteController.text);
                      await controller.setNewNoteA(input);
                    }
                    controller.state =
                        controller.state.copyWith(isSettingDataA: false);
                  },
                );
              })
            ],
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              style: AppTextStyle.normalTextStyle2,
              controller: _noteController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.scaffoldBackgroundColor,
                hintText: 'Escribe tus notas',
                hintStyle: AppTextStyle.hintTextStyle,
                contentPadding:
                const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      width: 0.2, color: AppColors.backgroundSearchColor),
                ),
              )),
          Spacer()
        ],
      ),
    );
  }
}
