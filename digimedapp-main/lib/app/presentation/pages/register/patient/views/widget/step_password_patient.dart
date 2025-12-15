import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
final _formKey = GlobalKey<FormState>();

class StepPasswordPatient extends StatelessWidget {
  const StepPasswordPatient({super.key});

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
            step: 0,
            lastStep: 10,
            onTab: () {

            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Personaliza tu contraseña",
            style: AppTextStyle.normal17ContentTextStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: size.width * 0.20,
            child: SvgPicture.asset(
                Assets.svgs.lockDigimed.path
            ),
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
                      TextFormField(
                        keyboardType: TextInputType.text,
                        style: AppTextStyle.normalTextStyle2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscuringCharacter: "*",
                        onChanged: (text) {
                          //controller.onChangedName(text);
                        },
                        obscureText: controller.state.isVisiblePassword,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.backgroundSearchColor,
                            hintText: 'Nueva contraseña',
                            hintStyle: AppTextStyle.hintTextStyle,
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 15.0, 20.0, 15.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  width: 0.2,
                                  color: AppColors.backgroundSearchColor),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.state.isVisiblePassword
                                    ? DigimedIcon.view
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                controller.onVisibilityPasswordChanged(
                                    !controller.state.isVisiblePassword);
                              },
                            )),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Este campo es obligatorio";
                          } else if (text.length < 6) {
                            return "La contraseña debe tener mas de 6 caracteres";
                          }
                          return null;
                        },
                        onSaved: (text) {
                          controller.password = text;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        style: AppTextStyle.normalTextStyle2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscuringCharacter: "*",
                        onChanged: (text) {
                          //controller.onChangedName(text);
                        },
                        obscureText: controller.state.isVisiblePassword,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.backgroundSearchColor,
                            hintText: 'Confirmar contraseña',
                            hintStyle: AppTextStyle.hintTextStyle,
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 15.0, 20.0, 15.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  width: 0.2,
                                  color: AppColors.backgroundSearchColor),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.state.isVisiblePassword
                                    ? DigimedIcon.view
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                controller.onVisibilityPasswordChanged(
                                    !controller.state.isVisiblePassword);
                              },
                            )),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Este campo es obligatorio";
                          } else if (text.length < 6) {
                            return "La contraseña debe tener mas de 6 caracteres";
                          }
                          return null;
                        },
                        onSaved: (text) {
                          controller.confirmPassword = text;
                        },
                      )
                    ],
                  ),
                ),
              )),
          const SizedBox(
            height: 16,
          ),
          controller.state.requestState.when(
              fetch: (){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              normal: (){
                return ButtonDigimed(
                    child: const Text(
                      "Siguiente",
                      style: AppTextStyle.normalWhiteContentTextStyle,
                    ),
                    onTab: () async{
                      _formKey.currentState!.save();
                      final isValid = _formKey.currentState!.validate();
                      print(controller.password);
                      print(controller.confirmPassword);
                      if(isValid){
                        if(controller.password == controller.confirmPassword){
                          await controller.changePassword();
                        }
                        else{
                          showToast("las contraseñas no coinciden");
                        }
                      }
                    });
              }),

          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
