import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_specialist/controller/form_new_specialist_controller.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_specialist/controller/state/form_new_specialist_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsListEspecialistDoctor extends StatelessWidget {
  final DoctorSpecialists doctorSpecialists;
  final int index;
  final BuildContext fatherContext;

  const ItemsListEspecialistDoctor({
    Key? key,
    required this.index,
    required this.doctorSpecialists, required this.fatherContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FormNewSpecialistController>(context);
    return GestureDetector(
      onTap: () async {
        bool success = await controller.setDoctorSpecialist(
            doctorId: doctorSpecialists.doctorID,
            associateSpecialist: const AssociateSpecialist.loading());

        if (success == true) {
          showToast('Especialista asignado exitosamente');
          Navigator.of(fatherContext).pop(true);
        } else {
          showToast('Error al asignar especialista');
        }
      },
      child: Container(
        width: 250,
        color: index % 2 == 0 ? AppColors.alteredColor : Colors.white,
        // padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
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
      ),
    );
  }
}
