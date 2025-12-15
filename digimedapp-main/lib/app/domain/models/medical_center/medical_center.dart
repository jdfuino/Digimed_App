import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_center.freezed.dart';
part 'medical_center.g.dart';

@freezed
class MedicalCenter with _$MedicalCenter {
  const factory MedicalCenter({
    @JsonKey(name: 'ID') required int id,
    @JsonKey(name: 'Name') required String name,
    @JsonKey(name: 'Address') required String address,
    @JsonKey(name: 'Hospitalization') required bool hospitalization,
    @JsonKey(name: 'Emergencies') required bool emergencies,
    @JsonKey(name: 'Laboratory') required bool laboratory,
    @JsonKey(name: 'Imaging') required bool imaging,
    @JsonKey(name: 'Radiology') required bool radiology,
    @JsonKey(name: 'TotalDoctors') required int totalDoctors,
    @JsonKey(name: 'LogoUrl') String? logoUrl,
    @JsonKey(name: 'Latitude') double? latitude,
    @JsonKey(name: 'Longitude') double? longitude,
    @JsonKey(name: 'SpecialtiesCount') required int specialtiesCount,
    // @JsonKey(name: 'Specialties') List<dynamic>? specialties,
    @JsonKey(name: 'CreatedAt') String? createdAt,
    @JsonKey(name: 'UpdatedAt') String? updatedAt,
  }) = _MedicalCenter;

  const MedicalCenter._();

  factory MedicalCenter.fromJson(Map<String, dynamic> json) =>
      _$MedicalCenterFromJson(json);
}
