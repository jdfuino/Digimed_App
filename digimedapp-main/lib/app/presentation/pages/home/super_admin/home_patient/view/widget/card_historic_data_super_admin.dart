import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_clinic_data_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_clinic_setting_super_admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardHistoricDataSuperAdmin extends StatelessWidget {
  const CardHistoricDataSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
      child: CardDigimed(
        child: controller.state.isSettingDataBasic
            ? const CardClinicSettingSuperAdmin()
            : const CardClinicDataSuperAdmin()
      ),
    );
  }
}
