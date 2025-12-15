import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_family_data.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_family_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardHistoryFamily extends StatelessWidget {
  const CardHistoryFamily({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
      child: CardDigimed(
          child: controller.state.isSettingDataFamilyHistoric
              ? const CardFamilySetting()
              : const CardFamilyData()
      ),
    );
  }
}
