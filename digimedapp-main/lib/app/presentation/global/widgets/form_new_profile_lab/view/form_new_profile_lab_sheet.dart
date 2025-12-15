import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_profile_lab/controller/form_new_profile_controller.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_profile_lab/controller/state/form_new_profile_lab_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FormNewProfileLabSheet extends StatelessWidget {
  final int patientId;
  final VoidCallback onFinish;

  const FormNewProfileLabSheet(
      {super.key, required this.patientId, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => FormNewProfileLabController(const FormNewProfileLabState(),
          accountRepository: Repositories.account,
          sessionController: context.read(),
          patientId: patientId),
      child: Builder(builder: (context) {
        final controller = Provider.of<FormNewProfileLabController>(
          context,
          listen: true,
        );
        return Container(
          child: SingleChildScrollView(
            reverse: true,
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
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close, size: 15, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15),
                          elevation: 0,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 37,
                      ),
                      Text(
                        "Actualización de examen",
                        style: AppTextStyle.normalContentTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Form(child: Builder(
                    builder: (formContext) {
                      return AbsorbPointer(
                        absorbing: controller.state.fetching,
                        child: Container(
                          margin: const EdgeInsets.only(right: 16, left: 16),
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: "Glucemia (mg/dl)",
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
                                  } else if (!weight.isGlucoseInValidRange()) {
                                    return "Fuera de rango: 0 y 300 mg/dL";
                                  }
                                  return null;
                                },
                                onSaved: (weight) {
                                  if (weight != null && weight.isNotEmpty) {
                                    controller.glucemia =
                                        double.parse(weight ?? "0.0");
                                  }
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: "Triglicéridos (mg/dl)",
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
                                    controller.triglicerios =
                                        double.parse(weight ?? "0.0");
                                  }
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: "Colesterol No-HDL (mg/dl)",
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
                                    controller.colesterol =
                                        double.parse(weight ?? "0.0");
                                  }
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
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
                                    controller.hemoglobina =
                                        double.parse(weight ?? "0.0");
                                  }
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: "Ácido úrico (mg/dL)",
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
                                    return null;
                                  } else if (!weight.isValidWeightNumber()) {
                                    return "valor incorrecto, ej: 7.2";
                                  } else if (!weight.isUricAcidInValidRange()) {
                                    return "Fuera de rango: 0 y 20 mg/dL";
                                  }
                                  return null;
                                },
                                onSaved: (weight) {
                                  if (weight != null && weight.isNotEmpty) {
                                    controller.acidoUrico =
                                        double.parse(weight ?? "0.0");
                                  }
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              controller.state.requestState.when(fetch: () {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }, normal: () {
                                return ButtonDigimed(
                                    child: Text(
                                      "Guardar",
                                      style: AppTextStyle
                                          .normalWhiteContentTextStyle,
                                    ),
                                    onTab: () async {
                                      final isValid =
                                          Form.of(formContext).validate();
                                      if (isValid) {
                                        Form.of(formContext).save();
                                        final result =
                                            await controller.checkedData();
                                        result.when(left: (failure) {
                                          failure.when(
                                              notFound: () => showToast(
                                                  "Datos no encontrado"),
                                              network: () => showToast(
                                                  "No hay conexion con Internet"),
                                              unauthorized: () => showToast(
                                                  "No estas autorizado para realizar esta accion"),
                                              tokenInvalided: () {
                                                showToast("Sesion expirada");
                                                controller.sessionController
                                                    .globalCloseSession();
                                              },
                                              unknown: () => showToast(
                                                  "Hemos tenido un problema"),
                                              emailExist: () => showToast(
                                                  "Email ya registrado"),
                                              formData: (String message) {
                                                showToast(message);
                                              });
                                        }, right: (value) {
                                          showToast(
                                              "Proceso completado correctamente.");
                                          onFinish();
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    });
                              }),
                              SizedBox(
                                height: 32,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
