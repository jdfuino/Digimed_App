import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:flutter/material.dart';

class CardLabNull extends StatelessWidget {
  const CardLabNull({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Perfil de laboratorio",
                style: AppTextStyle.semiBold18W500ContentTextStyle,
              ),
              Spacer(),
              Assets.svgs.iconSangre.svg()
            ],
          ),
          Assets.svgs.noInfo.svg(),
          Text(
            "¡No hay registros disponibles!",
            style: AppTextStyle.normalContentTextStyle,
          )
        ],
      ),
    );
  }
}
