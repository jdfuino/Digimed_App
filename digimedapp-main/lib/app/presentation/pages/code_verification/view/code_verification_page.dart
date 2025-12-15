import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/code_verification/controller/code_verification_controller.dart';
import 'package:digimed/app/presentation/pages/code_verification/controller/state/code_verification_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class CodeVerificationPage extends StatelessWidget {
  final String userEmail;

  const CodeVerificationPage({Key? key, required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CodeVerificationController>(
      create: (_) => CodeVerificationController(
        CodeVerificationState(),
        authenticationRepository: Repositories.authentication,
      ),
      child: MyScaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.beginGradient, AppColors.endGradient]),
          ),
          child: Form(
            key: _formKey,
            child: Builder(
              builder: (context) {
                final controller =
                    Provider.of<CodeVerificationController>(context);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      child: Assets.svgs.logo.svg(),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Confirmación',
                      style: AppTextStyle.boldTitleTextStyle,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 14, right: 14),
                      child: const Text(
                        "Se ha enviado un codigo a tu correo electronico. Ingresalo para verificar",
                        style: AppTextStyle.normalWhiteContentTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 5),
                      child: PinCodeTextField(
                        textStyle: AppTextStyle.normalWhiteContentTextStyle,
                        appContext: context,
                        length: 6,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                        ),
                        onChanged: (text) {
                          controller.onCodeChanged(text);
                          print(text);
                        },
                        validator: (text) {
                          text = text?.trim().toLowerCase() ?? '';
                          if (text.isEmpty) {
                            return "este campo no puede quedar vacio";
                          } else if (text.length < 6) {
                            return "debes completar todos los campos";
                          }
                          return null;
                        },
                        onSaved: (text) {
                          controller.textCode = text;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, top: 10, bottom: 5),
                      child: controller.state.fetching
                          ? CircularProgressIndicator()
                          : ButtonDigimed(
                              child: const Text(
                                "Confirmar",
                                style: AppTextStyle.normalWhiteContentTextStyle,
                              ),
                              onTab: () async {
                                final isValid =
                                    _formKey.currentState!.validate();
                                if (isValid) {
                                  _formKey.currentState!.save();
                                  pushChangePassword(context, userEmail,
                                      controller.textCode ?? "");
                                }
                              },
                            ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      child: const Text(
                        "By DigimedVen",
                        style: AppTextStyle.normalWhiteContentTextStyle,
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
