import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class DataOkDoctorDialog extends StatelessWidget {
  const DataOkDoctorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 32,right: 16, left: 16,bottom: 32),
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              DigimedIcon.good,
              color: AppColors.backgroundSettingSaveColor,
              size: 80,
            ),
            const SizedBox(height: 8,),
            Text(titleOKDialog,
              style: AppTextStyle.boldContentTextStyle,),
            const SizedBox(height: 8,),
            Text(
              messageOKDoctorDialog,
              style: AppTextStyle.normalContentTextStyle,
              textAlign:TextAlign.center,)
          ],
        ),
      ),
    );

  }
}
