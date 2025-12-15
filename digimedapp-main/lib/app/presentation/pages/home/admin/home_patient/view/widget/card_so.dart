import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_o_data.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_o_setting.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_s_data.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_s_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CardSO extends StatelessWidget {
  const CardSO({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
        child: Column(
          children: [
            CardDigimed(
              child: controller.state.isSettingDataS
                  ? const CardSSetting()
                  : const CardSData(),
            ),
            SizedBox(height: size.height * 0.03,),
            CardDigimed(
              child: controller.state.isSettingDataO
                  ? const CardOSetting()
                  : const CardOData(),
            )
          ],
        ));
  }
}
