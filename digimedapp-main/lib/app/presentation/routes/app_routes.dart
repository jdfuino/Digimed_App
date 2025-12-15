import 'package:digimed/app/presentation/pages/contract/doctor/view/contract_doctor_page.dart';
import 'package:digimed/app/presentation/pages/contract/patient/view/contract_page.dart';
import 'package:digimed/app/presentation/pages/home/admin/home/views/home_admin_page.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home/view/home_doctor_page.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/home_patient_page.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home/view/super_admin_home_page.dart';
import 'package:digimed/app/presentation/pages/login/views/login_page.dart';
import 'package:digimed/app/presentation/pages/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:digimed/app/presentation/pages/splash/splash_page.dart';
import 'package:digimed/app/presentation/routes/routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes{
  return {
    Routes.splash: (context) => const SplashPage(),
    Routes.login: (context) => const LoginPage(),
    Routes.home: (context) => const AdminHomePage(),
    Routes.welcome: (context) => const WelcomePage(),
    Routes.homeDoctor: (context) => const HomeDoctorPage(),
    Routes.homePatient: (context) => const HomePatientPage(),
    Routes.contract: (context) => const ContractPage(),
    Routes.contractDoctor: (context) => const ContractDoctorPage(),
    Routes.homeSuperAdmin: (context) => const SuperAdminHomePage(),
  };
}