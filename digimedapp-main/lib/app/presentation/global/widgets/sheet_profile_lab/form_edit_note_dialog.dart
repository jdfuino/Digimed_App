// import 'package:digimed/app/domain/models/input_soap/input_soap.dart';
// import 'package:digimed/app/presentation/global/app_colors.dart';
// import 'package:digimed/app/presentation/global/app_text_sytle.dart';
// import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
// import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:quill_html_editor/quill_html_editor.dart';
// import 'package:provider/provider.dart';
//
// class FormEditNoteDialog extends StatefulWidget {
//   final String title;
//   final String soapID;
//   final int patientID;
//   final Function(InputSOAP) onSaved;
//   String? note;
//   bool isEdit;
//
//   FormEditNoteDialog(
//       {super.key,
//         required this.title,
//         required this.onSaved,
//         this.note,
//         required this.patientID,
//         required this.isEdit,
//         required this.soapID});
//
//   @override
//   State<FormEditNoteDialog> createState() =>
//       _FormCreateNewNoteDialogState();
// }
//
// class _FormCreateNewNoteDialogState extends State<FormEditNoteDialog> {
//   late TextEditingController _noteController;
//   final QuillEditorController controllerQ = QuillEditorController();
//
//   @override
//   void initState() {
//     super.initState();
//     _noteController = TextEditingController(text: widget.note);
//   }
//
//   @override
//   void dispose() {
//     _noteController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return AlertDialog(
//         content: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Column(
//             children: [
//               Container(
//                 color: Colors.white,
//                 width: double.maxFinite,
//                 height: size.height * 0.75,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const SizedBox(
//                         height: 16,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           const Spacer(),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             style: ElevatedButton.styleFrom(
//                               shape: const CircleBorder(),
//                               padding: const EdgeInsets.all(15),
//                               backgroundColor: AppColors.backgroundColor,
//                             ),
//                             child: const Icon(Icons.close,
//                                 size: 15, color: Colors.white),
//                           ),
//                           const SizedBox(
//                             width: 4,
//                           )
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 16,
//                       ),
//                       Text(
//                         widget.title,
//                         style: AppTextStyle.boldContentTextStyle,
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       !widget.isEdit
//                           ? TextField(
//                         maxLines: 10,
//                         keyboardType: TextInputType.multiline,
//                         style: AppTextStyle.normalTextStyle2,
//                         controller: _noteController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: AppColors.scaffoldBackgroundColor,
//                           hintText: 'Escribe tus notas',
//                           hintStyle: AppTextStyle.hintTextStyle,
//                           contentPadding: const EdgeInsets.fromLTRB(
//                               20.0, 15.0, 20.0, 15.0),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: const BorderSide(
//                                 width: 0.2,
//                                 color: AppColors.backgroundSearchColor),
//                           ),
//                         ),
//                       )
//                           : QuillHtmlEditor(
//                           text: widget.note,
//                           hintText: 'Escribe tus notas',
//                           controller: controllerQ,
//                           //required
//                           isEnabled: true,
//                           minHeight: 200,
//                           textStyle: AppTextStyle.normalTextStyle2,
//                           hintTextStyle: AppTextStyle.hintTextStyle,
//                           hintTextAlign: TextAlign.start,
//                           padding: const EdgeInsets.only(left: 10, top: 5),
//                           hintTextPadding: EdgeInsets.zero,
//                           backgroundColor: Colors.white,
//                           onFocusChanged: (hasFocus) =>
//                               debugPrint('has focus $hasFocus'),
//                           onTextChanged: (text) =>
//                               debugPrint('widget text change $text'),
//                           onEditorCreated: () =>
//                               debugPrint('Editor has been loaded'),
//                           loadingBuilder: (context) {
//                             return const Center(
//                                 child: CircularProgressIndicator());
//                           }),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 child: ButtonDigimed(
//                     child: const Text(
//                       "Guardar",
//                       style: AppTextStyle.normalWhiteContentTextStyle,
//                     ),
//                     onTab: () async {
//                       String textSave = "";
//                       if(!widget.isEdit){
//                         textSave = _noteController.text;
//                       }else{
//                         textSave = await controllerQ.getText();
//                       }
//                       if (textSave.isNotEmpty){
//                         switch (widget.soapID) {
//                           case "s":
//                             final input = InputSOAP(
//                                 patientID: widget.patientID,
//                                 subjectiveNote: textSave);
//                             widget.onSaved(input);
//                             break;
//                           case "o":
//                             final input = InputSOAP(
//                                 patientID: widget.patientID,
//                                 objectiveNote: textSave);
//                             widget.onSaved(input);
//                             break;
//                           case "a":
//                             final input = InputSOAP(
//                                 patientID: widget.patientID,
//                                 assessmentNote: textSave);
//                             widget.onSaved(input);
//                             break;
//                           case "p":
//                             final input = InputSOAP(
//                                 patientID: widget.patientID,
//                                 planNote: textSave);
//                             widget.onSaved(input);
//                             break;
//                           default:
//                             final input = InputSOAP(
//                                 patientID: widget.patientID,
//                                 subjectiveNote: textSave);
//                             widget.onSaved(input);
//                             break;
//                         }
//                         Navigator.of(context).pop();
//                       }
//                     }),
//               )
//             ],
//           ),
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ));
//   }
// }
