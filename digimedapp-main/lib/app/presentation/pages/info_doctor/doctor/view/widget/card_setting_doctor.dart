import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/info_doctor/doctor/controller/info_doctor_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class CardSettingDoctor extends StatelessWidget {
  const CardSettingDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoDoctorController controller = Provider.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24),
      child: CardDigimed(
          child: controller.state.myDoctorDataState.when(loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, faild: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, sucess: (user, _) {
            if(controller.state.isSetting){
              return _formSetting(
                  date: convertDate(user.birthday),
                  email: user.email,
                  countryCode: user.countryCode,
                  phone: user.phoneNumber,
                  occupation: user.occupation,
                  context: context
              );
            }
            else{
              return _formNormal(
                  date: convertDate(user.birthday),
                  email: user.email,
                  phone: "${user.countryCode}-${user.phoneNumber}",
                  occupation: user.occupation,
                  tapButton: controller.settingChanged);
            }
          })),
    );
  }

  Widget _formSetting(
      {required String date,
        required String email,
        required String countryCode,
        required String phone,
        required String occupation,
        required BuildContext context}
      ){
    final InfoDoctorController controller = Provider.of(context);
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.state.requestState.when(
              fetch: (){
                return const CircularProgressIndicator();
              },
              normal: (){
            return ElevatedButton.icon(
              style:  ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundSettingSaveColor
              ) ,
              icon: const Icon(
                DigimedIcon.save,
                color: Colors.white,
                size: 20,
              ),
              label: const Text("Guardar" , style: AppTextStyle.normalWhiteContentTextStyle,),
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if(isValid){
                  _formKey.currentState!.save();
                  controller.checkData();
                }
              },
            );
          }),

          const SizedBox(height: 16,),

          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    style: AppTextStyle.normalTextStyle2,
                    controller: controller.dateCtl,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {},
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundSearchColor,
                      hintText: date,
                      hintStyle: AppTextStyle.hintTextStyle,
                      contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 0.2, color: AppColors.backgroundSearchColor),
                      ),
                    ),
                    onTap: () async {
                      DateTime? date = DateTime(1900);
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
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    style: AppTextStyle.normalTextStyle2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundSearchColor,
                      hintText: email,
                      hintStyle: AppTextStyle.hintTextStyle,
                      contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 0.2, color: AppColors.backgroundSearchColor),
                      ),
                    ),
                    validator: (text) {
                      print(text);
                      if( text == null || text.isEmpty){
                        return null;
                      }
                      else if (!text.isValidEmail()) {
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
                  const SizedBox(
                    height: 8,
                  ),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundSearchColor,
                      hintText: phone,
                      hintStyle: AppTextStyle.hintTextStyle,
                      contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 0.2, color: AppColors.backgroundSearchColor),
                      ),
                    ),
                    disableLengthCheck: true,
                    validator: (phone) {
                      if (phone == null) {
                        return null;
                      } else if (!phone.number.isValidIdNumber()) {
                        return "El numero telefonico no puede empezar con 0";
                      }
                      return null;
                    },
                    initialCountryCode: getIsoCodeFromDialCode(countryCode),
                    onSaved: (phone) {
                      if (phone != null) {
                        if (phone.number.isNotEmpty) {
                          controller.phoneNumber = phone.number;
                        }
                        if(phone.countryCode.isNotEmpty &&
                            phone.countryCode != controller.userTemp.countryCode){
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
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.backgroundSearchColor,
                        hintText: occupation,
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
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _formNormal(
      {required String date,
        required String email,
        required String phone,
        required String occupation,
        required Function tapButton}) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              tapButton();
            },
            child: const Icon(
              DigimedIcon.edit,
              color: AppColors.backgroundColor,
              size: 23,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fecha de nacimiento",
                style: AppTextStyle.subW500NormalContentTextStyle,
              ),
              Text(
                date,
                style: AppTextStyle.normal17ContentTextStyle,
              ),
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Correo electrónico",
                style: AppTextStyle.subW500NormalContentTextStyle,
              ),
              Text(
                email,
                style: AppTextStyle.normal17ContentTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Teléfono",
                style: AppTextStyle.subW500NormalContentTextStyle,
              ),
              Text(
                phone,
                style: AppTextStyle.normal17ContentTextStyle,
              ),
            ],
          ),
          const Divider(color: AppColors.dividerColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Especialidad",
                style: AppTextStyle.subW500NormalContentTextStyle,
              ),
              Container(
                width: double.maxFinite,
                child: Text(
                  occupation,
                  style: AppTextStyle.normal17ContentTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
