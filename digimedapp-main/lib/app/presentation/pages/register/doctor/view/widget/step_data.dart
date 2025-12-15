import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/controller/register_doctor_controller.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class StepData extends StatelessWidget {
  const StepData({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterDoctorController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 24, left: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 1,
            lastStep: 3,
            onTab: () {
              // controller.step -= 1;
              // controller.changeState();
            },
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Completa tus datos personales",
            style: AppTextStyle.normal17ContentTextStyle,
          ),
          SizedBox(
            height: 16,
          ),
          Form(
              key: _formKey,
              child: CardDigimed(
                child: Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.only(right: 24, left: 24, top: 24, bottom: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hola,",
                                  style: AppTextStyle
                                      .normal12W500ContentTextStyle),
                              Text(
                                controller.doctor!.user.fullName,
                                style: AppTextStyle.boldContentTextStyle,
                              ),
                              Text(
                                "${controller.doctor!.user.identificationType}.${controller.doctor!.user.identificationNumber}",
                                style:
                                    AppTextStyle.normal14W400ContentTextStyle,
                              )
                            ],
                          ),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: AppColors.backgroundSearchColor,
                            radius: size.width * 0.10,
                            child: Icon(
                              DigimedIcon.user,
                              color: AppColors.contentTextColor,
                              size: size.width * 0.07,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        style: AppTextStyle.normalTextStyle2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.dateCtl,
                        onTap: () async {
                          DateTime? date =
                              DateTime.parse(controller.doctor!.user.birthday);
                          FocusScope.of(context).requestFocus(new FocusNode());

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
                          hintText:
                              convertDate(controller.doctor!.user.birthday),
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
                      SizedBox(
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
                          hintText: controller.doctor!.user.email,
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
                          print(text);
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
                      SizedBox(
                        height: 8,
                      ),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundSearchColor,
                          hintText: controller.doctor!.user.phoneNumber,
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
                            controller.doctor!.user.countryCode),
                        onSaved: (phone) {
                          if (phone != null) {
                            if (phone.number.isNotEmpty) {
                              controller.phoneNumber = phone.number;
                            }
                            if (phone.countryCode.isNotEmpty &&
                                phone.countryCode !=
                                    controller.doctor!.user.countryCode) {
                              controller.countryCode = phone.countryCode;
                            }
                          }
                        },
                      ),
                      SizedBox(
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
                          hintText: controller.doctor!.user.occupation,
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
                            controller.occupation = text;
                          }
                        },
                      )
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 32,
          ),
          controller.state.requestState.when(
              fetch: (){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              normal: (){
                return ButtonDigimed(
                    child: Text(
                      "Siguiente",
                      style: AppTextStyle.normalWhite15W600ContentTextStyle,
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
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
