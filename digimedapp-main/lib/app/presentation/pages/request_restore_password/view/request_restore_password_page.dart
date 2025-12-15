import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/request_restore_password/controller/request_restore_password_controller.dart';
import 'package:digimed/app/presentation/pages/request_restore_password/controller/state/request_restore_password_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class RequestPasswordPage extends StatelessWidget {
  const RequestPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestPasswordController>(
      create: (_) => RequestPasswordController(
        RequestPasswordState(),
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
              colors: [AppColors.beginGradient, AppColors.endGradient],
            ),
          ),
          child: Form(
            key: _formKey,
            child: Builder(builder: (context) {
              final controller =
                  Provider.of<RequestPasswordController>(context);
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
                      'Recuperar Contraseña',
                      style: AppTextStyle.boldTitleTextStyle,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 14, right: 14),
                      child: const Text(
                        "Para recuperar tu contraseña, ingresa el correo electrónico asociado a tu cuenta. Te enviaremos un código de confirmación para que puedas restablecer tu contraseña.",
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
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyle.normalTextStyle2,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onUsernameChanged(text);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.backgroundInput,
                          hintText: 'Email',
                          hintStyle: AppTextStyle.hintTextStyle2,
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.contentTextColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(
                            Icons.email,
                            size: 15,
                          ),
                        ),
                        validator: (text) {
                          text = text?.trim().toLowerCase() ?? '';
                          if (text.isEmpty) {
                            return "este campo no puede quedar vacio";
                          } else if (!text.isValidEmail()) {
                            return "formato de emali no valido";
                          }
                          return null;
                        },
                        onSaved: (text) {
                          controller.textEmail = text;
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
                                "Enviar",
                                style: AppTextStyle.normalWhiteContentTextStyle,
                              ),
                              onTab: () async {
                                final isValid =
                                    _formKey.currentState!.validate();
                                if (isValid) {
                                  final result =
                                      await controller.requestRestorePasswrod();
                                  result.when(
                                    left: (_) {},
                                    right: (isValid) {
                                      if (isValid) {
                                        _formKey.currentState!.save();
                                        pushCodeVerification(context,
                                            controller.textEmail ?? "");
                                      }
                                    },
                                  );
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
                  ]);
            }),
          ),
        ),
      ),
    );
  }
}
