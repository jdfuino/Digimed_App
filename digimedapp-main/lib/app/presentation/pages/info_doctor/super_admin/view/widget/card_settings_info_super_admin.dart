import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/info_doctor/super_admin/controller/info_doctor_super_admin_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class CardSettingInfoSuperAdmin extends StatelessWidget {
  const CardSettingInfoSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoDoctorSuperAdminController controller = Provider.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24),
      child: CardDigimed(
        child: controller.state.doctorDataInfoState.when(loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }, faild: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }, sucess: (userTemp, _, __) {
          return _formNormal(
              date: convertDate(controller.userTemp.birthday),
              email: controller.userTemp.email,
              phone: controller.userTemp.phoneNumber,
              countryCode: controller.userTemp.countryCode,
              occupation: controller.userTemp.occupation,
              tapButton: controller.settingChanged);
        }),
      ),
    );
  }

  Widget _formNormal(
      {required String date,
      required String email,
      required String countryCode,
      required String phone,
      required String occupation,
      required Function tapButton}) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fecha de nacimiento",
                style: AppTextStyle.subW500NormalContentTextStyle,
              ),
              Text(
                date,
                style: AppTextStyle.normal17ContentTextStyle,
              ),
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Correo electrónico",
                style: AppTextStyle.subW500NormalContentTextStyle,
              ),
              Container(
                width: double.maxFinite,
                child: Text(
                  email,
                  style: AppTextStyle.normal17ContentTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Teléfono",
                style: AppTextStyle.subW500NormalContentTextStyle,
              ),
              Container(
                width: double.maxFinite,
                child: Text(
                  "$countryCode-$phone",
                  style: AppTextStyle.normal17ContentTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Especialidad",
                style: AppTextStyle.subW500NormalContentTextStyle,
              ),
              Container(
                width: double.maxFinite,
                child: Text(
                  occupation,
                  style: AppTextStyle.normal17ContentTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
