import 'package:digimed/app/domain/models/soap_note/soap_note.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/pages/note_soap_history/controller/note_history_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardNote extends StatelessWidget {
  final SOAPNote noteSOAP;
  final int index;
  const CardNote({super.key, required this.noteSOAP, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<NoteHistoryController>(context);
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Nota'),
              content: Container(
                height: size.height * 0.70,
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        convertDate(noteSOAP.date),
                        style: AppTextStyle.grey13BoldContentTextStyle,
                      ),
                      Text(
                        parseHtmlToPlainText(noteSOAP.note) ?? "",
                        style: AppTextStyle.normal16W500ContentTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            );
          },
        );
      },
      child: Card(
        color: AppColors.scaffoldBackgroundColor,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          margin:
              const EdgeInsets.only(right: 16, left: 24, bottom: 8, top: 20),
          height: size.height * 0.07,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        convertDate(noteSOAP.date),
                        style: AppTextStyle.grey13BoldContentTextStyle,
                      ),
                      Container(
                        width: 220,
                        child: Text(
                          parseHtmlToPlainText(noteSOAP.note) ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTextStyle.normal16W500ContentTextStyle,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
