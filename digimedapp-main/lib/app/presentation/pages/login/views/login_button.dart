import 'package:digimed/app/data/providers/local/local_auth.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/repositories/fcm_repository.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/pages/login/controller/login_controller.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final LoginController controller = Provider.of(context);
    if (controller.state.fetching) {
      return const CircularProgressIndicator();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.73,
          child: ButtonDigimed(
            child: const Text(
              "Iniciar",
              style: AppTextStyle.normalWhiteContentTextStyle,
            ),
            onTab: () {
              if (controller.state.hasCredentials == false) {
                final isValid = Form.of(context).validate();
                if (isValid) {
                  _submit(context);
                }
              } else if (controller.state.hasCredentials == true) {
                if (controller.state.inputVisibles) {
                  controller.onVisibilityInputs();
                } else {
                  final isValid = Form.of(context).validate();
                  if (isValid) {
                    _submit(context);
                  }
                }
              }
            },
          ),
        ),
        Container(
          child: SizedBox(
            height: 48,
            child: FloatingActionButton(
              backgroundColor: AppColors.backgroundColor,
              onPressed: () async {
                if (controller.state.hasCredentials == false) {
                  showToast(
                      'Ingrese sus credenciales para habilitar la autenticacion biometrica.');
                } else {
                  _submitWithBiometric(context);
                }
              },
              child: Icon(
                Icons.fingerprint,
                size: 24.0,
                color:
                    controller.state.hasCredentials ? Colors.white : Colors.red,
              ),
              mini: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context) async {
    final LoginController controller = context.read();

    final result = await controller.submit();

    if (!controller.mounted) {
      return;
    }
    result.when(left: (failure) {
      final message = failure.when(
        notFound: () => "No encontrado",
        network: () => "No hay acceso a internet",
        unauthorized: () => "El email o contraseña son incorrectos.",
        unknown: () => "Error desconocido",
        notVerified: () => "Usuario no verificado",
      );

      showToast(message);
    }, right: (user) async {
      String name = Routes.homeSuperAdmin;
      if (user.rol == "DOCTOR") {
        print("doctor");
        await FirebaseMessaging.instance.subscribeToTopic('doctor');
        name = await _calculateRouteDoctor(context, user);
      } else if (user.rol == "PATIENT") {
        print("paciente");
        await FirebaseMessaging.instance.subscribeToTopic('paciente');
        name = await _calculateRoutePatients(context, user);
      } else if (user.rol == "COORDINATOR") {
        print("coordinador");
        await FirebaseMessaging.instance.subscribeToTopic('coordinador');
        name = await Routes.home;
      }

      Navigator.pushReplacementNamed(
        context,
        name,
      );
    });
  }

  Future<void> _submitWithBiometric(BuildContext context) async {
    final LoginController controller = context.read();
    final FCMRepository fcmRepository = Repositories.fcm;
    final result = await controller.submitWithBiometric();

    if (!controller.mounted) {
      return;
    }

    result.when(left: (failure) {
      final message = failure.when(
        notFound: () => "No encontrado",
        network: () => "No hay acceso a internet",
        unauthorized: () => "El email o contraseña son incorrectos.",
        unknown: () => "Error desconocido",
        notVerified: () => "Usuario no verificado",
      );

      showToast(message);
    }, right: (user) async {
      String name = Routes.homeSuperAdmin;
      fcmRepository.initializeAndManageToken(user);
      if (user.rol == "DOCTOR") {
        print("doctor");
        await fcmRepository.subscribeToTopic('doctor');
        name = await _calculateRouteDoctor(context, user);
      } else if (user.rol == "PATIENT") {
        print("paciente");
        await fcmRepository.subscribeToTopic('paciente');
        name = await _calculateRoutePatients(context, user);
      } else if (user.rol == "COORDINATOR") {
        print("coordinador");
        await fcmRepository.subscribeToTopic('coordinador');
        name = await Routes.home;
      }

      Navigator.pushReplacementNamed(
        context,
        name,
      );
    });
  }

  Future<String> _calculateRouteDoctor(BuildContext context, User user) async {
    final LoginController controller = context.read();
    final resultDoctor = await controller.getMeDoctor(user);
    String name = Routes.welcome;
    name = resultDoctor.when(left: (_) {
      return Routes.welcome;
    }, right: (doctor) {
      if (doctor.contract == null || doctor.contract == false) {
        return Routes.contractDoctor;
      } else if (doctor.registerStep != null && doctor.registerStep! >= 3) {
        return Routes.homeDoctor;
      }
      return Routes.welcome;
    });
    print(name);
    return name;
  }

  Future<String> _calculateRoutePatients(
      BuildContext context, User user) async {
    final LoginController controller = context.read();
    final resultPatient = await controller.getMePatients(user);
    String name = Routes.contract;
    name = resultPatient.when(left: (_) {
      return Routes.login;
    }, right: (patient) {
      print(patient!.toJson());
      if (patient != null) {
        if (patient.signedContract != null && !patient.signedContract!) {
          return Routes.contract;
        } else if (patient.registerStep != null && patient.registerStep! >= 8) {
          return Routes.homePatient;
        }
        return Routes.welcome;
      } else {
        return Routes.login;
      }
    });
    return name;
  }
}
