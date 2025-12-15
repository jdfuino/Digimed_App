import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:flutter/material.dart';

Widget cardInfo(MedicalCenter medicalCenter) {
  return Container(
    margin: const EdgeInsets.only(right: 24, left: 24),
    child: CardDigimed(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 24, left: 24, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nombre",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Text(
                  medicalCenter.name,
                  style: AppTextStyle.normal17ContentTextStyle,
                ),
              ],
            ),
            const Divider(color: AppColors.dividerColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dirección",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Container(
                  width: double.maxFinite,
                  child: Text(
                    medicalCenter.address,
                    style: AppTextStyle.normal17ContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.dividerColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Número de Doctores",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Container(
                  width: double.maxFinite,
                  child: Text(
                    medicalCenter.totalDoctors.toString(),
                    style: AppTextStyle.normal17ContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.dividerColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Número de Especialistas",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Container(
                  width: double.maxFinite,
                  child: Text(
                    medicalCenter.specialtiesCount.toString(),
                    style: AppTextStyle.normal17ContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget cardInfo2(MedicalCenter medicalCenter) {
  return Container(
    margin: const EdgeInsets.only(right: 24, left: 24),
    child: CardDigimed(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 24, left: 24, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hospitalización",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Text(
                  medicalCenter.hospitalization == true ? "Si" : "No",
                  style: AppTextStyle.normal17ContentTextStyle,
                ),
              ],
            ),
            const Divider(color: AppColors.dividerColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Emergencias",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Container(
                  width: double.maxFinite,
                  child: Text(
                    medicalCenter.emergencies == true ? "Si" : "No",
                    style: AppTextStyle.normal17ContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.dividerColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Laboratorio",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Container(
                  width: double.maxFinite,
                  child: Text(
                    medicalCenter.laboratory == true ? "Si" : "No",
                    style: AppTextStyle.normal17ContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.dividerColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Imagenologia",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Container(
                  width: double.maxFinite,
                  child: Text(
                    medicalCenter.imaging == true ? "Si" : "No",
                    style: AppTextStyle.normal17ContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.dividerColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Radiologia",
                  style: AppTextStyle.subW500NormalContentTextStyle,
                ),
                Container(
                  width: double.maxFinite,
                  child: Text(
                    medicalCenter.radiology == true ? "Si" : "No",
                    style: AppTextStyle.normal17ContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
