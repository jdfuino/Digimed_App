import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_profile_lab/view/form_new_profile_lab_sheet.dart';
import 'package:digimed/app/presentation/global/widgets/sheet_profile_lab/sheet_profile_lab.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/state/home_patient_super_admin_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardLabSuperAdmin extends StatelessWidget {
  const CardLabSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: size.height * 0.40,
          margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
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
                          right: 24, left: 24, bottom: 16, top: 16),
                      child: ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            final item = list[index];
                            return _itemLab(context, item, size);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
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
        Container(
          margin:
              const EdgeInsets.only(right: 24, left: 24),
          child: ButtonDigimed(
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
                            await controller.getDataPatient(
                              patientState: const PatientStateLoading()
                            );
                            await controller.getResultsLabs(
                                resultLabState: const ResultLabStateLoading());
                          },
                        ));
              }),
        )
      ],
    );
  }

  Widget _itemLab(BuildContext context, ProfileLaboratory item, Size size) {
    final HomePatientSuperAdminController controller = Provider.of(context);
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
            builder: (_) => SheetProfileLab(item: item,
                gender: controller.patients.user.gender));
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
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
              Assets.svgs.fileLab.svg()
            ],
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
