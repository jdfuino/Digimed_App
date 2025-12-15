import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class ItemsListEspecialist extends StatelessWidget {
  final DoctorSpecialists doctorSpecialists;
  final int index;

  const ItemsListEspecialist({
    Key? key,
    required this.index,
    required this.doctorSpecialists,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index % 2 == 0 ? AppColors.alteredColor : Colors.white,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorSpecialists.fullName,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.grey13BoldContentTextStyle,
                    ),
                    Text(
                      doctorSpecialists.medicalSpecialties.isNotEmpty
                          ? getNameSpecialty(doctorSpecialists.medicalSpecialties)
                          : 'No specialties',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subNormalContentTextStyle,
                    ),
                    Text(
                      doctorSpecialists.countryCode +
                          doctorSpecialists.phoneNumber,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subNormalContentTextStyle,
                    ),
                    Text(
                      doctorSpecialists.email ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.subNormalContentTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
