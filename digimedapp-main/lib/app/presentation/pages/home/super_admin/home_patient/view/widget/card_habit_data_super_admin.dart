import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardHabitDataSuperAdmin extends StatelessWidget {
  const CardHabitDataSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

              IconButton(
                icon: const Icon(
                  DigimedIcon.edit,
                  color: AppColors.backgroundColor,
                  size: 22,
                ),
                onPressed: () {
                  controller.changedSettingState();
                },
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              const Text(
                "Bebe alcohol",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ?controller.habitDataTemp["0"] != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.patients.medicalHistory != null
                          ?controller.habitDataTemp["0"] != null
                          ?controller.habitDataTemp["0"]!
                          ?Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ?controller.habitDataTemp["1"] != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.patients.medicalHistory != null
                          ?controller.habitDataTemp["1"] != null
                          ?controller.habitDataTemp["1"]!
                          ?Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ?controller.habitDataTemp["2"] != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.patients.medicalHistory != null
                          ?controller.habitDataTemp["2"] != null
                          ?controller.habitDataTemp["2"]!
                          ?Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Toma medicamentos",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ?controller.habitDataTemp["3"] != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.patients.medicalHistory != null
                          ?controller.habitDataTemp["3"] != null
                          ?controller.habitDataTemp["3"]!
                          ?Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ?controller.habitDataTemp["4"] != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.patients.medicalHistory != null
                          ?controller.habitDataTemp["4"] != null
                          ?controller.habitDataTemp["4"]!
                          ?Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
              Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.patients.medicalHistory != null
                      ?controller.habitDataTemp["5"] != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.patients.medicalHistory != null
                          ?controller.habitDataTemp["5"] != null
                          ?controller.habitDataTemp["5"]!
                          ?Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
