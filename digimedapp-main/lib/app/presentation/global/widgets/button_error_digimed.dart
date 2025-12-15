import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';

class ButtonErrorDigimed extends StatelessWidget {
  final VoidCallback onTab;
  const ButtonErrorDigimed({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  AppColors.buttonDisableBackgroundColor),
          ),
          onPressed: onTab,
          child: Text("Reiniciar", style: AppTextStyle.normalBlueTextStyle,)
      ),
    );
  }
}
