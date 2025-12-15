import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures_form_historic_setting.freezed.dart';

@freezed
class FailuresFormHistoricSetting with _$FailuresFormHistoricSetting {
  factory FailuresFormHistoricSetting.dataForComplete() =
      FailuresFormHistoricSettingDataForComplete;
  factory FailuresFormHistoricSetting.dataInvalid() =
  FailuresFormHistoricSettingDataInvalid;
}
