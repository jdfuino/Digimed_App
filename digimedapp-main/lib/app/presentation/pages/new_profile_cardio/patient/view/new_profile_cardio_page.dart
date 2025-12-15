import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/domain/models/profile_cardio_input/profile_cardio_input.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_cardio.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class NewProfileCardioPage extends StatefulWidget {
  final int id;
  final int doctorID;

  const NewProfileCardioPage(
      {super.key, required this.id, required this.doctorID});

  @override
  State<NewProfileCardioPage> createState() => _NewProfileCardioPageState();
}

class _NewProfileCardioPageState extends State<NewProfileCardioPage> {
  double sistolic = 0.0, distolic = 0.0, frecuency = 0.0, hours = 0.0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return MyScaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                BannerCardio(
                  iconRight: DigimedIcon.back,
                  onClickIconRight: () {
                    Navigator.pop(context, false);
                  },
                ),
                Container(
                  margin:
                      const EdgeInsets.only(right: 24, left: 24, bottom: 32),
                  child: CardDigimed(
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.help_outline,
                                      size: 21,
                                      color: AppColors.backgroundColor,
                                    )),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 20, left: 24),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(Assets.svgs.iconPrsion.path,
                                    height: 63, width: 59),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Perfil cardiovascular",
                                        style:
                                            AppTextStyle.boldContentTextStyle,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Coloca los datos que muestra el tensiómetro y guárdalos para agregarlo a tu seguimiento de estado clínico.",
                                        style:
                                            AppTextStyle.normalContentTextStyle,
                                        softWrap: true,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Form(
                              key: _formKey,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(right: 24, left: 24),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Sistólica",
                                              style: AppTextStyle
                                                  .sub13W500NormalContentTextStyle,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              width: size.width * 0.35,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                style: AppTextStyle
                                                    .normalTextStyle2,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                onChanged: (text) {},
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: AppColors
                                                      .backgroundSearchColor,
                                                  labelStyle: AppTextStyle
                                                      .hintTextStyle,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          20.0,
                                                          15.0,
                                                          20.0,
                                                          15.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: const BorderSide(
                                                        width: 0.2,
                                                        color: AppColors
                                                            .backgroundSearchColor),
                                                  ),
                                                ),
                                                validator: (weight) {
                                                  if (weight == null ||
                                                      weight.isEmpty) {
                                                    return "valor requerido";
                                                  } else if (!weight
                                                      .isValidWeightNumber()) {
                                                    return "valor no valido";
                                                  } else if (!weight
                                                      .isSystolicInValidRange()) {
                                                    return "Fuera de rango: 0 y 250 mmHg";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (weight) {
                                                  if (weight != null &&
                                                      weight.isNotEmpty) {
                                                    sistolic = double.parse(
                                                        weight ?? "0.0");
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Diastólica",
                                              style: AppTextStyle
                                                  .sub13W500NormalContentTextStyle,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              width: size.width * 0.35,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                style: AppTextStyle
                                                    .normalTextStyle2,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                onChanged: (text) {},
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: AppColors
                                                      .backgroundSearchColor,
                                                  labelStyle: AppTextStyle
                                                      .hintTextStyle,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          20.0,
                                                          15.0,
                                                          20.0,
                                                          15.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: const BorderSide(
                                                        width: 0.2,
                                                        color: AppColors
                                                            .backgroundSearchColor),
                                                  ),
                                                ),
                                                validator: (weight) {
                                                  if (weight == null ||
                                                      weight.isEmpty) {
                                                    return "valor requerido";
                                                  } else if (!weight
                                                      .isValidWeightNumber()) {
                                                    return "valor no valido";
                                                  } else if (!weight
                                                      .isDiastolicInValidRange()) {
                                                    return "Fuera de rango: 0 y 140 mmHg";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (weight) {
                                                  if (weight != null &&
                                                      weight.isNotEmpty) {
                                                    distolic = double.parse(
                                                        weight ?? "0.0");
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.width * 0.30,
                                              child: const Text(
                                                "Frecuencia cardíaca",
                                                softWrap: true,
                                                style: AppTextStyle
                                                    .sub13W500NormalContentTextStyle,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              width: size.width * 0.35,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                style: AppTextStyle
                                                    .normalTextStyle2,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                onChanged: (text) {},
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: AppColors
                                                      .backgroundSearchColor,
                                                  labelStyle: AppTextStyle
                                                      .hintTextStyle,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          20.0,
                                                          15.0,
                                                          20.0,
                                                          15.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: const BorderSide(
                                                        width: 0.2,
                                                        color: AppColors
                                                            .backgroundSearchColor),
                                                  ),
                                                ),
                                                validator: (weight) {
                                                  if (weight == null ||
                                                      weight.isEmpty) {
                                                    return "valor requerido";
                                                  } else if (!weight
                                                      .isValidWeightNumber()) {
                                                    return "valor no valido";
                                                  } else if (!weight
                                                      .isHeartRateInValidRange()) {
                                                    return "Fuera de rango: 0 y 250 ppm";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (weight) {
                                                  if (weight != null &&
                                                      weight.isNotEmpty) {
                                                    frecuency = double.parse(
                                                        weight ?? "0.0");
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 14,
                                            ),
                                            const Text(
                                              '''Horas de sueño''',
                                              softWrap: true,
                                              style: AppTextStyle
                                                  .sub13W500NormalContentTextStyle,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              width: size.width * 0.35,
                                              child: TextFormField(
                                                keyboardType: TextInputType
                                                    .number,
                                                style: AppTextStyle
                                                    .normalTextStyle2,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                onChanged: (text) {},
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: AppColors
                                                      .backgroundSearchColor,
                                                  labelStyle: AppTextStyle
                                                      .hintTextStyle,
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          20.0,
                                                          15.0,
                                                          20.0,
                                                          15.0),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: const BorderSide(
                                                        width: 0.2,
                                                        color: AppColors
                                                            .backgroundSearchColor),
                                                  ),
                                                ),
                                                validator: (weight) {
                                                  if (weight == null ||
                                                      weight.isEmpty) {
                                                    return "valor requerido";
                                                  } else if (!weight
                                                      .isValidWeightNumber()) {
                                                    return "valor no valido";
                                                  } else if (!weight
                                                      .isSleepInValidRange()) {
                                                    return "Fuera de rango: 0 y 24 horas";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (weight) {
                                                  if (weight != null &&
                                                      weight.isNotEmpty) {
                                                    hours = double.parse(
                                                        weight ?? "0.0");
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ButtonDigimed(
                                        child: const Text(
                                          "Guardar",
                                          style: AppTextStyle
                                              .normalWhiteContentTextStyle,
                                        ),
                                        onTab: () async {
                                          final isValid =
                                              _formKey.currentState!.validate();
                                          if (isValid) {
                                            _formKey.currentState!.save();
                                            final account =
                                                Repositories.account;
                                            SessionController
                                                sessionController =
                                                context.read();
                                            ProfileCardioInput input =
                                                ProfileCardioInput(
                                                    patientID: widget.id,
                                                    systolicPressure:
                                                        sistolic.round(),
                                                    diastolicPressure:
                                                        distolic.round(),
                                                    heartFrequency:
                                                        frecuency.round(),
                                                    sleepingHours:
                                                        hours.round());
                                            final result = await account
                                                .createNewProfileCardio(input,
                                                    widget.id, widget.doctorID);
                                            result.when(left: (failure) {
                                              failure.when(
                                                  notFound: () => showToast(
                                                      "Datos no encontrado"),
                                                  network: () => showToast(
                                                      "No hay conexion con Internet"),
                                                  unauthorized: () => showToast(
                                                      "No estas autorizado para realizar esta accion"),
                                                  tokenInvalided: () {
                                                    showToast(
                                                        "Sesion expirada");
                                                    sessionController
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
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              Navigator.pop(context, true);
                                            });
                                          }
                                        }),
                                    const SizedBox(
                                      height: 32,
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
