import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinator_medical_center.freezed.dart';
part 'coordinator_medical_center.g.dart';

@freezed
class CoordinatorMedicalCenter with _$CoordinatorMedicalCenter {
  const factory CoordinatorMedicalCenter({
    required String name,
    @JsonKey(name: 'imagen_logo') required String imagenLogo,
    required int age,
    required String position,
    required int patients,
    required String phone,
    required String department,
  }) = _CoordinatorMedicalCenter;

  const CoordinatorMedicalCenter._();

  factory CoordinatorMedicalCenter.fromJson(Map<String, dynamic> json) =>
      _$CoordinatorMedicalCenterFromJson(json);
}