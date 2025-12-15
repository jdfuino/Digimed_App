import 'package:digimed/app/domain/models/notification_model/notification_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'identification_type') required String identificationType,
    @JsonKey(name: 'identification_number')
    required String identificationNumber,
    required String email,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'country_code') required String countryCode,
    @JsonKey(name: 'ocupation') required String occupation,
    required String birthday,
    String? password,
    @Default("") String gender,
    @JsonKey(name: 'profile_img_url') String? urlImageProfile,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    @JsonKey(name: 'role') required String rol,
    @JsonKey(name: 'fcm_token') String? fcmToken,
    double? weight,
    double? height,
    @Default([])
    List<NotificationModel> notifications,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
