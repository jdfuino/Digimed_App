import 'package:digimed/app/domain/models/item_doctors/item_doctors.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class ItemListDoctors extends StatelessWidget {
  const ItemListDoctors({Key? key, required this.itemDoctors, required this.index})
      : super(key: key);

  final ItemDoctors itemDoctors;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        pushNewPageAdminToDoctor(context, itemDoctors.user.id);
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
                  backgroundImage: isValidUrl(itemDoctors.user.urlImageProfile)
                    ?NetworkImage(itemDoctors.user.urlImageProfile!)
                    :Assets.images.logo.provider(),
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
                  width: size.width * 0.43,
                  child: Text(
                    (itemDoctors.user.gender.isEmpty ||
                        itemDoctors.user.gender == "Male" )
                    ?"Dr.${itemDoctors.user.fullName}"
                    :"Dra.${itemDoctors.user.fullName}",
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.semiBoldContentTextStyle,
                  ),
                ),
                Text(
                  "${itemDoctors.user.identificationType} ${itemDoctors.user.identificationNumber}",
                  style: AppTextStyle.subNormalContentTextStyle,
                )
              ],
            ),
            const Spacer(),
            Text(
              "${itemDoctors.patientsCount}",
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
