import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class DataWarningDoctorDialog extends StatelessWidget {
  final String title;
  final String word;
  final String phone;

  const DataWarningDoctorDialog(
      {super.key,
      required this.title,
      required this.word,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    String text =
        'Parece que tus valores de $word se encuentran fuera del rango normal, sigue el plan de tratamiento asignado por tu médico y si los valores no se normalizan contacta a tu doctor.';
    final startText = text.substring(0, text.indexOf(word));
    final endText = text.substring(text.indexOf(word) + word.length);

    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Container(
        margin: const EdgeInsets.only(top: 32, right: 16, left: 16, bottom: 32),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              DigimedIcon.alert,
              color: Colors.amber,
              size: 80,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              style: AppTextStyle.boldContentTextStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: startText,
                    style: AppTextStyle.normalContentTextStyle,
                  ),
                  TextSpan(
                      text: word, style: AppTextStyle.bold14W700ContentTextStyle),
                  TextSpan(
                      text: endText,
                      style: AppTextStyle.normal14W500ContentTextStyle),
                ],
              ),
            ),
            SizedBox(height: 16,),
            ButtonDigimed(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Contacta a tu médico",
                      style: AppTextStyle.normalWhiteContentTextStyle,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(
                      DigimedIcon.whatsapp,
                      color: Colors.white,
                    )
                  ],
                ),
                onTab: () {
                  launchWhatsapp(phone, "");
                })
          ],
        ),
      ),
    );
  }
}
