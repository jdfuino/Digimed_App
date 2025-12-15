import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.isBottom,
    this.resizeToAvoidBottomInset,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool? isBottom;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? _appBarDefault(),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        bottom: isBottom ?? false,
        child: body,
      ),
    );
  }

  PreferredSizeWidget _appBarDefault() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: AppColors.beginGradient,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.beginGradient,
            statusBarIconBrightness: Brightness.light,
          ),
        ));
  }
}
