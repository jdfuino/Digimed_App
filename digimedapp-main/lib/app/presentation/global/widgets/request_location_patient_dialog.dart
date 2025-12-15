import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RequestLocationPatientDialog extends StatelessWidget {
  final VoidCallback onFinish;
  const RequestLocationPatientDialog({super.key,required this.onFinish});

  @override
  Widget build(BuildContext context) {
    String title = "¡Queremos cuidar de ti!";
    String text =
        'Necesitamos permisos de localización para mejorar nuestro servicio de monitoreo y ayudarte a mantener tu estado de salud.';
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
            SvgPicture.asset(Assets.svgs.locationDigimed.path),
            SizedBox(height: 8,),
            Text(title, style: AppTextStyle.boldContentTextStyle,),
            SizedBox(height: 8,),
            Text(text,style: AppTextStyle.normal14W500ContentTextStyle,
              textAlign: TextAlign.center,),
            SizedBox(height: 16,),
            Container(
              margin: const EdgeInsets.only(right: 16, left: 16),
              width: double.maxFinite,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  onFinish();
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  side: const BorderSide(width: 1.0, color: Colors.blue),
                ),
                child: const Text('Permitir',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.only(right: 16, left: 16),
              width: double.maxFinite,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  side: const BorderSide(width: 1.0, color: Colors.blue),
                ),
                child: const Text('No permitir',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
