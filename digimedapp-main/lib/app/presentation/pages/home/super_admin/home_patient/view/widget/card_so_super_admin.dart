import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_o_data_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_s_data_super_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CardSOSuperAdmin extends StatelessWidget {
  const CardSOSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientSuperAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
        child: Column(
          children: [
            CardDigimed(
              child: const CardSDataSuperAdmin(),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            CardDigimed(
              child: const CardODataSuperAdmin(),
            )
          ],
        ));
  }
}
