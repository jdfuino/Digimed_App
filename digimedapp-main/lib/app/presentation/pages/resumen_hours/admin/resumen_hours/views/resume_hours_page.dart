import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/controller/state/info_doctor_admin_state.dart';
import 'package:digimed/app/presentation/pages/resumen_hours/admin/resumen_hours/controller/resume_hours_controller.dart';
import 'package:digimed/app/presentation/pages/resumen_hours/admin/resumen_hours/controller/state/resumen_hours_state.dart';
import 'package:digimed/app/presentation/pages/setting_hours/admin/view/setting_hours_admin_page.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResumeHoursPage extends StatelessWidget {
  final int id;

  const ResumeHoursPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResumeHoursController(
          ResumeHoursState(),
          accountRepository: Repositories.account,
          sessionController: context.read(),
          fatherId: id)
        ..init(),
      child: MyScaffold(
        body: Builder(builder: (context) {
          final controller = Provider.of<ResumeHoursController>(
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
                        controller.state.doctorDataState.when(loading: () {
                      return "";
                    }, faild: (_) {
                      return "";
                    }, sucess: (user, _, list) {
                          if(user.gender.isEmpty || user.gender == "Male" ){
                            return "Dr.${user.fullName}";
                          }else{
                            return "Dra.${user.fullName}";
                          }
                    }),
                    lastLine:
                        controller.state.doctorDataState.when(loading: () {
                      return "";
                    }, faild: (_) {
                      return "";
                    }, sucess: (user, _, list) {
                      return "${user.identificationType}${user.identificationNumber}";
                    }),
                    imageProvider:
                        controller.state.doctorDataState.when(loading: () {
                      return AssetImage(Assets.images.logo.path);
                    }, faild: (_) {
                      return AssetImage(Assets.images.logo.path);
                    }, sucess: (user, _, __) {
                      if (user.urlImageProfile != null) {
                        return isValidUrl(user.urlImageProfile)
                            ? NetworkImage(user.urlImageProfile!)
                            : Assets.images.logo.provider();
                      }
                      return AssetImage(Assets.images.logo.path);
                    })),
                controller.state.doctorDataState.when(loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, faild: (_) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, sucess: (user, _, list) {
                  final map = organizeList(list);
                  final mapDay = organizeListDays(map);
                  final keys = mapDay.keys.toList();
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(right: 24, left: 24),
                    child: CardDigimed(
                      child: Container(
                        margin:
                            const EdgeInsets.only(right: 24, left: 24, top: 24,bottom: 24),
                        child: Column(
                            children: dayDigimed.entries.map((e) {
                          int indexItem = e.key;
                          return ItemResumenHours(
                              day: "${dayDigimed[indexItem]}",
                              value: getHours(mapDay[indexItem]!),
                              context: context,
                              index: indexItem,
                              list: list,
                              doctorID: controller.doctorID!,
                              user: user,
                              onFinish: () async {
                                await controller.getDataDoctor(
                                    doctorDataState:
                                        const DoctorDataStateLoading());
                              });
                        }).toList()
                            // [
                            // GestureDetector(
                            //   onTap: () async {
                            //     bool? result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => SettingHoursAdminPage(
                            //                 user: user,
                            //                 listHours: list != null
                            //                     ? getAllWorkHours(0, list)
                            //                     : null,
                            //                 index: 0,
                            //                 doctorID: controller.doctorID!,
                            //               )),
                            //     );
                            //
                            //     await controller.getDataDoctor(
                            //         doctorDataState:
                            //             const DoctorDataStateLoading());
                            //     // pushNewPageAdminToSettingHours(context,
                            //     // user,
                            //     //     list != null
                            //     // ?getAllWorkHours(0,list)
                            //     // :null, 0,
                            //     // controller.doctorID!);
                            //   },
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             "${dayDigimed[keys[0]]}",
                            //             style: AppTextStyle.subW500NormalContentTextStyle,
                            //           ),
                            //           Text(
                            //             getHours(mapDay[0]!),
                            //             style:
                            //                 AppTextStyle.normalContentTextStyle,
                            //           ),
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       Icon(
                            //         Icons.arrow_forward_ios,
                            //         color: AppColors.backgroundColor,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Divider(color: AppColors.dividerColor,),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // GestureDetector(
                            //   onTap: () async {
                            //
                            //     bool? result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => SettingHoursAdminPage(
                            //             user: user,
                            //             listHours: list != null
                            //                 ? getAllWorkHours(1, list)
                            //                 : null,
                            //             index: 1,
                            //             doctorID: controller.doctorID!,
                            //           )),
                            //     );
                            //
                            //     await controller.getDataDoctor(
                            //         doctorDataState:
                            //         const DoctorDataStateLoading());
                            //
                            //     // pushNewPageAdminToSettingHours(
                            //     //     context,
                            //     //     user,
                            //     //     list != null
                            //     //         ? getAllWorkHours(1, list)
                            //     //         : null,
                            //     //     1,
                            //     //     controller.doctorID!);
                            //   },
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             "${dayDigimed[keys[1]]}",
                            //             style: AppTextStyle.subW500NormalContentTextStyle,
                            //           ),
                            //           Text(
                            //             getHours(mapDay[1]!),
                            //             style:
                            //                 AppTextStyle.normalContentTextStyle,
                            //           ),
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       Icon(
                            //         Icons.arrow_forward_ios,
                            //         color: AppColors.backgroundColor,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Divider(color: AppColors.dividerColor,),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // GestureDetector(
                            //   onTap: () async {
                            //     bool? result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => SettingHoursAdminPage(
                            //             user: user,
                            //             listHours: list != null
                            //                 ? getAllWorkHours(2, list)
                            //                 : null,
                            //             index: 2,
                            //             doctorID: controller.doctorID!,
                            //           )),
                            //     );
                            //
                            //     await controller.getDataDoctor(
                            //         doctorDataState:
                            //         const DoctorDataStateLoading());
                            //
                            //     // pushNewPageAdminToSettingHours(
                            //     //     context,
                            //     //     user,
                            //     //     list != null
                            //     //         ? getAllWorkHours(2, list)
                            //     //         : null,
                            //     //     2,
                            //     //     controller.doctorID!);
                            //   },
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             "${dayDigimed[keys[2]]}",
                            //             style: AppTextStyle.subW500NormalContentTextStyle,
                            //           ),
                            //           Text(
                            //             getHours(mapDay[2]!),
                            //             style:
                            //                 AppTextStyle.normalContentTextStyle,
                            //           ),
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       Icon(
                            //         Icons.arrow_forward_ios,
                            //         color: AppColors.backgroundColor,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Divider(color: AppColors.dividerColor,),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // GestureDetector(
                            //   onTap: () async {
                            //     bool? result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => SettingHoursAdminPage(
                            //             user: user,
                            //             listHours: list != null
                            //                 ? getAllWorkHours(3, list)
                            //                 : null,
                            //             index: 3,
                            //             doctorID: controller.doctorID!,
                            //           )),
                            //     );
                            //
                            //     await controller.getDataDoctor(
                            //         doctorDataState:
                            //         const DoctorDataStateLoading());
                            //   },
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             "${dayDigimed[keys[3]]}",
                            //             style: AppTextStyle.subW500NormalContentTextStyle,
                            //           ),
                            //           Text(
                            //             getHours(mapDay[3]!),
                            //             style:
                            //                 AppTextStyle.normalContentTextStyle,
                            //           ),
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       Icon(
                            //         Icons.arrow_forward_ios,
                            //         color: AppColors.backgroundColor,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Divider(color: AppColors.dividerColor,),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // GestureDetector(
                            //   onTap: ()async {
                            //     bool? result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => SettingHoursAdminPage(
                            //             user: user,
                            //             listHours: list != null
                            //                 ? getAllWorkHours(4, list)
                            //                 : null,
                            //             index: 4,
                            //             doctorID: controller.doctorID!,
                            //           )),
                            //     );
                            //
                            //     await controller.getDataDoctor(
                            //         doctorDataState:
                            //         const DoctorDataStateLoading());
                            //   },
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             "${dayDigimed[keys[4]]}",
                            //             style: AppTextStyle.subW500NormalContentTextStyle,
                            //           ),
                            //           Text(
                            //             getHours(mapDay[4]!),
                            //             style:
                            //                 AppTextStyle.normalContentTextStyle,
                            //           ),
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       Icon(
                            //         Icons.arrow_forward_ios,
                            //         color: AppColors.backgroundColor,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Divider(color: AppColors.dividerColor,),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // GestureDetector(
                            //   onTap: () async{
                            //     bool? result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => SettingHoursAdminPage(
                            //             user: user,
                            //             listHours: list != null
                            //                 ? getAllWorkHours(5, list)
                            //                 : null,
                            //             index: 5,
                            //             doctorID: controller.doctorID!,
                            //           )),
                            //     );
                            //
                            //     await controller.getDataDoctor(
                            //         doctorDataState:
                            //         const DoctorDataStateLoading());
                            //   },
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             "${dayDigimed[keys[5]]}",
                            //             style: AppTextStyle.subW500NormalContentTextStyle,
                            //           ),
                            //           Text(
                            //             getHours(mapDay[5]!),
                            //             style:
                            //                 AppTextStyle.normalContentTextStyle,
                            //           ),
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       Icon(
                            //         Icons.arrow_forward_ios,
                            //         color: AppColors.backgroundColor,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Divider(color: AppColors.dividerColor,),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // GestureDetector(
                            //   onTap: () async {
                            //     bool? result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => SettingHoursAdminPage(
                            //             user: user,
                            //             listHours: list != null
                            //                 ? getAllWorkHours(6, list)
                            //                 : null,
                            //             index: 6,
                            //             doctorID: controller.doctorID!,
                            //           )),
                            //     );
                            //
                            //     await controller.getDataDoctor(
                            //         doctorDataState:
                            //         const DoctorDataStateLoading());
                            //   },
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             "${dayDigimed[keys[6]]}",
                            //             style: AppTextStyle.subW500NormalContentTextStyle,
                            //           ),
                            //           Text(
                            //             getHours(mapDay[6]!),
                            //             style:
                            //                 AppTextStyle.normalContentTextStyle,
                            //           ),
                            //         ],
                            //       ),
                            //       Spacer(),
                            //       Icon(
                            //         Icons.arrow_forward_ios,
                            //         color: AppColors.backgroundColor,
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            //],
                            ),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 32,
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget ItemResumenHours(
      {required String day,
      required value,
      required BuildContext context,
      required User user,
      required List<WorkingHours>? list,
      required int doctorID,
      required VoidCallback onFinish,
      required int index}) {
    return GestureDetector(
      onTap: () async {
        bool? result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SettingHoursAdminPage(
                    user: user,
                    listHours: list != null ? getAllWorkHours(index, list) : null,
                    index: index,
                    doctorID: doctorID,
                  )),
        );

        onFinish();
      },
      child: Container(
        color: index % 2 == 0 ? AppColors.alteredColor : Colors.white,
        child: Container(
          margin: const EdgeInsets.only(top: 16, bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${day}",
                    style: AppTextStyle.subW500NormalContentTextStyle,
                  ),
                  Text(
                    value,
                    style: AppTextStyle.normal16W500ContentTextStyle,
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.backgroundColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
