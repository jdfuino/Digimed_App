import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/data_ok_dialog.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home_patient/view/home_doctor_patient_page.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


class ListItemPatientDoctor extends StatelessWidget {
  final Patients itemPatient;
  final int index;

  const ListItemPatientDoctor({super.key, required this.itemPatient, required this.index});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: HomeDoctorPatientPage(
              patientId: itemPatient.patientID,
              patients: itemPatient,
            ),
            withNavBar: false);
      },
      child: Container(
        color: index % 2 == 0 ? AppColors.alteredColor : Colors.white ,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        margin: const EdgeInsets.only(right: 8, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: AppColors.backgroundColor,
              radius: (size.width * 0.06),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: (size.width * 0.06) - 2,
                child: CircleAvatar(
                  backgroundImage: isValidUrl(itemPatient.user.urlImageProfile)
                      ? NetworkImage(
                          itemPatient.user.urlImageProfile!)
                      : Assets.images.logo.provider(),
                  radius: (size.width * 0.06) - 4,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.35,
                  child: Text(
                    "${itemPatient.user.fullName}",
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.semiBoldContentTextStyle,
                  ),
                ),
                Text(
                  "${itemPatient.user.identificationType}. ${itemPatient.user.identificationNumber}",
                  style: AppTextStyle.subNormalContentTextStyle,
                )
              ],
            ),
            const Spacer(),
            alteredValues(itemPatient.profileCardiovascular,
                    itemPatient.profileLaboratory,
              itemPatient.user.gender
            )
                ? Icon(
                    DigimedIcon.alert,
                    color: Colors.amber,
                    size: size.width * 0.07,
                  )
                : Icon(
                    DigimedIcon.good,
                    color: AppColors.backgroundSettingSaveColor,
                    size: size.width * 0.07,
                  ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
      ),
    );
  }
}
