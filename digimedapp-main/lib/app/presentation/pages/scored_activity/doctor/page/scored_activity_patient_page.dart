import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/widgets/banner_points_doctor.dart';
import 'package:digimed/app/presentation/global/widgets/banner_points_loading.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/scored_activity/doctor/controller/state/scroed_activity_doctor_state.dart';
import 'package:digimed/app/presentation/pages/scored_activity/patient/controller/state/scored_activity_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/scored_activity_doctor_controller.dart';

class ScoredActivityDoctorPage extends StatelessWidget {
  final int userID;
  final int totalScored;

  const ScoredActivityDoctorPage(
      {super.key, required this.userID, required this.totalScored});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
      ScoredActivityController(ScoredActivityDoctorState(),
          accountRepository: Repositories.account,
          sessionController: context.read(),
          userID: userID)
        ..init(),
      child: MyScaffold(body: Builder(builder: (context) {
        final controller = Provider.of<ScoredActivityController>(
          context,
          listen: true,
        );
        return SingleChildScrollView(
            child:
            controller.state.activityDataState.when(
                loading: () {
                  return BannerPointsLoading(totalScored: totalScored);
                }, failed: (failure) {
              failure.maybeWhen(
                  tokenInvalided: (){
                    closeSession(context: context);
                  }
                  ,orElse: (){});
              return BannerPointsLoading(totalScored: totalScored);
            }, loaded: (list) {
              return BannerPointsDoctor(totalScored: totalScored, myActivity: list);
            })
        );
      })),
    );
  }
}
