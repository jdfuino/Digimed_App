import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BannerReport extends StatelessWidget {

  final String patientName;
  final ImageProvider imageProvider;

  const BannerReport({super.key, required this.patientName, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.33,
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
            top: size.height * 0.05,
            right: 24,
            left: 40,
            height: size.height * 0.08,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      DigimedIcon.detail_user,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8,),
                    Text(
                      "Informes y recipes",
                      style: AppTextStyle.bannerWhiteContentTextStyle,
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.15,
            height: size.height * 0.17,
            right: 24,
            left: 24,
            child: CardDigimed(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16,),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$patientName,",
                          style: AppTextStyle.boldContentTextStyle,
                        ),
                        SizedBox(
                          width: size.width * 0.45,
                          child: const Text(
                            "Recuerda seguir tu tratamiento tal y como se indica para lograr los objetivos planteados",
                            style: AppTextStyle.normalContentTextStyle,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: AppColors.backgroundColor,
                      radius: size.width * 0.12,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: (size.width * 0.12) - 3,
                        child: CircleAvatar(
                          radius: (size.width * 0.12) - 6,
                          backgroundImage:
                          imageProvider,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16,),
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