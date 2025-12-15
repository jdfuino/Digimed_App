import 'package:freezed_annotation/freezed_annotation.dart';

part 'soap_note.freezed.dart';
part 'soap_note.g.dart';

@freezed
class SOAPNote with _$SOAPNote{
  const factory SOAPNote({
    @JsonKey(name: 'Note')
    required String note,
    @JsonKey(name: 'LastUpdatedAt')
    required String date
}) = _SOAPNote;

  const SOAPNote._();

  factory SOAPNote.fromJson(Map<String, dynamic> json) => _$SOAPNoteFromJson(json);
}