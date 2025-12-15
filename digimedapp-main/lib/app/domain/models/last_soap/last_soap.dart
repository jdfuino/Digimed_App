import 'package:digimed/app/domain/models/soap_note/soap_note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_soap.freezed.dart';
part 'last_soap.g.dart';

@freezed
class LastSOAP with _$LastSOAP{
  const factory LastSOAP({
    @JsonKey(name: 'Subjective')
    SOAPNote? subjective,
    @JsonKey(name: 'Objective')
    SOAPNote? objective,
    @JsonKey(name: 'Assessment')
    SOAPNote? assessment,
    @JsonKey(name: 'Plan')
    SOAPNote? plan
  }) = _LastSOAP;

  const LastSOAP._();

  factory LastSOAP.fromJson(Map<String, dynamic> json) => _$LastSOAPFromJson(json);
}
