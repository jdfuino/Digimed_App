import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_hours_admin_state.freezed.dart';

@freezed
class SettingHoursAdminState with _$SettingHoursAdminState {
  factory SettingHoursAdminState({
    @Default(false) bool isEnabled,
    @Default(SettingAdminState.normal()) SettingAdminState
    settingAdminState,
  }) = _SettingHoursAdminState;
}

@freezed
class SettingAdminState with _$SettingAdminState{
  const factory SettingAdminState.loading() = SettingAdminStateLoading;
  const factory SettingAdminState.normal() = SettingAdminStateNormal;
}