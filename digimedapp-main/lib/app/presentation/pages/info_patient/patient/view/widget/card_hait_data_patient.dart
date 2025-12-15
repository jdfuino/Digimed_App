import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/controller/info_patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardHabitDataPatient extends StatelessWidget {
  const CardHabitDataPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoPatientController controller = Provider.of(context);
    final Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.backgroundColor,
                radius: 5,
              ),
              const SizedBox(
                width: 8,
              ),
              const Expanded(
                child: Text(
                  "Tus hábitos",
                  style: AppTextStyle.normal16W500ContentTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
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
          const SizedBox(height: 16,),
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
                child: Card(
                  elevation: 0,
                  color: controller.tempPatient.medicalHistory != null
                      ?controller.tempPatient.medicalHistory!.hasDrinkingHabit != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.tempPatient.medicalHistory != null
                          ?controller.tempPatient.medicalHistory!.hasDrinkingHabit != null
                          ?controller.tempPatient.medicalHistory!.hasDrinkingHabit!
                          ?const Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
                child: Card(
                  elevation: 0,
                  color: controller.tempPatient.medicalHistory != null
                      ?controller.tempPatient.medicalHistory!.hasSmokingHabit != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.tempPatient.medicalHistory != null
                          ?controller.tempPatient.medicalHistory!.hasSmokingHabit != null
                          ?controller.tempPatient.medicalHistory!.hasSmokingHabit!
                          ?const Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
                child: Card(
                  elevation: 0,
                  color: controller.tempPatient.medicalHistory != null
                      ?controller.tempPatient.medicalHistory!.hasDrinkingCaffeineHabit != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.tempPatient.medicalHistory != null
                          ?controller.tempPatient.medicalHistory!.hasDrinkingCaffeineHabit != null
                          ?controller.tempPatient.medicalHistory!.hasDrinkingCaffeineHabit!
                          ?const Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
              const Spacer(),
              SizedBox(
                width: 50,
                height: 50,
                child: Card(
                  elevation: 0,
                  color: controller.tempPatient.medicalHistory != null
                      ?controller.tempPatient.medicalHistory!.hasMedication != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.tempPatient.medicalHistory != null
                          ?controller.tempPatient.medicalHistory!.hasMedication != null
                          ?controller.tempPatient.medicalHistory!.hasMedication!
                          ?const Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
                child: Card(
                  elevation: 0,
                  color: controller.tempPatient.medicalHistory != null
                      ?controller.tempPatient.medicalHistory!.hasFitnessHabit != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.tempPatient.medicalHistory != null
                          ?controller.tempPatient.medicalHistory!.hasFitnessHabit != null
                          ?controller.tempPatient.medicalHistory!.hasFitnessHabit!
                          ?const Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
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
                child: Card(
                  elevation: 0,
                  color: controller.tempPatient.medicalHistory != null
                      ?controller.tempPatient.medicalHistory!.hasEatingAfterHoursHabit != null
                      ?AppColors.backgroundColor
                      :AppColors.buttonDisableBackgroundColor
                      :AppColors.buttonDisableBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child:
                      controller.tempPatient.medicalHistory != null
                          ?controller.tempPatient.medicalHistory!.hasEatingAfterHoursHabit != null
                          ?controller.tempPatient.medicalHistory!.hasEatingAfterHoursHabit!
                          ?const Text("Si",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("No",style: AppTextStyle.boldWhiteContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)
                          :const Text("N/D",style: AppTextStyle.boldContentTextStyle,)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
