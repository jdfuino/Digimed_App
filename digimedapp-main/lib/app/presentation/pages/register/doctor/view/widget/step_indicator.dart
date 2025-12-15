import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int step, lastStep;
  final VoidCallback onTab;

  const StepIndicator(
      {super.key,
      required this.step,
      required this.lastStep,
      required this.onTab});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: onTab,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.backgroundColor,
                  )),
              Text("Paso ${step + 1}/$lastStep",
                style: AppTextStyle.boldBlueTextStyle,)
            ],
          ),
          Container(
            width: double.infinity,
            height: 6,
            margin:  EdgeInsets.only(right: (size.width * 0.12),
                left: (size.width * 0.12)),
            child: LinearProgressIndicator(
              value: step + 1 == lastStep
                  ?0.85
                  :(step + 1)/lastStep,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
