import 'package:freezed_annotation/freezed_annotation.dart';
import '../medication/medication.dart';

part 'treatment_input.freezed.dart';
part 'treatment_input.g.dart';

@freezed
class TreatmentInput with _$TreatmentInput {
  const factory TreatmentInput({
    required String name,
    required int duration,
    @JsonKey(name: 'doctor_id')
    required int doctorId,
    String? note,
    required List<Medication> medications,
  }) = _TreatmentInput;

  factory TreatmentInput.fromJson(Map<String, dynamic> json) => _$TreatmentInputFromJson(json);
}
