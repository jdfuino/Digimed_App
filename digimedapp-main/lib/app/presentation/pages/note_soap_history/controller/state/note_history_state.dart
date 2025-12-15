import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/soap_note/soap_note.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_history_state.freezed.dart';

@freezed
class NoteHistoryState with _$NoteHistoryState {
  const factory NoteHistoryState(
          {@Default(SOAPNoteState.loading()) SOAPNoteState soapNoteState,
          @Default(RequestState.normal()) RequestState requestState}) =
      _NoteHistoryState;
}

@freezed
class SOAPNoteState with _$SOAPNoteState {
  const factory SOAPNoteState.loading() = SOAPNoteStateLoading;

  const factory SOAPNoteState.failed(HttpRequestFailure failed) =
      SOAPNoteStateFailed;

  const factory SOAPNoteState.loaded(
    List<SOAPNote> listSOAPNote,
  ) = SOAPNoteStateLoaded;
}
