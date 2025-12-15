import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_simple_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/state/historic_patients_state.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/cardio_tab.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/heart_rate_tab.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/widget/lab_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoricPatientPage extends StatefulWidget {
  final int patientID;
  const HistoricPatientPage({super.key, required this.patientID});

  @override
  State<HistoricPatientPage> createState() => _HistoricPatientPageState();
}

class _HistoricPatientPageState extends State<HistoricPatientPage> with
    TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    return ChangeNotifierProvider(
      create: (_) => HistoricPatientsController(const HistoricPatientsState(),
          sessionController: context.read(),
          accountRepository: Repositories.account, patientId: widget.patientID)
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
                        iconRight: DigimedIcon.whatsapp,
                        onClickIconRight: () {

                        }),
                    Expanded(child:
                    TabBarView(controller: tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          TabCardio(),
                          HeartRateTab(),
                          LabTab(),
                        ]))
                  ],
                );
              }
          )),
    );
  }
}
