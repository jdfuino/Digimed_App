import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_input.freezed.dart';
part 'user_input.g.dart';

@freezed
class UserInput with _$UserInput{
  const factory UserInput({
    @JsonKey(name: 'full_name')
    required String fullName,
    required String email,
    required String password,
    required String gender,
    @JsonKey(name: 'identification_type')
    required String identificationType,
    @JsonKey(name: 'identification_number')
    required String identificationNumber,
    @JsonKey(name: 'country_code')
    required String countryCode,
    @JsonKey(name: 'phone_number')
    required String phoneNumber,
    @JsonKey(name: 'ocupation')
    required String occupation,
    required String birthday,
    double? weight,
    double? height,
}) = _UserInput;

  const UserInput._();

  factory UserInput.fromJson(Map<String, dynamic> json) => _$UserInputFromJson(json);
}