import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardClinicData extends StatelessWidget {
  const CardClinicData({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
          right: 24, left: 24, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            children: [
              const Text(
                "Datos personales",
                style: AppTextStyle.normal16W500ContentTextStyle,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  DigimedIcon.edit,
                  color: AppColors.backgroundColor,
                  size: 23,
                ), onPressed: () {
                  controller.changedSettingState();
              },
              )
            ],
          ),
          const Divider(),
          const Text(
            "Fecha de nacimiento",
            style: AppTextStyle.subW500NormalContentTextStyle,
          ),
          Text(
            convertDate(controller.patients.user.birthday),
            style: AppTextStyle.semiBold17W500ContentTextStyle,
          ),
          const Divider(),
          const Text(
            "Correo electrónico",
            style: AppTextStyle.subW500NormalContentTextStyle,
          ),
          Container(
            width: double.maxFinite,
            child: Text(
              controller.patients.user.email,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.semiBold17W500ContentTextStyle,
            ),
          ),
          const Divider(),
          const Text(
            "Teléfono",
            style: AppTextStyle.subW500NormalContentTextStyle,
          ),
          Text(
            "${controller.patients.user.countryCode}-${controller.patients.user.phoneNumber}",
            style: AppTextStyle.semiBold17W500ContentTextStyle,
          ),
          const Divider(),
          const Text(
            "Ocupación o profesión",
            style: AppTextStyle.subW500NormalContentTextStyle,
          ),
          Container(
            width: double.maxFinite,
            child: Text(controller.patients.user.occupation ,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.semiBold17W500ContentTextStyle,),
          ),
          const Divider(),
          const Text(
            "Peso",
            style: AppTextStyle.subW500NormalContentTextStyle,
          ),
          Text(controller.patients.user.weight != null
              ?"${showNumber2(controller.patients.user.weight!)} kg"
              :"0 kg", style: AppTextStyle.semiBold17W500ContentTextStyle,),
          const Divider(),
          const Text(
            "Estatura",
            style: AppTextStyle.subW500NormalContentTextStyle,
          ),
          Text(controller.patients.user.height != null
              ?"${showNumber2(controller.patients.user.height!)} m"
              :"0 kg", style: AppTextStyle.semiBold17W500ContentTextStyle,),
        ],
      ),
    );
  }
}
