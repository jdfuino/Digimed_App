import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_medical_center/controller/home_medical_center_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemListCoordinadorMedicalCenter extends StatelessWidget {
  final User coordinadorMedicalCenter;
  final int index;

  const ItemListCoordinadorMedicalCenter(
      {Key? key,
      required this.index,
      required this.coordinadorMedicalCenter,
      re})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final HomeMedicalCenterController controller = context.read();
    return GestureDetector(
      onTap: () {
        pushNewPageSuperAdminToHomeDoctor(
            context, controller.idMedicalCenter, coordinadorMedicalCenter);
      },
      child: Container(
        color: index % 2 == 0 ? AppColors.alteredColor : Colors.white,
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
                  backgroundImage: isValidUrl(
                          coordinadorMedicalCenter.urlImageProfile)
                      ? NetworkImage(coordinadorMedicalCenter.urlImageProfile!)
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
                SizedBox(
                  width: size.width * 0.42,
                  child: Text(
                    "${coordinadorMedicalCenter.fullName}",
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.semiBoldContentTextStyle,
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    "${coordinadorMedicalCenter.identificationType}.${coordinadorMedicalCenter.identificationNumber}",
                    style: AppTextStyle.sub9BoldContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "0",
              style: AppTextStyle.subBoldContentTextStyle,
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
