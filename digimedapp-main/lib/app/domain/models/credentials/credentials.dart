import 'package:freezed_annotation/freezed_annotation.dart';

part 'credentials.freezed.dart';
part 'credentials.g.dart';

@freezed
class Credential with _$Credential {
  const factory Credential({
    required String? username,
    required String? password,
  }) = _Credentials;

  const Credential._();

  factory Credential.fromJson(Map<String, dynamic> json) => _$CredentialFromJson(json);
}
