import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PendingTreatmentDialog extends StatelessWidget {
  final String patientName;
  final String treatmentName;
  final VoidCallback onStartTreatment;
  final VoidCallback onViewTreatments;

  const PendingTreatmentDialog({
    super.key,
    required this.patientName,
    required this.onStartTreatment,
    required this.onViewTreatments,
    required this.treatmentName,
  });

  @override
  Widget build(BuildContext context) {
    String title = "Asistente";
    String text =
        'Hola $patientName, he detectado que tienes el tratamiento \"$treatmentName\" pendiente por iniciar. ¿Ya tienes todo listo para comenzar?';

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
            SvgPicture.asset(Assets.svgs.doctor.path),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyle.boldContentTextStyle),
            const SizedBox(height: 8),
            Text(
              text,
              style: AppTextStyle.normal14W500ContentTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(right: 16, left: 16),
              width: double.maxFinite,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  onStartTreatment();
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  side: const BorderSide(width: 1.0, color: Colors.blue),
                ),
                child: const Text(
                  'Iniciar tratamiento',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(right: 16, left: 16),
              width: double.maxFinite,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onViewTreatments();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  side: const BorderSide(width: 1.0, color: Colors.blue),
                ),
                child: const Text(
                  'Ver mis tratamientos',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
