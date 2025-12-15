import 'package:digimed/app/domain/models/input_soap/input_soap.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormCreateNewNoteDialog extends StatefulWidget {
  final String title;
  final String soapID;
  final int patientID;
  final Function(InputSOAP) onSaved;
  final String? note;

  const FormCreateNewNoteDialog({
    super.key,
    required this.title,
    required this.onSaved,
    this.note,
    required this.patientID,
    required this.soapID,
  });

  @override
  State<FormCreateNewNoteDialog> createState() => _FormCreateNewNoteDialogState();
}

class _FormCreateNewNoteDialogState extends State<FormCreateNewNoteDialog> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: AppColors.backgroundColor,
                    ),
                    child: const Icon(Icons.close, size: 15, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: AppTextStyle.boldContentTextStyle,
              ),
              const SizedBox(height: 16),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: TextField(
                  controller: _noteController,
                  maxLines: null, // Permite expandirse según el contenido
                  keyboardType: TextInputType.multiline,
                  style: AppTextStyle.normalTextStyle2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.scaffoldBackgroundColor,
                    hintText: 'Escribe tus notas',
                    hintStyle: AppTextStyle.hintTextStyle,
                    contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          width: 0.2, color: AppColors.backgroundSearchColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ButtonDigimed(
                child: const Text(
                  "Guardar",
                  style: AppTextStyle.normalWhiteContentTextStyle,
                ),
                onTab: () async {
                  if (_noteController.text.isNotEmpty) {
                    switch (widget.soapID) {
                      case "s":
                        final input = InputSOAP(
                            patientID: widget.patientID,
                            subjectiveNote: _noteController.text);
                        widget.onSaved(input);
                        break;
                      case "o":
                        final input = InputSOAP(
                            patientID: widget.patientID,
                            objectiveNote: _noteController.text);
                        widget.onSaved(input);
                        break;
                      case "a":
                        final input = InputSOAP(
                            patientID: widget.patientID,
                            assessmentNote: _noteController.text);
                        widget.onSaved(input);
                        break;
                      case "p":
                        final input = InputSOAP(
                            patientID: widget.patientID,
                            planNote: _noteController.text);
                        widget.onSaved(input);
                        break;
                      default:
                        final input = InputSOAP(
                            patientID: widget.patientID,
                            subjectiveNote: _noteController.text);
                        widget.onSaved(input);
                        break;
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
