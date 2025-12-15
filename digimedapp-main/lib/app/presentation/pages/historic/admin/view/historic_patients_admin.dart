import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_simple_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/state/historic_patients_state.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/cardio_tab.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/heart_rate_tab.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/lab_tab.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_family_data.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_family.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_habit.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_pathology.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoricPatientsAdmin extends StatefulWidget {
  final int patientID;
  const HistoricPatientsAdmin({super.key, required this.patientID});

  @override
  State<HistoricPatientsAdmin> createState() => _HistoricPatientsAdminState();
}

class _HistoricPatientsAdminState extends State<HistoricPatientsAdmin>  with
TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return ChangeNotifierProvider(
        create: (_) => HistoricPatientsController(const HistoricPatientsState(),
            accountRepository: Repositories.account,
            sessionController: context.read(),
            patientId: widget.patientID)
          ..init(),
      child: MyScaffold(
          body: Builder(
            builder: (context) {
              final controller = Provider.of<HistoricPatientsController>(
                context,
                listen: true,
              );
              return Column(
                children: [
                  BannerSimpleDigimed(
                      textLeft: "Historial",
                      iconLeft: DigimedIcon.history,
                      tabController: tabController,
                      iconRight: DigimedIcon.back,
                      onClickIconRight: () {
                        Navigator.of(context).pop();
                      }),
                  Expanded(child:
                  TabBarView(controller: tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const TabCardio(),
                        const HeartRateTab(),
                        const LabTab(),
                      ]))
                ],
              );
            }
          )),
    );
  }
}
