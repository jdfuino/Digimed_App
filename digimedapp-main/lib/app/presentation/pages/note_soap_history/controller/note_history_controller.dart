import 'package:digimed/app/data/providers/data_test/data_test.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/soap_note/soap_note.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/state_notifier.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_doctor/controller/state/form_new_doctor_state.dart';
import 'package:digimed/app/presentation/pages/note_soap_history/controller/state/note_history_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';

class NoteHistoryController extends StateNotifier<NoteHistoryState> {
  final AccountRepository accountRepository;
  final SessionController sessionController;
  final int userID;
  Patients fatherPatient;
  final String soapId;

  NoteHistoryController(super._state,
      {required this.accountRepository,
      required this.userID,
      required this.soapId,
      required this.sessionController,
      required this.fatherPatient});

  List<SOAPNote> listFiltrado = [];
  List<SOAPNote> filteredNotes = [];
  List listOption = ["1 semana", "1 mes", "6 meses", "1 año"];
  String valueSelected = "6 meses";

  Future<void> init() async {
    await getRecordSoapNote();
  }

  // Codigo de para mostrar las listas de notas de los soap:
  Future<void> getRecordSoapNote({SOAPNoteState? soapNoteState}) async {
    if (soapNoteState != null) {
      state = state.copyWith(soapNoteState: soapNoteState);
    }

    final result = await (soapId == 's'
        ? accountRepository.getSoapNoteS(userID, rangeGraph[valueSelected]!)
        : soapId == 'o'
            ? accountRepository.getSoapNoteO(userID, rangeGraph[valueSelected]!)
            : soapId == 'a'
                ? accountRepository.getSoapNoteA(
                    userID, rangeGraph[valueSelected]!)
                : soapId == 'p'
                    ? accountRepository.getSoapNoteP(
                        userID, rangeGraph[valueSelected]!)
                    : Future.value(Either.left(HttpRequestFailure.notFound())));

    result.when(
      left: (failure) {
        failure.when(
          notFound: () =>
              showToast("No se encontraron notas SOAP para este paciente"),
          network: () => showToast("Sin conexión a Internet"),
          unauthorized: () =>
              showToast("No estás autorizado para ver estas notas"),
          unknown: () => showToast("Error al guardar o mostrar la nota SOAP"),
          formData: (String message) {},
          emailExist: () {},
          tokenInvalided: () {
            showToast("Sesion expirada");
            sessionController.globalCloseSession();
          },
        );
        state = state.copyWith(soapNoteState: SOAPNoteState.failed(failure));
      },
      right: (notes) {
        listFiltrado = notes;
        state = state.copyWith(soapNoteState: SOAPNoteState.loaded(notes));
      },
    );
  }

  Future<void> searchOnChanged(String text) async {
    state = state.copyWith(soapNoteState: const SOAPNoteState.loading());

    List<SOAPNote> soapNotesFiltered = listFiltrado
        .where((element) =>
            element.note.toLowerCase().contains(text.toLowerCase()) ||
            element.date.toLowerCase().contains(text.toLowerCase()))
        .toList();

    state =
        state.copyWith(soapNoteState: SOAPNoteState.loaded(soapNotesFiltered));
  }
}
