import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonDigimed extends StatelessWidget {
  final Widget child;
  final VoidCallback onTab;
  final double? height;

  const ButtonDigimed(
      {super.key, required this.child, required this.onTab, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.backgroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ))),
          onPressed: onTab,
          child: child),
    );
  }
}
