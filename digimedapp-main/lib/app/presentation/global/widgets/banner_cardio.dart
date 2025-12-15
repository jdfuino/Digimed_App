import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BannerCardio extends StatelessWidget {
  final IconData iconRight;
  final VoidCallback onClickIconRight;

  const BannerCardio(
      {super.key, required this.iconRight, required this.onClickIconRight});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.35,
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
            top: size.height * 0.05,
            right: 24,
            left: 40,
            height: size.height * 0.08,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      DigimedIcon.status,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Estado clínico",
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
              top: size.height * 0.15,
              height: size.height * 0.17,
              right: 24,
              left: 24,
              child: SvgPicture.asset(
                Assets.svgs.testDigimed.path,
              ))
        ],
      ),
    );
  }
}
