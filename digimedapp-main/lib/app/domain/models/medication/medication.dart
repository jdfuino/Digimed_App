import 'package:freezed_annotation/freezed_annotation.dart';

part 'medication.freezed.dart';

part 'medication.g.dart';

@freezed
class Medication with _$Medication {
  const factory Medication({
    @JsonKey(name: 'Name') required String name,
    @JsonKey(name: 'Dose') required int dose,
    @JsonKey(name: 'DoseUnit') required String doseUnit,
    @JsonKey(name: 'Frequency') required int frequency,
  }) = _Medication;

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);
}
