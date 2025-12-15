import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BannerLogo extends StatelessWidget {
  const BannerLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.30,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper:
            ProsteBezierCurve(position: ClipPosition.bottom, list: [
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
            top: size.height * 0.08,
            height: size.height * 0.13,
            right: 24,
            left: 24,
            child: SvgPicture.asset(Assets.svgs.logo.path,
            fit: BoxFit.scaleDown,
            width: 70,
            height: 70,),
          )
        ],
      ),
    );
  }
}
