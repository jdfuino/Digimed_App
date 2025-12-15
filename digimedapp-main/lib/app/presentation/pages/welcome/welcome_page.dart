import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/widgets/banner_logo.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/register_doctor_page.dart';
import 'package:digimed/app/presentation/pages/register/patient/views/register_patient_page.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BannerLogo(),
          RichText(
              text: TextSpan(
                  style: AppTextStyle.boldContentTextStyle,
                  children: [
                TextSpan(text: "Bienvenido a "),
                TextSpan(
                    text: "Digimed", style: AppTextStyle.bold18BlueTextStyle)
              ])),
          SizedBox(
            height: 8,
          ),
          Text(
            "Medicina Digital Predictiva y Preventiva",
            textAlign: TextAlign.center,
            style: AppTextStyle.normal17ContentTextStyle,
          ),
          SizedBox(
            height: 74,
          ),
          SvgPicture.asset(Assets.svgs.doctor.path),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.only(right: 24, left: 24),
            child: ButtonDigimed(
                child: Text(
                  "Siguiente",
                  style: AppTextStyle.normalWhite15W600ContentTextStyle,
                ),
                onTab: () {
                  _next(context);
                }),
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    ));
  }

  void _next(BuildContext context) async {
    final SessionController controller = context.read();
    if (controller.doctor != null) {
      if(controller.doctor!.registerStep != null &&
          controller.doctor!.registerStep! >= 3){
        await Navigator.pushReplacementNamed(context, Routes.homeDoctor);
      }else{
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RegisterDoctorPage(step: controller.doctor!.registerStep!)));
      }
    } else if (controller.patients != null) {
      if(controller.patients!.registerStep != null &&
          controller.patients!.registerStep! >= 8){
        await Navigator.pushReplacementNamed(context, Routes.homePatient);
      }else{
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterPatientPage(
                    step: controller.patients!.registerStep!)));
      }
    }
  }
}
