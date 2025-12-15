import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/recipe/recipe.dart';
import 'package:digimed/app/domain/models/report/report.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_patient_super_admin_state.freezed.dart';

@freezed
class HomePatientSuperAdminState with _$HomePatientSuperAdminState {
  const factory HomePatientSuperAdminState(
          {@Default(PatientState.loading()) PatientState patientState,
          @Default(ViewState.clinicState()) ViewState viewState,
          @Default(ResultLabState.loading()) ResultLabState resultLabState,
          @Default(DoctorSpecialistState.loading())
          DoctorSpecialistState doctorSpecialistState,
          @Default(false) bool isSettingDataBasic,
          @Default(false) bool isSettingDataPathology,
          @Default(false) bool isSettingDataFamilyHistoric,
          @Default(false) bool isSettingDataHabit,
          @Default(false) bool isSettingDataS,
          @Default(false) bool isSettingDataO,
          @Default(false) bool isSettingDataA,
          @Default(false) bool isSettingDataP,
          @Default(false) bool isFetch,
          @Default(ReportFetchState.loading()) ReportFetchState reportFetchState,
            @Default(RecipeFetchState.loading()) RecipeFetchState recipeFetchState,
          @Default(RequestState.normal()) RequestState requestState}) =
      _HomePatientSuperAdminState;
}

@freezed
class ResultLabState with _$ResultLabState {
  const factory ResultLabState.loading() = ResultLabStateLoading;

  const factory ResultLabState.failed(HttpRequestFailure failed) =
      ResultLabStateFailed;

  const factory ResultLabState.loaded(
    List<ProfileLaboratory>? list,
  ) = ResultLabStateLoaded;
}

@freezed
class PatientState with _$PatientState {
  const factory PatientState.loading() = PatientStateLoading;

  const factory PatientState.failed(HttpRequestFailure failed) =
      PatientStateFailed;

  const factory PatientState.loaded(
    Patients patients,
  ) = PatientStateLoaded;
}

@freezed
class ViewState with _$ViewState {
  const factory ViewState.clinicState() = ViewStateClinicState;

  const factory ViewState.labState() = ViewStateLabState;

  const factory ViewState.historicClinic(
      {@Default(HistoricClinicState.dataBasic())
      HistoricClinicState historicClinicState}) = ViewStateHistoricClinic;
}

@freezed
class HistoricClinicState with _$HistoricClinicState {
  const factory HistoricClinicState.dataBasic() = HistoricClinicStateDataBasic;

  const factory HistoricClinicState.dataPathology() =
      HistoricClinicStateDataPathology;

  const factory HistoricClinicState.dataFamilyHistoric() =
      HistoricClinicStateDataFamilyHistoric;

  const factory HistoricClinicState.dataHabit() = HistoricClinicStateDataHabit;

  const factory HistoricClinicState.dataFallowed() =
      HistoricClinicStateDataFallowed;

  const factory HistoricClinicState.dataSO() = HistoricClinicStateDataSO;

  const factory HistoricClinicState.dataAP() = HistoricClinicStateDataAP;

  const factory HistoricClinicState.dataSpecialist() =
      HistoricClinicStateDataSpecialist;

  const factory HistoricClinicState.reports() =
      HistoricClinicStateReports;

  const factory HistoricClinicState.prescription() =
  HistoricClinicStatePrescription;
}

@freezed
class DoctorSpecialistState with _$DoctorSpecialistState {
  const factory DoctorSpecialistState.loading() = DoctorSpecialistStateLoading;

  const factory DoctorSpecialistState.failed(HttpRequestFailure failed) =
      DoctorSpecialistStateFailed;

  const factory DoctorSpecialistState.loaded(
    List<DoctorSpecialists> list,
  ) = DoctorSpecialistStateLoaded;
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