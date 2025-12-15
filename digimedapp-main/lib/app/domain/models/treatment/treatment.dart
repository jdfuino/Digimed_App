import 'package:digimed/app/domain/constants/treatment_status.dart';
import 'package:digimed/app/domain/models/medication/medication.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'treatment.freezed.dart';

part 'treatment.g.dart';

@freezed
class Treatment with _$Treatment {
  const factory Treatment({
    @JsonKey(name: 'ID') required int id,
    @JsonKey(name: 'Name') required String name,
    @JsonKey(name: 'Duration') required int duration,
    @JsonKey(name: 'CreatedAt') required String createdAt,
    @JsonKey(name: 'DoctorID') required int doctorId,
    @JsonKey(name: 'Status', fromJson: _statusFromJson, toJson: _statusToJson)
    required TreatmentStatus status,
    String? note,
    @JsonKey(name: 'Medications') required List<Medication> medications,
    @JsonKey(name: 'StartedOn') String? startedOn,
    @JsonKey(name: 'FinishedOn') String? finishedOn,
  }) = _Treatment;

  const Treatment._();

  factory Treatment.fromJson(Map<String, dynamic> json) =>
      _$TreatmentFromJson(json);

  /// Check if treatment is active (in progress)
  bool get isActive => status == TreatmentStatus.inProgress;

  /// Check if treatment is completed
  bool get isCompleted => status == TreatmentStatus.completed;

  /// Check if treatment is pending
  bool get isPending => status == TreatmentStatus.pendingToStart;

  /// Check if treatment is paused
  bool get isPaused => status == TreatmentStatus.paused;

  /// Get formatted duration text
  String get formattedDuration {
    if (duration == 1) return "1 día";
    if (duration < 30) return "$duration días";
    if (duration == 30) return "1 mes";
    if (duration < 365) {
      final months = (duration / 30).round();
      return months == 1 ? "1 mes" : "$months meses";
    }
    final years = (duration / 365).round();
    return years == 1 ? "1 año" : "$years años";
  }

  /// Get medications count
  int get medicationsCount => medications.length;
}

/// Convert string status from JSON to TreatmentStatus enum
TreatmentStatus _statusFromJson(String status) =>
    TreatmentStatus.fromString(status);

/// Convert TreatmentStatus enum to string for JSON
String _statusToJson(TreatmentStatus status) => status.value;
