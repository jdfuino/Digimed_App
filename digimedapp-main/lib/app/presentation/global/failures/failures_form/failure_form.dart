import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure_form.freezed.dart';

@freezed
class FailuresForm with _$FailuresForm {
  factory FailuresForm.autDataGender() =FailuresFormAutDataGender;
  factory FailuresForm.phoneNumber() =FailuresFormPhoneNumber;
  factory FailuresForm.unknown() =FailuresFormUnknown;
}
