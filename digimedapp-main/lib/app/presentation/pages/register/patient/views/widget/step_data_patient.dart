import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class StepDataPatient extends StatelessWidget {
  const StepDataPatient({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 1,
            lastStep: 10,
            onTab: () {
              // controller.step -= 1;
              // controller.changeState();
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Completa tus datos personales",
            style: AppTextStyle.normal17ContentTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          Form(
              key: _formKey,
              child: CardDigimed(
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.only(right: 24, left: 24, top: 24, bottom: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Hola,",
                                  style: AppTextStyle.normal12W500ContentTextStyle),
                              Text(
                                controller
                                    .sessionController.patients!.user.fullName,
                                style: AppTextStyle.boldContentTextStyle,
                              ),
                              Text(
                                "${controller.sessionController.patients!.user.identificationType}.${controller.sessionController.patients!.user.identificationNumber}",
                                style: AppTextStyle.normal14W400ContentTextStyle,
                              )
                            ],
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: AppColors.backgroundSearchColor,
                            radius: size.width * 0.10,
                            child: Icon(
                              DigimedIcon.user,
                              color: AppColors.backgroundColor,
                              size: size.width * 0.07,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        style: AppTextStyle.normalTextStyle2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.dateCtl,
                        onTap: () async {
                          DateTime? date = DateTime.parse(
                              controller.patientsTemp!.user.birthday);
                          FocusScope.of(context).requestFocus(FocusNode());

                          date = await showMiDatePicker(
                            context: context,
                          );
                          if (date != null) {
                            if(date.isLegalAge()){
                              controller.onChangedDate(date);
                            }else{
                              showToast("El usuario no es mayor de edad.");
                            }
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundSearchColor,
                          hintText: convertDate(controller
                              .sessionController.patients!.user.birthday),
                          hintStyle: AppTextStyle.hintTextStyle,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                width: 0.2,
                                color: AppColors.backgroundSearchColor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        style: AppTextStyle.normalTextStyle2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {},
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundSearchColor,
                          hintText:
                              controller.sessionController.patients!.user.email,
                          hintStyle: AppTextStyle.hintTextStyle,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                width: 0.2,
                                color: AppColors.backgroundSearchColor),
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
                            controller.emailTemp = text;
                            controller.email = text;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundSearchColor,
                          hintText: controller
                              .sessionController.patients!.user.phoneNumber,
                          hintStyle: AppTextStyle.hintTextStyle,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                width: 0.2,
                                color: AppColors.backgroundSearchColor),
                          ),
                        ),
                        disableLengthCheck: true,
                        validator: (phone) {
                          if (phone == null) {
                            return null;
                          } else if (phone.number.isNotEmpty &&
                              !phone.number.isValidIdNumber()) {
                            return "El numero telefonico no puede empezar con 0";
                          }
                          return null;
                        },
                        initialCountryCode: getIsoCodeFromDialCode(
                            controller.patientsTemp!.user.countryCode),
                        onSaved: (phone) {
                          if (phone != null) {
                            if (phone.number.isNotEmpty) {
                              controller.phoneNumber = phone.number;
                            }
                            if (phone.countryCode.isNotEmpty &&
                                phone.countryCode !=
                                    controller.patientsTemp!.user.countryCode) {
                              controller.countryCode = phone.countryCode;
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        style: AppTextStyle.normalTextStyle2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {},
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundSearchColor,
                          hintText: controller
                              .sessionController.patients!.user.occupation,
                          hintStyle: AppTextStyle.hintTextStyle,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                width: 0.2,
                                color: AppColors.backgroundSearchColor),
                          ),
                        ),
                        validator: (text) {
                          return null;
                        },
                        onSaved: (text) {
                          if (text != null && text.isNotEmpty) {
                            controller.occupationTemp = text;
                            controller.occupation = text;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(
                            width: size.width * 0.35,
                            child: TextFormField(
                              keyboardType:TextInputType.text,
                              style: AppTextStyle.normalTextStyle2,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (text) {},
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.backgroundSearchColor,
                                hintText: "${showNumber2(controller.patientsTemp!.user.weight ?? 2)} kg",
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
                                  return "ej: 70.0";
                                }
                                else
                                if (!weight.isWeightInValidRange()) {
                                  return "Fuera de rango";
                                }
                                return null;
                              },
                              onSaved: (weight) {
                                if (weight != null && weight.isNotEmpty) {
                                  controller.weight = double.parse(weight ?? "0.0");
                                }
                              },
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: size.width * 0.35,
                            child: TextFormField(
                              keyboardType:TextInputType.text,
                              style: AppTextStyle.normalTextStyle2,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (text) {},
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.backgroundSearchColor,
                                hintText: "${showNumber2(controller.patientsTemp!.user.height ?? 0.1)} m",
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
                                  return "ej: 1.7";
                                }
                                else
                                if (!weight.isHeightInValidRange()) {
                                  return "Fuera de rango";
                                }
                                return null;
                              },
                              onSaved: (weight) {
                                if (weight != null && weight.isNotEmpty) {
                                  controller.height = double.parse(weight ?? "0.0");
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
          const SizedBox(
            height: 16,
          ),
          controller.state.requestState.when(fetch: (){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, normal: (){
            return ButtonDigimed(
                child: const Text(
                  "Siguiente",
                  style: AppTextStyle.normalWhiteContentTextStyle,
                ),
                onTab: () async {
                  _formKey.currentState!.save();
                  final isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    await controller.checkData();
                    if(controller.nexStep){
                      controller.nexStep = false;
                      controller.step = 2;
                      await controller.changeState();
                    }
                  }
                });
          }),

          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
