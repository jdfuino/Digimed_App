import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/historic_patients_admin.dart';
import 'package:digimed/app/presentation/pages/historic/patient/view/historic_patient_page.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/home_patient_admin_page.dart';
import 'package:digimed/app/presentation/pages/home/patient/view/widget/home_patient.dart';
import 'package:digimed/app/presentation/pages/info_patient/patient/view/info_patient_page.dart';
import 'package:digimed/app/presentation/pages/reports_patients/view/reports_patient_page.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomePatientPage extends StatefulWidget {
  const HomePatientPage({super.key});

  @override
  State<HomePatientPage> createState() => _HomePatientPageState();
}

class _HomePatientPageState extends State<HomePatientPage> {
  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    sessionController.setContext(context);
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(context),
      items: _navBarsItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(20.0),
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }

  List<Widget> _buildScreens(BuildContext context) {
    final SessionController sessionController = context.read();
    return [
      HomePatient(
        patients: sessionController.patients!,
      ),
      HistoricPatientPage(patientID: sessionController.patients!.patientID),
      ReportsPatientPage(
        patients: sessionController.patients!,
        fatherContext: context,
      ),
      InfoPatientPage(patients: sessionController.patients!, close: _close)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(DigimedIcon.status),
        activeColorPrimary: AppColors.contactColor,
        inactiveColorPrimary: AppColors.contentTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(DigimedIcon.history),
        activeColorPrimary: AppColors.contactColor,
        inactiveColorPrimary: AppColors.contentTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(DigimedIcon.edit),
        activeColorPrimary: AppColors.contactColor,
        inactiveColorPrimary: AppColors.contentTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(DigimedIcon.user),
        activeColorPrimary: AppColors.contactColor,
        inactiveColorPrimary: AppColors.contentTextColor,
      ),
    ];
  }

  void _close() {
    Navigator.pushReplacementNamed(
      context,
      Routes.login,
    );
  }
}
