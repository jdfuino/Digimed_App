import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/domain/models/item_working_hours/item_working_hours.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/setting_hours/admin/controller/setting_hours_admin_controller.dart';
import 'package:digimed/app/presentation/pages/setting_hours/admin/controller/state/setting_hours_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SettingHoursAdminPage extends StatelessWidget {
  final User user;
  List<WorkingHours>? listHours;
  final int index;
  final int doctorID;

  SettingHoursAdminPage(
      {super.key,
      required this.user,
      this.listHours,
      required this.index,
      required this.doctorID});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingHoursAdminController(SettingHoursAdminState(),
          accountRepository: Repositories.account,
          sessionController: context.read(),
          listWorking: listHours,
          doctorId: doctorID,
          index: index)
        ..init(),
      child: MyScaffold(
        body: Builder(
          builder: (context) {
            final controller = Provider.of<SettingHoursAdminController>(
              context,
              listen: true,
            );
            return SingleChildScrollView(
              child: Column(
                children: [
                  BannerDigimed(
                      textLeft: "Horario de atención",
                      iconLeft: DigimedIcon.clock,
                      iconRight: DigimedIcon.back,
                      onClickIconRight: () {
                        Navigator.of(context).pop();
                      },
                      firstLine: "Médico",
                      secondLine:
                      (user.gender.isEmpty || user.gender == "Male" )
                      ?"Dr.${user.fullName}" :"Dra.${user.fullName}",
                      lastLine:
                          "${user.identificationType}.${user.identificationNumber}",
                      imageProvider: isValidUrl(user.urlImageProfile)
                          ? NetworkImage(user.urlImageProfile!)
                          : Assets.images.logo.provider()),
                  Container(
                    margin: const EdgeInsets.only(right: 24, left: 24),
                    child: CardDigimed(
                      child: Container(
                        margin: const EdgeInsets.only(right: 50, left: 50),
                        child: Row(
                          children: [
                            Text(
                              dayDigimed[index]!,
                              style: AppTextStyle.normal16W500ContentTextStyle,
                            ),
                            const Spacer(

                            ),
                            Switch(
                                value: controller.state.isEnabled,
                                inactiveTrackColor: Color(0xffE3E8F3),
                                inactiveThumbColor: Color(0xff5B5B5B),
                                onChanged: (value) {
                                  controller.enabledChanged(value);
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  !controller.state.isEnabled
                      ? Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 24, left: 24),
                          child: CardDigimed(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    Assets.svgs.atentionNo.path,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    "Sin atención",
                                    style: AppTextStyle.normal16W500ContentTextStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: controller.itemsWorkingHours
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  int indexItem = e.key;
                                  var item = e.value;
                                  return ItemHours(
                                      itemWorkHours: item,
                                      context: context,
                                      indexItem: indexItem);
                                }).toList(),
                              ),
                              controller.itemsWorkingHours.length < 2
                                  ? TextButton(
                                      onPressed: () {
                                        if (controller
                                                .itemsWorkingHours.length <
                                            2) {
                                          controller.addNewHour();
                                        }
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add),
                                          Text("Añadir horario"),
                                        ],
                                      ))
                                  : Container(),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 24, left: 24),
                                child: controller.state.settingAdminState.when(
                                    loading: () {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }, normal: () {
                                  return
                                    controller.itemsWorkingHours.isNotEmpty
                                    ? ButtonDigimed(
                                      height: 60,
                                      child: const Text(
                                        "Confirmar horario",
                                        style: AppTextStyle
                                            .normalWhiteContentTextStyle,
                                      ),
                                      onTab: () {
                                        controller.checkData();
                                      })
                                    :Container();
                                }),
                              ),
                              const SizedBox(
                                height: 16,
                              )
                            ],
                          ),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget ItemHours(
      {required ItemWorkingHours itemWorkHours,
      required BuildContext context,
      required int indexItem}) {
    final SettingHoursAdminController controller = context.read();
    print(indexItem);
    return Container(
        margin: const EdgeInsets.only(right: 24, left: 24),
        child: Column(
          children: [
            CardDigimed(
              child: Container(
                margin: const EdgeInsets.only(
                    right: 24, left: 24, top: 24, bottom: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Desde",
                          style: AppTextStyle.normalContentTextStyle,
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              cancelText: "Cancelar",
                              helpText: "",
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                    data: AppColors.timePickerTheme,
                                    child: child!);
                              },
                              context: context, //context of current state
                            );

                            if (pickedTime != null) {
                              controller.settingHours(indexItem,
                                  convertirTimeOfDay(pickedTime), true);
                            }
                          },
                          child: Text(formatTime(itemWorkHours.startTime)),
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                            AppColors.backGroundColorButton,
                            foregroundColor: AppColors.backgroundColor,
                            elevation: 0,
                            shape:  const RoundedRectangleBorder(
                              side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: AppColors.backGroundColorButton,
                                  width: 1),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Divider(color: AppColors.contentTextColor),
                    Row(
                      children: [
                        const Text(
                          "Hasta",
                          style: AppTextStyle.normalContentTextStyle,
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              cancelText: "Cancelar",
                              helpText: "",
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                    data: AppColors.timePickerTheme,
                                    child: child!);
                              },
                              context: context, //context of current state
                            );

                            if (pickedTime != null) {
                              controller.settingHours(indexItem,
                                  convertirTimeOfDay(pickedTime), false);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                AppColors.backGroundColorButton,
                            foregroundColor: AppColors.backgroundColor,
                            elevation: 0,
                            shape:  const RoundedRectangleBorder(
                              side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: AppColors.backGroundColorButton,
                                  width: 1),
                            ),
                          ),
                          child: Text(formatTime(itemWorkHours.stopTime)),

                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            controller.itemsWorkingHours.length < 2
            ?Container()
            :TextButton(
                onPressed: () {
                  controller.removeHours(indexItem);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove),
                    Text("Remover horario"),
                  ],
                ))
          ],
        ));
  }
}
