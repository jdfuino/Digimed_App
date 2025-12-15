import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/profile_laboratory_edit_input/profile_laboratory_edit_input.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SheetEditProfileLab extends StatelessWidget {
  final ProfileLaboratory item;
  final String gender;
  final Function(ProfileLaboratoryEditInput, int) onComplete;

  const SheetEditProfileLab(
      {super.key,
      required this.item,
      required this.gender,
      required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double glucose = item.glucose;
    double triglicerios = item.triglycerides;
    double colesterol = item.cholesterol;
    double hemoglobina = item.hemoglobin;

    return SizedBox(
      height: MediaQuery.of(context).copyWith().size.height * 0.85,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
              right: 24,
              left: 24),
          child: Form(
            child: Builder(builder: (formContext) {
              return Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                          backgroundColor: AppColors.backgroundColor,
                        ),
                        child: const Icon(Icons.close,
                            size: 15, color: Colors.white),
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
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Glucemia",
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: item.glucose.toString(),
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: "${item.glucose} (mg/dl)",
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.backgroundColor),
                                  ),
                                ),
                                validator: (weight) {
                                  if (weight == null || weight.isEmpty) {
                                    return "Este campo es requerido";
                                  } else if (!weight.isValidWeightNumber()) {
                                    return "valor incorrecto, ej: 70.0";
                                  } else if (!weight.isGlucoseInValidRange()) {
                                    return "Fuera de rango: 0 y 300 mg/dL";
                                  }
                                  return null;
                                },
                                onSaved: (weight) {
                                  if (weight != null && weight.isNotEmpty) {
                                    glucose = double.parse(weight ?? "0");
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        !glucemiaAltered(item.glucose)
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
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Triglicéridos",
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: item.triglycerides.toString(),
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: "${item.triglycerides} (mg/dl)",
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (weight) {
                                  if (weight == null || weight.isEmpty) {
                                    return "Este campo es requerido";
                                  } else if (!weight.isValidWeightNumber()) {
                                    return "valor incorrecto, ej: 70.0";
                                  } else if (!weight
                                      .isTriglyceridesInValidRange()) {
                                    return "Fuera de rango: 0 y 500 mg/dL";
                                  }
                                  return null;
                                },
                                onSaved: (weight) {
                                  if (weight != null && weight.isNotEmpty) {
                                    triglicerios = double.parse(weight ?? "0");
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        !trigliceriosAltered(item.triglycerides)
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
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Colesterol No-HDL",
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              TextFormField(
                                initialValue: item.cholesterol.toString(),
                                keyboardType: TextInputType.number,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText:
                                      "${item.cholesterol} No-HDL (mg/dl)",
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (weight) {
                                  if (weight == null || weight.isEmpty) {
                                    return "Este campo es requerido";
                                  } else if (!weight.isValidWeightNumber()) {
                                    return "valor incorrecto, ej: 70.0";
                                  } else if (!weight
                                      .isCholesterolInValidRange()) {
                                    return "Fuera de rango: 0 y 300 mg/dL";
                                  }
                                  return null;
                                },
                                onSaved: (weight) {
                                  if (weight != null && weight.isNotEmpty) {
                                    colesterol = double.parse(weight ?? "0.0");
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        !colesterolAltered(item.cholesterol)
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
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Hemoglobina (g/dL)",
                                style:
                                    AppTextStyle.subW500NormalContentTextStyle,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: item.hemoglobin.toString(),
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: "Hemoglobina (g/dL)",
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (weight) {
                                  if (weight == null || weight.isEmpty) {
                                    return "Este campo es requerido";
                                  } else if (!weight.isValidWeightNumber()) {
                                    return "valor incorrecto, ej: 70.0";
                                  } else if (!weight
                                      .isHemoglobinInValidRange()) {
                                    return "Fuera de rango: 0 y 30 g/dL";
                                  }
                                  return null;
                                },
                                onSaved: (weight) {
                                  if (weight != null && weight.isNotEmpty) {
                                    hemoglobina = double.parse(weight ?? "0.0");
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        !hemoglobinaAltered(item.hemoglobin, gender)
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
                  ),
                  ButtonDigimed(
                      child: const Text(
                        "Guardar",
                        style: AppTextStyle.normalWhiteContentTextStyle,
                      ),
                      onTab: () async {
                        final isValid = Form.of(formContext).validate();
                        if (isValid) {
                          Form.of(formContext).save();
                          logger.i(
                              "Glucosa: $glucose, Trigliceridos: $triglicerios, Colesterol: $colesterol, Hemoglobina: $hemoglobina");
                          ProfileLaboratoryEditInput updatedItem =
                              ProfileLaboratoryEditInput(
                                  glucose: glucose,
                                  triglycerides: triglicerios,
                                  cholesterol: colesterol,
                                  hemoglobin: hemoglobina);

                          await onComplete(updatedItem, item.id);
                          Navigator.of(context).pop();
                        }
                      }),
                  const SizedBox(
                    height: 32,
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
