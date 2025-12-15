import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/info_doctor/doctor/controller/info_doctor_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardHourDoctor extends StatelessWidget {
  const CardHourDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoDoctorController controller = Provider.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24),
      child: controller.state.myDoctorDataState.when(loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }, faild: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }, sucess: (user, list) {
        return CardDigimed(
          child: Container(
            margin:
            const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      DigimedIcon.clock,
                      size: 23,
                      color: AppColors.backgroundColor,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Horario de atención",
                      style: AppTextStyle.subW500NormalContentTextStyle,
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                list != null
                    ? _attentionCalendar(list)
                    :Container()
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _attentionCalendar(List<WorkingHours> list) {
    final map = organizeList(list);
    final mapDay = organizeListDays(map);
    final keys = mapDay.keys.toList();
    print(mapDay);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${dayDigimed[keys[0]]}",
              style: AppTextStyle.normalContentTextStyle,
            ),
            const Spacer(),
            Text(
              getHours(mapDay[0]!),
              style: AppTextStyle.normalContentTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${dayDigimed[keys[1]]}",
              style: AppTextStyle.normalContentTextStyle,
            ),
            const Spacer(),
            Text(
              getHours(mapDay[1]!),
              style: AppTextStyle.normalContentTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${dayDigimed[keys[2]]}",
              style: AppTextStyle.normalContentTextStyle,
            ),
            const Spacer(),
            Text(
              getHours(mapDay[2]!),
              style: AppTextStyle.normalContentTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${dayDigimed[keys[3]]}",
              style: AppTextStyle.normalContentTextStyle,
            ),
            const Spacer(),
            Text(
              getHours(mapDay[3]!),
              style: AppTextStyle.normalContentTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${dayDigimed[keys[4]]}",
              style: AppTextStyle.normalContentTextStyle,
            ),
            const Spacer(),
            Text(
              getHours(mapDay[4]!),
              style: AppTextStyle.normalContentTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${dayDigimed[keys[5]]}",
              style: AppTextStyle.normalContentTextStyle,
            ),
            const Spacer(),
            Text(
              getHours(mapDay[5]!),
              style: AppTextStyle.normalContentTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${dayDigimed[keys[6]]}",
              style: AppTextStyle.normalContentTextStyle,
            ),
            const Spacer(),
            Text(
              getHours(mapDay[6]!),
              style: AppTextStyle.normalContentTextStyle,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
