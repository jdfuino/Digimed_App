import 'package:digimed/app/domain/models/input_soap/input_soap.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/i_a_icons_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:flutter/material.dart';

class FormUsingIaNoteDialog extends StatefulWidget {
  final String title;
  final String subTitle;
  final String? body;
  final int patientID;
  final String soapID;
  final Function(InputSOAP) onSaved;

  const FormUsingIaNoteDialog({
    super.key,
    required this.title,
    this.body,
    required this.patientID,
    required this.onSaved,
    required this.soapID,
    required this.subTitle,
  });

  @override
  State<FormUsingIaNoteDialog> createState() => _FormUsingIaNoteDialogState();
}

class _FormUsingIaNoteDialogState extends State<FormUsingIaNoteDialog> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.body);
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
        reverse: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
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
                    child: const Icon(Icons.close,
                        size: 15, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                backgroundColor: AppColors.buttonDisableBackgroundColor,
                radius: MediaQuery.of(context).size.width * 0.12,
                child: Container(
                  margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.012),
                  child: const Icon(
                    IAIcons.vector,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: AppTextStyle.boldContentTextStyle,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  widget.subTitle,
                  style: AppTextStyle.normal14W400ContentTextStyle,
                  textAlign: TextAlign.center,
                ),
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
                          width: 0.2,
                          color: AppColors.backgroundSearchColor),
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
                  final html = _noteController.text;
                  if (html.isNotEmpty) {
                    switch (widget.soapID) {
                      case "s":
                        final input = InputSOAP(
                            patientID: widget.patientID, subjectiveNote: html);
                        widget.onSaved(input);
                        break;
                      case "o":
                        final input = InputSOAP(
                            patientID: widget.patientID, objectiveNote: html);
                        widget.onSaved(input);
                        break;
                      case "a":
                        final input = InputSOAP(
                            patientID: widget.patientID, assessmentNote: html);
                        widget.onSaved(input);
                        break;
                      case "p":
                        final input = InputSOAP(
                            patientID: widget.patientID, planNote: html);
                        widget.onSaved(input);
                        break;
                      default:
                        final input = InputSOAP(
                            patientID: widget.patientID, subjectiveNote: html);
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
