import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../global/app_text_sytle.dart';

class ContactDoctorPatientPage extends StatelessWidget {
  final Doctor myDoctor;

  const ContactDoctorPatientPage({super.key, required this.myDoctor});

  @override
  Widget build(BuildContext context) {
    final map = organizeList(myDoctor.hours);
    final mapDay = organizeListDays(map);
    final keys = mapDay.keys.toList();
    return MyScaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              BannerDigimed(
                  textLeft: "Horario de atención",
                  iconLeft: DigimedIcon.clock,
                  iconRight: DigimedIcon.back,
                  onClickIconRight: () {
                    Navigator.of(context).pop();
                  },
                  firstLine: "",
                  secondLine:
                  (myDoctor.user.gender.isEmpty ||
                      myDoctor.user.gender == "Male" )
                      ?"Dr.${myDoctor.user.fullName}"
                      :"Dra.${myDoctor.user.fullName}",
                  lastLine: myDoctor.user.occupation,
                  imageProvider: isValidUrl(myDoctor.user.urlImageProfile)
                      ? NetworkImage(
                      myDoctor.user.urlImageProfile!)
                      : Assets.images.logo.provider()
              ),
              Container(
                margin:
                const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 8),
                child: Column(
                  children: [
                    CardDigimed(
                      child: Container(
                        margin:
                        EdgeInsets.only(
                             top: 17, bottom: 17),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: keys
                              .asMap()
                              .entries
                              .map((e) {
                            int indexItem = e.key;
                            var item = e.value;
                            return ItemHours(
                                item: item,
                                mapDay: mapDay,
                                context: context,
                                indexItem: indexItem);
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    ButtonDigimed(
                      height: 63,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Contacta a tu médico",
                              style: AppTextStyle.normalWhiteContentTextStyle,
                            ),
                            SizedBox(width: 16,),
                            Icon(DigimedIcon.whatsapp, color: Colors.white,)
                          ],
                        ),
                        onTab: () {
                          launchWhatsapp(
                              "${myDoctor.user.countryCode}${myDoctor.user
                                  .phoneNumber}",
                              "");
                        }),
                    SizedBox(height: 16,)
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget ItemHours({required int item,
    required BuildContext context,
    required Map<int, List<String>?> mapDay,
    required int indexItem}) {
    return Container(
      color: indexItem % 2 == 0 ? AppColors.alteredColor : Colors.white,
      margin: const EdgeInsets.only( left: 24, right: 24),
      padding: const EdgeInsets.only(right: 16,bottom: 8, top: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${dayDigimed[item]}",
                      style: AppTextStyle.sub16W500NormalContentTextStyle),
                  Text(
                    getHours(mapDay[item]!),
                    style: AppTextStyle.normal17ContentTextStyle,
                  )
                ],
              ),
              Spacer(),
              Icon(
                DigimedIcon.clock,
                size: 23,
                color: getHours(mapDay[item]!) == "Sin atención"
                    ? AppColors.DisableLabelTabBarBackgroundColor
                    : AppColors.backgroundColor,
              )
            ],
          ),
        ],
      ),
    );
  }
}
