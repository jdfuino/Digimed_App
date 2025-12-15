import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/note_soap_history/controller/note_history_controller.dart';
import 'package:digimed/app/presentation/pages/note_soap_history/controller/state/note_history_state.dart';
import 'package:digimed/app/presentation/pages/note_soap_history/view/widget/card_note.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class NoteHistoryPage extends StatelessWidget {
  final int userID;
  final Patients patients;
  final String soapId;

  const NoteHistoryPage({
    super.key,
    required this.userID,
    required this.patients,
    required this.soapId,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => NoteHistoryController(
        const NoteHistoryState(),
        accountRepository: Repositories.account,
        sessionController: context.read(),
        fatherPatient: patients,
        userID: userID,
        soapId: soapId,
      )..init(),
      child: MyScaffold(
        body: Builder(
          builder: (context) {
            final controller = Provider.of<NoteHistoryController>(
              context,
              listen: true,
            );
            return SingleChildScrollView(
              child: Column(
                children: [
                  BannerDigimed(
                    textLeft: soapId == 's'
                        ? "Riesgos subjetivos"
                        : soapId == 'o'
                            ? "Riesgos objetivos"
                            : soapId == 'a'
                                ? "Diagnóstico"
                                : soapId == 'p'
                                    ? "Plan de tratamiento"
                                    : "Historial de notas",
                    iconLeft: DigimedIcon.detail_user,
                    iconRight: DigimedIcon.back,
                    onClickIconRight: () {
                      Navigator.of(context).pop();
                    },
                    firstLine: "Paciente",
                    secondLine: patients.user.fullName,
                    lastLine:
                        "${patients.user.identificationType}. ${patients.user.identificationNumber}",
                    imageProvider: isValidUrl(patients.user.urlImageProfile)
                        ? NetworkImage(patients.user.urlImageProfile!)
                        : Assets.images.logo.provider(),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: size.width * 0.55,
                            margin: const EdgeInsets.only(left: 28),
                            decoration: BoxDecoration(
                              color: AppColors.textColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 0.5,
                                  blurRadius: 4.0,
                                  offset: const Offset(0.0, 4.0),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              style: AppTextStyle.normalTextStyle2,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (text) {
                                controller.searchOnChanged(text);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.textColor,
                                hintText: 'Búsqueda detallada',
                                hintStyle: AppTextStyle.hintTextStyle,
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                prefixIcon: const Icon(
                                  DigimedIcon.search,
                                  size: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      width: 0.2,
                                      color: AppColors.backgroundSearchColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: size.width * 0.29,
                            child: controller.state.soapNoteState.when(
                              loading: () {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              failed: (failed) {
                                return _dropMenu(context);
                              },
                              loaded: (_) {
                                return _dropMenu(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 24,
                          left: 24,
                          top: 8,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(
                                right: 14, left: 14, bottom: 4, top: 10),
                            height: size.height * 0.48,
                            child: controller.state.soapNoteState.when(
                              loading: () {
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                              failed: (failed) {
                                return errorMessage();
                              },
                              loaded: (notes) {
                                if (notes.isNotEmpty) {
                                  return ListView.builder(
                                    itemCount: notes.length,
                                    itemBuilder: (context, index) {
                                      final item = notes[index];
                                      return CardNote(
                                        noteSOAP: item,
                                        index: index,
                                      );
                                    },
                                  );
                                } else {
                                  return errorMessage();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _dropMenu(BuildContext context) {
  final NoteHistoryController controller = Provider.of(context);
  return PopupMenuButton<String>(
    child: SizedBox(
      height: 55,
      child: Container(
        child: Card(
          shadowColor: Colors.grey.withOpacity(0.3),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.backgroundColor,
              ),
              Text(controller.valueSelected,
                  style: AppTextStyle.normalBlueTextStyle),
              SizedBox(
                width: 8,
              )
            ],
          ),
          color: AppColors.textColor,
        ),
      ),
    ),
    onSelected: (String value) {
      controller.valueSelected = value;
      controller.getRecordSoapNote(
          soapNoteState: const SOAPNoteState.loading());
    },
    itemBuilder: (BuildContext context) {
      return ["1 semana", "1 mes", "6 meses", "1 año"].map((String value) {
        return PopupMenuItem<String>(
          value: value,
          child: ListTile(
            title: Text(value),
            leading: Radio<String>(
              value: value,
              groupValue: controller.valueSelected,
              onChanged: (value) {
                if (value != null) {
                  controller.valueSelected = value;
                  controller.getRecordSoapNote(
                      soapNoteState: const SOAPNoteState.loading());
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      }).toList();
    },
  );
}
