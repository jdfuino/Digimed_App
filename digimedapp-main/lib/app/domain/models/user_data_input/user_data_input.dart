import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data_input.freezed.dart';
part 'user_data_input.g.dart';

@freezed
class UserDataInput with _$UserDataInput{
  const factory UserDataInput({
    String? birthday,
    String? email,
    @JsonKey(name: 'country_code')
    String? countryCode,
    @JsonKey(name: 'phone_number')
    String? phoneNumber,
    @JsonKey(name: 'ocupation')
    String? occupation,
    double? weight,
    double? height,
    @JsonKey(name: 'fcm_token') String? fcmToken,
}) = _UserDataInput;

  const UserDataInput._();

  factory UserDataInput.fromJson(Map<String, dynamic> json) =>
      _$UserDataInputFromJson(json);
}