import 'package:digimed/app/domain/models/user_doctor_compact/user_doctor_compact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_doctors.freezed.dart';
part 'item_doctors.g.dart';

@freezed
class ItemDoctors with _$ItemDoctors {
  factory ItemDoctors({
    @JsonKey(name: 'User') required UserDoctorCompact user,
    @JsonKey(name: 'PatientsCount') required int patientsCount,
  }) = _ItemDoctors;

  const ItemDoctors._();
  factory ItemDoctors.fromJson(Map<String, dynamic> json) =>
      _$ItemDoctorsFromJson(json);
}
