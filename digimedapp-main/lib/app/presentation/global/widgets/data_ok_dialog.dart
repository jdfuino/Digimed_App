import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/daniel_digimed_icon.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class DataOkDialog extends StatelessWidget {

  const DataOkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String word = "Digimed";
    String text =
        '¡Felicidades! tus valores están en el rango correcto, mantente saludable y disfruta de los beneficios que $word ofrece a sus usuarios asegurados.';
    final startText = text.substring(0, text.indexOf(word));
    final endText = text.substring(text.indexOf(word) + word.length);
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0))
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 32,right: 16, left: 16,bottom: 32),
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              DigimedIcon.good,
              color: AppColors.backgroundSettingSaveColor,
              size: 80,
            ),
            SizedBox(height: 8,),
            Text(titleOKDialog, style: AppTextStyle.boldContentTextStyle,),
            SizedBox(height: 8,),
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
            )
          ],
        ),
      ),
    );
  }
}
