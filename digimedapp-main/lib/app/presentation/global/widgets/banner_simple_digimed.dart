import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BannerSimpleDigimed extends StatelessWidget {
  final String textLeft;
  final IconData iconLeft;
  final IconData iconRight;
  final VoidCallback onClickIconRight;
  final TabController tabController;

  const BannerSimpleDigimed(
      {super.key,
      required this.textLeft,
      required this.iconLeft,
      required this.iconRight,
      required this.onClickIconRight,
      required this.tabController});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.30,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: ProsteBezierCurve(position: ClipPosition.bottom, list: [
              BezierCurveSection(
                start: Offset(0, (size.height * 0.25) * 0.75),
                top: Offset(size.width / 2, size.height * 0.25),
                end: Offset(size.width, (size.height * 0.25) * 0.75),
              ),
            ]),
            child: Container(
              height: size.height * 0.25,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    AppColors.beginGradient,
                    AppColors.endGradient
                  ])),
            ),
          ),
          Positioned(
            top: size.height * 0.07,
            right: 24,
            left: 40,
            height: size.height * 0.05,
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      iconLeft,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8,),
                    Text(
                      textLeft,
                      style: AppTextStyle.bannerWhiteContentTextStyle,
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                    onPressed: onClickIconRight,
                    icon: Icon(
                      iconRight,
                      size: 30,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.18,
            height: size.height * 0.10,
            right: 24,
            left: 24,
            child: CardDigimed(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: TabBar(
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor:
                      AppColors.DisableLabelTabBarBackgroundColor,
                  unselectedLabelStyle:
                      AppTextStyle.sub14W500NormalContentTextStyle,
                  labelColor: AppColors.contactColor,
                  labelStyle: AppTextStyle.semiBlue14W500TextStyle,
                  indicatorColor: AppColors.contactColor,
                  dividerColor: AppColors.separatorColor,
                  isScrollable: false,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  tabs: const [
                    Text("Presión arterial",
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                    Text("Frecuencia cardíaca",
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                    Text(
                      "Laboratorio",
                      softWrap: true,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
