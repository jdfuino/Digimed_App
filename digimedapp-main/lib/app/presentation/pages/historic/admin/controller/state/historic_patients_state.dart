import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/profile_cardiovascular/profile_cardiovascular.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/uric_acid_fake/uric_acid_fake.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'historic_patients_state.freezed.dart';

@freezed
class HistoricPatientsState with _$HistoricPatientsState {
  const factory HistoricPatientsState({
    @Default(BloodPressureDataState.loading())
    BloodPressureDataState bloodPressureDataState,
    @Default(HeartFrequencyDataState.loading())
    HeartFrequencyDataState heartFrequencyDataState,
    @Default(GlucoseDataState.loading()) GlucoseDataState glucoseDataState,
    @Default(TriglyceridesDataState.loading())
    TriglyceridesDataState triglyceridesDataState,
    @Default(CholesterolDataState.loading())
    CholesterolDataState cholesterolDataState,
    @Default(HemoglobinDataState.loading())
    HemoglobinDataState hemoglobinDataState,
    @Default(UricAcidDataState.loading())
    UricAcidDataState uricAcidDataState,
    @Default(true) bool isFetch,
  }) = _HistoricPatientsState;
}

@freezed
class BloodPressureDataState with _$BloodPressureDataState {
  const factory BloodPressureDataState.loading() =
      BloodPressureDataStateLoading;

  const factory BloodPressureDataState.failed(
      HttpRequestFailure failure
      ) = BloodPressureDataStateFailed;

  const factory BloodPressureDataState.nullData() = BloodPressureDataStateNullData;

  const factory BloodPressureDataState.loaded(
    List<ProfileCardiovascular>? listBloodPressure,
  ) = BloodPressureDataStateLoaded;
}

@freezed
class HeartFrequencyDataState with _$HeartFrequencyDataState {
  const factory HeartFrequencyDataState.loading() =
      HeartFrequencyDataStateLoading;

  const factory HeartFrequencyDataState.failed(
      HttpRequestFailure failure
      ) =
      HeartFrequencyDataStateFailed;

  const factory HeartFrequencyDataState.nullData() = HeartFrequencyDataStateNullData;

  const factory HeartFrequencyDataState.loaded(
    List<ProfileCardiovascular>? listFrequencyData,
  ) = HeartFrequencyDataStateLoaded;
}

@freezed
class GlucoseDataState with _$GlucoseDataState {
  const factory GlucoseDataState.loading() = GlucoseDataStateLoading;

  const factory GlucoseDataState.failed(
      HttpRequestFailure failure
      ) = GlucoseDataStateFailed;

  const factory GlucoseDataState.nullData() = GlucoseDataStateNullData;

  const factory GlucoseDataState.loaded(
    List<ProfileLaboratory>? listGlucoseData,
  ) = GlucoseDataStateLoaded;
}

@freezed
class TriglyceridesDataState with _$TriglyceridesDataState {
  const factory TriglyceridesDataState.loading() =
      TriglyceridesDataStateLoading;

  const factory TriglyceridesDataState.failed(
      HttpRequestFailure failure
      ) = TriglyceridesDataStateFailed;

  const factory TriglyceridesDataState.nullData() = TriglyceridesDataStateNullData;

  const factory TriglyceridesDataState.loaded(
    List<ProfileLaboratory>? listTriglyceridesData,
  ) = TriglyceridesDataStateLoaded;
}

@freezed
class CholesterolDataState with _$CholesterolDataState {
  const factory CholesterolDataState.loading() = CholesterolDataStateLoading;

  const factory CholesterolDataState.failed(
      HttpRequestFailure failure
      ) = CholesterolDataStateFailed;

  const factory CholesterolDataState.nullData() = CholesterolDataStateNullData;

  const factory CholesterolDataState.loaded(
    List<ProfileLaboratory>? listCholesterolData,
  ) = CholesterolDataStateLoaded;
}

@freezed
class HemoglobinDataState with _$HemoglobinDataState {
  const factory HemoglobinDataState.loading() = HemoglobinDataStateLoading;

  const factory HemoglobinDataState.failed(
      HttpRequestFailure failure
      ) = HemoglobinDataStateFailed;

  const factory HemoglobinDataState.nullData() = HemoglobinDataStateNullData;

  const factory HemoglobinDataState.loaded(
    List<ProfileLaboratory>? listHemoglobinData,
  ) = HemoglobinDataStateLoaded;
}

@freezed
class UricAcidDataState with _$UricAcidDataState {
  const factory UricAcidDataState.loading() = UricAcidDataStateLoading;

  const factory UricAcidDataState.failed(
      HttpRequestFailure failure
      ) = UricAcidDataStateFailed;

  const factory UricAcidDataState.nullData() = UricAcidDataStateNullData;

  const factory UricAcidDataState.loaded(
    List<ProfileLaboratory>? listUricAcidData,
  ) = UricAcidDataStateLoaded;
}