import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/repositories/fcm_repository.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
    });
  }

  Future<void> _init() async {
    final routeName = await () async {
      final SessionController sessionController = context.read();
      final FCMRepository fcmRepository = Repositories.fcm;
      final isSignedIn = await Repositories.authentication.isSignedIn;

      if (!isSignedIn) {
        return Routes.login;
      }

      final user = await Repositories.account.getUserData();
      logger.i(user);

      if (user != null) {
        sessionController.setUser(user);
        fcmRepository.initializeAndManageToken(user);
        logger.i(sessionController.state!);
        if(user.rol == "DOCTOR"){
          return _calculateRouteDoctor(user);
        }
        else if(user.rol == "PATIENT"){
          return _calculateRoutePatients(user);
        } else if(user.rol == "COORDINATOR"){
        return Routes.home;
        }
        return Routes.homeSuperAdmin;
      }
      return Routes.login;
    }();

    if (mounted) {
      Future.delayed(const Duration(milliseconds: 2000), (){
        _goTo(routeName);
      });
    }

  }

  void _goTo(String routeName) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
    );
  }

  Future<String> _calculateRouteDoctor(User user) async{
    final SessionController sessionController = context.read();
    final resultDoctor = await Repositories.account.getMeDoctor(user);

    String name = Routes.welcome;
    name = resultDoctor.when(
        left: (_){
          return Routes.login;
        },
        right: (doctor){
          sessionController.doctor = doctor;
          if(doctor.contract == null || doctor.contract == false){
            return Routes.contractDoctor;
          }
          else if(doctor.registerStep != null && doctor.registerStep! >= 3){
            return Routes.homeDoctor;
          }
          return Routes.welcome;
        });

    return name;
  }

  Future<String> _calculateRoutePatients(User user) async {
    final SessionController controller = context.read();
    final resultPatient = await Repositories.account.getMePatient(user);
    String name = Routes.contract;
    name = resultPatient.when(
        left: (_){
          return Routes.login;
        },
        right: (patient){
          controller.patients = patient;

          if(patient != null){
            if(patient.signedContract != null && !patient.signedContract!){
              return Routes.contract;
            }
            else if(patient.registerStep != null && patient.registerStep! >= 8){
              return Routes.homePatient;
            }
            return Routes.welcome;
          }else{
              return Routes.login;
          }
        });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.beginGradient,
              AppColors.endGradient])),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/lottiefiles/Splash_Animate.json',
        width: 250,height: 250,fit: BoxFit.fill),
      ],
        ),
      ),
    );
  }
}
