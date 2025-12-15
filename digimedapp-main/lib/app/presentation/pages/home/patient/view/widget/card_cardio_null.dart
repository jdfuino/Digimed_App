import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/pages/home/patient/controller/home_patient_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardCardioNull extends StatelessWidget {
  const CardCardioNull({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Perfil cardiovascular",
                style: AppTextStyle.semiBold18W500ContentTextStyle,
              ),
              Spacer(),
              Assets.svgs.iconPrsion.svg()
            ],
          ),
          Assets.svgs.noInfo.svg(),
          Text(
            "¡No hay registros disponibles!",
            style: AppTextStyle.normalContentTextStyle,
          )
          ,SizedBox(height: 8,),
        ],
      ),
    );
  }
}
