import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_doctor/view/home_doctor_admin_page.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home/view/widget/home_doctor.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/views/InfoDoctorAdminPage.dart';
import 'package:digimed/app/presentation/pages/info_doctor/doctor/view/info_doctor.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeDoctorPage extends StatefulWidget {
  const HomeDoctorPage({super.key});

  @override
  State<HomeDoctorPage> createState() => _HomeDoctorPageState();
}

class _HomeDoctorPageState extends State<HomeDoctorPage> {
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
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(20.0),
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style3, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens(BuildContext context) {
    final SessionController sessionController = context.read();
    return [
      HomeDoctor(doctor: sessionController.doctor!,),
      InfoDoctor(doctor: sessionController.doctor!,
        close: _close,goToResumeHours: _goToResumeHours,)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(DigimedIcon.detail_user),
        activeColorPrimary: AppColors.contactColor,
        inactiveColorPrimary: AppColors.contentTextColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(DigimedIcon.user),
        activeColorPrimary: AppColors.contactColor,
        inactiveColorPrimary: AppColors.contentTextColor,
      ),
    ];
  }

  void _close(){
    Navigator.pushReplacementNamed(
      context,
      Routes.login,
    );
  }

  void _goToResumeHours(int id){
    popAndPushNewPageResumeHours(context, id);
  }
}
