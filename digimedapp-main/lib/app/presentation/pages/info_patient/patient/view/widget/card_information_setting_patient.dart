import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/controller/info_patient_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class CardInformationSettingPatient extends StatelessWidget {
  const CardInformationSettingPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    print(size.height);
    return Container(
      height: 490,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 24,
            left: 24,
            child: Container(
              height: 490,
              child: CardDigimed(
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                  padding: const EdgeInsets.only(top: 16),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Tu Información",
                                      style: AppTextStyle
                                          .normal16W500ContentTextStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                    controller.state.requestState.when(
                                        fetch: () {
                                      return const CircularProgressIndicator();
                                    }, normal: () {
                                      return ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            backgroundColor: AppColors
                                                .backgroundSettingSaveColor),
                                        icon: const Icon(
                                          DigimedIcon.save,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        label: const Text(
                                          "Guardar",
                                          style: AppTextStyle.normalTextStyle,
                                        ),
                                        onPressed: () {
                                          final isValid =
                                              _formKey.currentState!.validate();
                                          if (isValid) {
                                            _formKey.currentState!.save();
                                            controller.checkData();
                                          }
                                        },
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  style: AppTextStyle.normalTextStyle2,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: controller.dateCtl,
                                  onTap: () async {
                                    DateTime? date = DateTime.parse(
                                        controller.patients.user.birthday);
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());

                                    date = await showMiDatePicker(
                                      context: context,
                                    );
                                    if (date != null) {
                                      if (date.isLegalAge()) {
                                        controller.onChangedDate(date);
                                      } else {
                                        showToast(
                                            "El usuario no es mayor de edad.");
                                      }
                                    }
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.backgroundSearchColor,
                                    hintText: convertDate(
                                        controller.patients.user.birthday),
                                    hintStyle: AppTextStyle.hintTextStyle,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0.2,
                                          color:
                                              AppColors.backgroundSearchColor),
                                    ),
                                  ),
                                ),
                                const Divider(),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  style: AppTextStyle.normalTextStyle2,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (text) {},
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.backgroundSearchColor,
                                    hintText: controller.patients.user.email,
                                    hintStyle: AppTextStyle.hintTextStyle,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0.2,
                                          color:
                                              AppColors.backgroundSearchColor),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return null;
                                    } else if (!text.isValidEmail()) {
                                      return "Formato de email no valido";
                                    }
                                    return null;
                                  },
                                  onSaved: (text) {
                                    if (text != null && text.isNotEmpty) {
                                      controller.email = text;
                                    }
                                  },
                                ),
                                const Divider(),
                                IntlPhoneField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.backgroundSearchColor,
                                    hintText:
                                        controller.patients.user.phoneNumber,
                                    hintStyle: AppTextStyle.hintTextStyle,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0.2,
                                          color:
                                              AppColors.backgroundSearchColor),
                                    ),
                                  ),
                                  validator: (phone) {
                                    if (phone == null) {
                                      return null;
                                    } else if (!phone.number
                                        .isValidIdNumber()) {
                                      return "El numero telefonico no puede empezar con 0";
                                    }
                                    return null;
                                  },
                                  initialCountryCode: getIsoCodeFromDialCode(
                                      controller.patients.user.countryCode),
                                  disableLengthCheck: true,
                                  onSaved: (phone) {
                                    if (phone != null) {
                                      if (phone.number.isNotEmpty) {
                                        controller.phoneNumber = phone.number;
                                      }
                                      if (phone.countryCode.isNotEmpty &&
                                          phone.countryCode !=
                                              controller
                                                  .patients.user.countryCode) {
                                        controller.countryCode =
                                            phone.countryCode;
                                      }
                                    }
                                  },
                                ),
                                const Divider(),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  style: AppTextStyle.normalTextStyle2,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (text) {},
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.backgroundSearchColor,
                                    hintText:
                                        controller.patients.user.occupation,
                                    hintStyle: AppTextStyle.hintTextStyle,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0.2,
                                          color:
                                              AppColors.backgroundSearchColor),
                                    ),
                                  ),
                                  validator: (text) {
                                    return null;
                                  },
                                  onSaved: (text) {
                                    if (text != null && text.isNotEmpty) {
                                      controller.occupation = text;
                                    }
                                  },
                                ),
                                const Divider(),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: AppTextStyle.normalTextStyle2,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (text) {},
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.backgroundSearchColor,
                                    hintText: controller.patients.user.weight !=
                                            null
                                        ? "${showNumber2(controller.patients.user.weight!)} kg"
                                        : "0 kg",
                                    hintStyle: AppTextStyle.hintTextStyle,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0.2,
                                          color:
                                              AppColors.backgroundSearchColor),
                                    ),
                                  ),
                                  validator: (weight) {
                                    if (weight == null || weight.isEmpty) {
                                      return null;
                                    } else if (!weight.isValidWeightNumber()) {
                                      return "Peso incorrecto, ej: 70.0";
                                    } else if (!weight.isWeightInValidRange()) {
                                      return "Fuera de rango";
                                    }
                                    return null;
                                  },
                                  onSaved: (weight) {
                                    if (weight != null && weight.isNotEmpty) {
                                      controller.weight =
                                          double.parse(weight ?? "0.0");
                                    }
                                  },
                                ),
                                const Divider(),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  style: AppTextStyle.normalTextStyle2,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (text) {},
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.backgroundSearchColor,
                                    hintText: controller.patients.user.height !=
                                            null
                                        ? "${showNumber2(controller.patients.user.height!)} m"
                                        : "0 m",
                                    hintStyle: AppTextStyle.hintTextStyle,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0.2,
                                          color:
                                              AppColors.backgroundSearchColor),
                                    ),
                                  ),
                                  validator: (weight) {
                                    if (weight == null || weight.isEmpty) {
                                      return null;
                                    } else if (!weight.isValidWeightNumber()) {
                                      return "Altura incorrecto, ej: 70.0";
                                    } else if (!weight.isHeightInValidRange()) {
                                      return "Fuera de rango";
                                    }
                                    return null;
                                  },
                                  onSaved: (weight) {
                                    if (weight != null && weight.isNotEmpty) {
                                      controller.height =
                                          double.parse(weight ?? "0.0");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}