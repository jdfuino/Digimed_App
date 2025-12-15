import 'package:freezed_annotation/freezed_annotation.dart';

part 'uric_acid_fake.freezed.dart';

part 'uric_acid_fake.g.dart';

@freezed
class UricAcidFake with _$UricAcidFake {
  const factory UricAcidFake({
    @JsonKey(name: 'id') required double? id,
    @JsonKey(name: 'Uric_acid') required double? uricAcidFake,
    @JsonKey(name: 'created_at') required String? createdAt,
  }) = _UricAcidFake;

  const UricAcidFake._();

  factory UricAcidFake.fromJson(Map<String, dynamic> json) =>
      _$UricAcidFakeFromJson(json);
}