import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/tools_dimed_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:flutter/material.dart';

class WaitingIaDialog extends StatelessWidget {
  final IconData icon;

  const WaitingIaDialog({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Para que el modal sea compacto
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                backgroundColor: AppColors.buttonDisableBackgroundColor,
                radius: size.width * 0.12,
                child: Container(
                  margin: EdgeInsets.only(right: size.width * 0.012),
                  child: Icon(
                    icon,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Creando archivo...",
                style: AppTextStyle.boldContentTextStyle,
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
