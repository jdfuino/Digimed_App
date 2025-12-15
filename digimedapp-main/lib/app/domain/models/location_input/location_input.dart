import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_input.freezed.dart';
part 'location_input.g.dart';

@freezed
class LocationInput with _$LocationInput{
  const factory LocationInput({
    @JsonKey(name: 'UserID') required int userID,
    @JsonKey(name: 'Latitude') required double latitude,
    @JsonKey(name: 'Longitude') required double longitude,
  }) = _LocationInput;

  const LocationInput._();

  factory LocationInput.fromJson(Map<String, dynamic> json) =>
      _$LocationInputFromJson(json);
}

