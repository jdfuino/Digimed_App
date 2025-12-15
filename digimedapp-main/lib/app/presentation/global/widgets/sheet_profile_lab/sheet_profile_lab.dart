import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SheetProfileLab extends StatelessWidget {
  final ProfileLaboratory item;
  final String gender;

  const SheetProfileLab({super.key, required this.item, required this.gender});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: MediaQuery.of(context).copyWith().size.height * 0.85,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
              right: 24,
              left: 24),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close, size: 15, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: AppColors.backgroundColor,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: AppColors.backgroundImageColor,
                radius: size.width * 0.20,
                child: SvgPicture.asset(
                  Assets.svgs.resultLab.path,
                  width: size.width * 0.20,
                  height: size.width * 0.20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Resultados anteriores",
                    style: AppTextStyle.semiBold14W500ContentTextStyle,
                  ),
                  Text(
                    convertDate(item.createdAt),
                    style: AppTextStyle.sub16BoldContentTextStyle,
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Glucemia",
                          style: AppTextStyle.subW500NormalContentTextStyle,
                        ),
                        Text(
                          item.glucose != null
                              ? "${showNumber2(item.glucose)} mg/dl"
                              : "0 mg/dl",
                          style: AppTextStyle.semiBold17W500ContentTextStyle,
                        )
                      ],
                    ),
                    const Spacer(),
                    !glucemiaAltered(item.glucose!)
                        ? Icon(
                            DigimedIcon.good,
                            color: AppColors.backgroundSettingSaveColor,
                            size: size.width * 0.07,
                          )
                        : Icon(
                            DigimedIcon.alert,
                            color: Colors.amber,
                            size: size.width * 0.07,
                          ),
                  ],
                ),
              ),
              const Divider(color: AppColors.contentTextColor),
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Triglicéridos",
                          style: AppTextStyle.subW500NormalContentTextStyle,
                        ),
                        Text(
                          item.triglycerides != null
                              ? "${showNumber2(item.triglycerides)}  mg/dl"
                              : "0  mg/dl",
                          style: AppTextStyle.semiBold17W500ContentTextStyle,
                        )
                      ],
                    ),
                    const Spacer(),
                    !trigliceriosAltered(item.triglycerides!)
                        ? Icon(
                            DigimedIcon.good,
                            color: AppColors.backgroundSettingSaveColor,
                            size: size.width * 0.07,
                          )
                        : Icon(
                            DigimedIcon.alert,
                            color: Colors.amber,
                            size: size.width * 0.07,
                          ),
                  ],
                ),
              ),
              const Divider(color: AppColors.contentTextColor),
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Colesterol No-HDL",
                          style: AppTextStyle.subW500NormalContentTextStyle,
                        ),
                        Text(
                          item.cholesterol != null
                              ? "${showNumber2(item.cholesterol)} mg/dl"
                              : "0 mg/dl",
                          style: AppTextStyle.semiBold17W500ContentTextStyle,
                        )
                      ],
                    ),
                    const Spacer(),
                    !colesterolAltered(item.cholesterol!)
                        ? Icon(
                            DigimedIcon.good,
                            color: AppColors.backgroundSettingSaveColor,
                            size: size.width * 0.07,
                          )
                        : Icon(
                            DigimedIcon.alert,
                            color: Colors.amber,
                            size: size.width * 0.07,
                          ),
                  ],
                ),
              ),
              const Divider(color: AppColors.contentTextColor),
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hemoglobina (g/dL)",
                          style: AppTextStyle.subW500NormalContentTextStyle,
                        ),
                        Text(
                          item.hemoglobin != null
                              ? "${showNumber2(item.hemoglobin)} g/dL"
                              : "0 g/dL",
                          style: AppTextStyle.semiBold17W500ContentTextStyle,
                        )
                      ],
                    ),
                    const Spacer(),
                    !hemoglobinaAltered(item.hemoglobin!, gender)
                        ? Icon(
                            DigimedIcon.good,
                            color: AppColors.backgroundSettingSaveColor,
                            size: size.width * 0.07,
                          )
                        : Icon(
                            DigimedIcon.alert,
                            color: Colors.amber,
                            size: size.width * 0.07,
                          ),
                  ],
                ),
              ),
              const Divider(color: AppColors.contentTextColor),
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ácido úrico (mg/dL)",
                          style: AppTextStyle.subW500NormalContentTextStyle,
                        ),
                        Text(
                          item.uricAcid != null
                              ? "${showNumber2(item.uricAcid ?? 0)} mg/dL"
                              : "0 mg/dL",
                          style: AppTextStyle.semiBold17W500ContentTextStyle,
                        )
                      ],
                    ),
                    const Spacer(),
                    !acidoUricoAltered(item.uricAcid ?? 0, gender)
                        ? Icon(
                            DigimedIcon.good,
                            color: AppColors.backgroundSettingSaveColor,
                            size: size.width * 0.07,
                          )
                        : Icon(
                            DigimedIcon.alert,
                            color: Colors.amber,
                            size: size.width * 0.07,
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
