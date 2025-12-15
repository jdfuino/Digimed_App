import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/tools_dimed_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:flutter/material.dart';

class StatusIaDialog extends StatelessWidget {
  final String body;
  final String title;
  final IconData icon;

  const StatusIaDialog(
      {super.key, required this.body, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AlertDialog(
        content: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: double.maxFinite,
            // height: size.height * 0.70,
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        backgroundColor: AppColors.backgroundColor,
                      ),
                      child: const Icon(Icons.close,
                          size: 15, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 4,
                    )
                  ],
                ),
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
                const SizedBox(
                  height: 16,
                ),
                Text(
                  title,
                  style: AppTextStyle.boldContentTextStyle,
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    body,
                    style: AppTextStyle.normal14W400ContentTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 31,
                ),
                ButtonDigimed(
                    child: const Text(
                      "OK",
                      style: AppTextStyle.normalWhiteContentTextStyle,
                    ),
                    onTab: () async {
                      Navigator.of(context).pop();
                    })
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ));
  }
}
