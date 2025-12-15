import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BannerContract extends StatelessWidget {
  const BannerContract({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.88,
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
                      Icons.home_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8,),
                    Text(
                      "Inicio",
                      style: AppTextStyle.bannerWhiteContentTextStyle,
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.15,
            right: 24,
            left: 24,
            child: Container(
              height: size.height * 0.70,
              child: CardDigimed(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 8),
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Digimed",
                            style: AppTextStyle.titleBoldContentTextStyle,
                          ),
                          SizedBox(height: 8,),
                          Text(
                            "CONSENTIMIENTO INFORMADO",
                            style: AppTextStyle.titleBoldContentTextStyle,
                          ),
                          SizedBox(height: 8,),
                          Text(
                            contractDigimed,
                            textAlign: TextAlign.justify,
                            style: AppTextStyle.normal14W400ContentTextStyle,
                          )
                        ],
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
