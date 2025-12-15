import 'package:digimed/app/data/providers/data_test/data_test.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/controller/state/info_doctor_admin_state.dart';
import 'package:digimed/app/presentation/pages/resumen_hours/admin/resumen_hours/controller/state/resumen_hours_state.dart';

class ResumeHoursDoctorController extends StateNotifier<ResumeHoursState>{
  final AccountRepository accountRepository;
  final int fatherId;

  ResumeHoursDoctorController(super._state, {
    required this.accountRepository,
    required this.fatherId});

  Future<void> init() async {
    await getDataDoctor();
  }

  Future<void> getDataDoctor() async {
    final result = await accountRepository.getDoctorWithPointsAndHours(fatherId);
    state = result.when(left: (failed) {
      return state.copyWith(doctorDataState:  DoctorDataState.faild(failed));
    }, right: (doctor) {
      // //TODO: Quitar el fake bloque de las hora
      // final listJson = List<Map<String, dynamic>>.from(listHoursFake['result']);
      // final d = listJson.map((e) => WorkingHours.fromJson(e)).toList();
      // // TODO: Quitar el fake bloque de las hora

      return state.copyWith(doctorDataState: DoctorDataState.sucess(
          user: doctor.user, list: doctor.hours,doctorUserPointsHours: doctor));
    });
  }
}