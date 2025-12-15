import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/login/controller/login_controller.dart';
import 'package:digimed/app/presentation/pages/login/controller/state/login_state.dart';
import 'package:digimed/app/presentation/pages/login/views/login_button.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginController>(
      create: (_) => LoginController(const LoginState(),
          authenticationRepository: Repositories.authentication,
          sessionController: context.read(),
          fcmRepository: Repositories.fcm,
          accountRepository: Repositories.account)
        ..init(),
      child: MyScaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) {
            final controller = Provider.of<LoginController>(
              context,
              listen: true,
            );
            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.beginGradient, AppColors.endGradient]),
              ),
              child: Form(
                child: Builder(builder: (context) {
                  final controller =
                      Provider.of<LoginController>(context, listen: true);
                  return AbsorbPointer(
                    absorbing: controller.state.fetching,
                    child: Column(
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
                            'Iniciar sesión',
                            style: AppTextStyle.boldTitleTextStyle,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Visibility(
                            visible: !controller.state.inputVisibles,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {
                                  controller.onUsernameChanged(text);
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundInput,
                                  hintText: 'Usuario',
                                  hintStyle: AppTextStyle.hintTextStyle2,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
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
                                    DigimedIcon.user,
                                    size: 15,
                                  ),
                                ),
                                validator: (text) {
                                  text = text?.trim().toLowerCase() ?? '';

                                  if (text.isEmpty) {
                                    return "este campo no puede quedar vacido";
                                  } else if (!text.isValidEmail()) {
                                    return "formato de emali no valido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !controller.state.inputVisibles,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (text) {
                                  controller.onPasswordChanged(text);
                                },
                                obscureText: !controller.state.visibility,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.backgroundInput,
                                    hintText: 'Contraseña',
                                    hintStyle: AppTextStyle.hintTextStyle2,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.contentTextColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: const Icon(
                                      DigimedIcon.pass,
                                      size: 15,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        controller.state.visibility
                                            ? Icons.visibility
                                            : DigimedIcon.view,
                                        size: 17,
                                      ),
                                      onPressed: () {
                                        controller.onVisibilityChanged(
                                            !controller.state.visibility);
                                      },
                                    )),
                                validator: (text) {
                                  text = text?.replaceAll(' ', '') ?? '';
                                  if (text.isEmpty) {
                                    return "este campo no puede quedar vacido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const LoginButton(),
                          Container(
                            margin: const EdgeInsets.only(top: 18, bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                pushNewPageRestorePassword(context);
                              },
                              child: const Text(
                                "¿ Recuperar Contraseña ?",
                                style: AppTextStyle.hintTextStyle2,
                              ),
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
                        ]),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
