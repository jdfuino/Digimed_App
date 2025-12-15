import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/recipe/recipe.dart';
import 'package:digimed/app/domain/models/report/report.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reports_patient_state.freezed.dart';

@freezed
class ReportsPatientState with _$ReportsPatientState {
  factory ReportsPatientState({
   @Default(DataDoctorState.loading()) DataDoctorState dataDoctorState,
   @Default(ReportFetchState.loading()) ReportFetchState reportFetchState,
    @Default(RecipeFetchState.loading()) RecipeFetchState recipeFetchState,
  }) = _ReportsPatientState;
}

@freezed
class ReportFetchState with _$ReportFetchState{
  const factory ReportFetchState.loading() = ReportFetchStateLoading;

  const factory ReportFetchState.loaded(
      List<Report> listReport
      ) = ReportFetchStateLoaded;
}

@freezed
class RecipeFetchState with _$RecipeFetchState{
  const factory RecipeFetchState.loading() = RecipeFetchStateLoading;

  const factory RecipeFetchState.loaded(
      List<Recipe> listReport
      ) = RecipeFetchStateLoaded;
}

@freezed
class DataDoctorState with _$DataDoctorState {
  const factory DataDoctorState.loading() = DataDoctorStateLoading;

  const factory DataDoctorState.failed() = DataDoctorStateFailed;

  const factory DataDoctorState.loaded(Doctor? meDoctor) =
      DataDoctorStateLoaded;
}