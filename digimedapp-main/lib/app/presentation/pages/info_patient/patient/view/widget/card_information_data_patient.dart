import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/controller/info_patient_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardInformationDataPatient extends StatelessWidget {
  const CardInformationDataPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    print(size.height);
    return Container(
      height: 490,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 24,
            left: 24,
            child: Container(
              height: 490,
              child: CardDigimed(
                child: controller.state.dataPatientState.when(loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, failed: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, loaded: (patients) {
                  if (patients != null) {
                    return Container(
                      margin:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          AppColors.backgroundColor,
                                      radius: 5,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    const Text(
                                      "Tu Información",
                                      style: AppTextStyle
                                          .normal16W500ContentTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        DigimedIcon.edit,
                                        color: AppColors.backgroundColor,
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        controller
                                            .changedSettingStateInformationPatient();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  "Fecha de nacimiento",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  convertDate(patients.user.birthday),
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.normal17ContentTextStyle,
                                ),
                                const Divider(),
                                const Text(
                                  "Correo electrónico",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  patients.user.email,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.normal17ContentTextStyle,
                                ),
                                const Divider(),
                                const Text(
                                  "Teléfono",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  "${patients.user.countryCode}-${patients.user.phoneNumber}",
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.normal17ContentTextStyle,
                                ),
                                const Divider(),
                                const Text(
                                  "Ocupación o profesión",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  patients.user.occupation,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle
                                      .semiBold17W500ContentTextStyle,
                                ),
                                const Divider(),
                                const Text(
                                  "Peso",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  patients.user.weight != null
                                      ? "${showNumber2(patients.user.weight!)} kg"
                                      : "0 kg",
                                  softWrap: true,
                                  maxLines: 1,
                                  style: AppTextStyle.normal17ContentTextStyle,
                                ),
                                const Divider(),
                                const Text(
                                  "Estatura",
                                  style: AppTextStyle
                                      .subW500NormalContentTextStyle,
                                ),
                                Text(
                                  patients.user.height != null
                                      ? "${showNumber2(patients.user.height!)} m"
                                      : "0 kg",
                                  softWrap: true,
                                  maxLines: 1,
                                  style: AppTextStyle.normal17ContentTextStyle,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text("No hay datos registrados",));
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
