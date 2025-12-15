import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class ItemListMedicalCenter extends StatelessWidget {
  const ItemListMedicalCenter(
      {Key? key, required this.index, required this.medicalCenter})
      : super(key: key);

  final MedicalCenter medicalCenter;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        pushNewPageSuperAdminToMedicalCenter(
            context, medicalCenter.id, medicalCenter);
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
                  backgroundImage: isValidUrl(medicalCenter.logoUrl)
                      ? NetworkImage(medicalCenter.logoUrl!)
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
                  width: 150,
                  child: Text(
                    "${medicalCenter.name}",
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.semiBoldContentTextStyle,
                  ),
                ),
                Container(
                  width: 150,
                  child: Text(
                    "${medicalCenter.address}",
                    style: AppTextStyle.sub9BoldContentTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "${medicalCenter.specialtiesCount}",
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
