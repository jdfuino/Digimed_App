import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/icons/i_a_icons_icons.dart';
import 'package:digimed/app/presentation/global/icons/tools_dimed_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_profile_lab/view/form_new_profile_lab_sheet.dart';
import 'package:digimed/app/presentation/global/widgets/sheet_profile_lab/sheet_edit_profile_lab.dart';
import 'package:digimed/app/presentation/global/widgets/sheet_profile_lab/sheet_profile_lab.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardLabPatient extends StatelessWidget {
  const CardLabPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
      child: Column(
        children: [
          Container(
            height: size.height * 0.40,
            child: CardDigimed(
              child: controller.state.resultLabState.when(loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }, failed: (failed) {
                failed.when(
                    notFound: () => errorMessage(),
                    network: () => errorMessage(),
                    emailExist: () => errorMessage(),
                    unauthorized: () => errorMessage(),
                    tokenInvalided: () {
                      closeSession(context: context);
                    },
                    unknown: () => errorMessage(),
                    formData: (String message) {
                      showToast(message);
                    });
                return Center(child: errorMessage());
              }, loaded: (list) {
                return list != null && list.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(
                            right: 24, left: 24, bottom: 16, top: 24),
                        child: ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              final item = list[index];
                              return _itemLab(context, item, size);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: list.length),
                      )
                    : errorMessage();
              }),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ButtonDigimed(
              height: 60,
              child: Text(
                "Agregar nuevo resultado",
                style: AppTextStyle.normalWhiteContentTextStyle,
              ),
              onTab: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(maxWidth: size.width * 0.92),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    builder: (_) => FormNewProfileLabSheet(
                          patientId: controller.patients.patientID,
                          onFinish: () async {
                            await controller.getResultsLabs(
                                resultLabState: const ResultLabStateLoading());
                          },
                        ));
              })
        ],
      ),
    );
  }

  Widget _itemLab(BuildContext context, ProfileLaboratory item, Size size) {
    final HomePatientAdminController controller = Provider.of(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            constraints: BoxConstraints(maxWidth: size.width * 0.92),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (_) => SheetProfileLab(
                  item: item,
                  gender: controller.patients.user.gender,
                ));
      },
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.svgs.warningFile.svg(),
                Spacer(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Exámen de laboratorio",
                        style: AppTextStyle.su14bW400NormalContentTextStyle,
                      ),
                      Text(
                        convertDate(item.createdAt),
                        style: AppTextStyle.boldContentTextStyle,
                      )
                    ],
                  ),
                ),
                Spacer(),
                _dropMenu(context, item, size),
              ],
            ),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget _dropMenu(BuildContext context, ProfileLaboratory item, Size size) {
    final HomePatientAdminController controller = Provider.of(context);
    return PopupMenuButton<String>(
      icon: const Icon(
        ToolsDimed.icon_tools,
        color: AppColors.backgroundColor,
        size: 22,
      ),
      onSelected: (String value) async {
        switch (value) {
          case "more":
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                constraints: BoxConstraints(maxWidth: size.width * 0.92),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (_) => SheetProfileLab(
                      item: item,
                      gender: controller.patients.user.gender,
                    ));
            break;
          case "editar_lab":
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                constraints: BoxConstraints(maxWidth: size.width * 0.92),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (_) => SheetEditProfileLab(
                      item: item,
                      gender: controller.patients.user.gender,
                      onComplete: (item, id) {
                        controller.updateResultLab(
                            profileLaboratory: item, idResultLab: id);
                      },
                    ));
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: "more",
            child: Row(
              children: [
                Icon(
                  DigimedIcon.exam,
                  color: AppColors.backgroundColor,
                  size: 25,
                ),
                SizedBox(width: 8),
                Text('Ver más'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: "editar_lab",
            child: Row(
              children: [
                Icon(
                  DigimedIcon.edit,
                  color: AppColors.backgroundColor,
                  size: 25,
                ),
                SizedBox(width: 8),
                Text('Editar registro'),
              ],
            ),
          )
        ];
      },
    );
  }
}
