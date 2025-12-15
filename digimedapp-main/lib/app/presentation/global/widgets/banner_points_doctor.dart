import 'package:digimed/app/domain/models/activity/activity.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BannerPointsDoctor extends StatelessWidget {
  final int totalScored;
  final List<Activity> myActivity;

  const BannerPointsDoctor(
      {super.key, required this.totalScored, required this.myActivity});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print("${size.width} x ${size.height}");
    return SizedBox(
      height: size.height * 0.95,
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
            left: 24,
            height: size.height * 0.08,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      DigimedIcon.points,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Mis puntos",
                      style: AppTextStyle.bannerWhiteContentTextStyle,
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      DigimedIcon.back,
                      size: 30,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.15,
            right: 24,
            left: 24,
            child: Container(
              height: size.height * 0.75,
              child: CardDigimed(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 8),
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            child: Container(
                          height: size.height * 0.30,
                          width: size.width * 0.80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.beginGradient,
                                    AppColors.endGradient
                                  ])),
                        )),
                        Positioned(
                            top: size.height * 0.20,
                            left: size.width * 0.16,
                            child: Assets.svgs.trofeoPoints.svg()),
                        Positioned(
                          top: size.height * 0.05,
                          left: size.width * 0.24,
                          child: Text(
                            "Total de puntos",
                            style: AppTextStyle.boldWhiteContentTextStyle,
                          ),
                        ),
                        Positioned(
                          top: size.height * 0.07,
                          left: getPositionScored(totalScored, context),
                          //size.width * 0.28,
                          child: Text(
                            totalScored.toString(),
                            style: AppTextStyle.titleTextTotalScored,
                          ),
                        ),
                        Positioned(
                            top: size.height * 0.17412,
                            right: size.width * 0.02544,
                            child: Assets.svgs.confeti1.svg()),
                        Positioned(
                            top: size.height * 0.1368,
                            left: size.width * 0.02544,
                            child: Assets.svgs.confeti1.svg()),
                        Positioned(
                            top: size.height * 0.0995,
                            left: size.width * 0.0746,
                            child: Assets.svgs.confeti2.svg()),
                        Positioned(
                            top: size.height * 0.0373,
                            left: size.width * 0.10178,
                            child: Assets.svgs.confeti3.svg()),
                        Positioned(
                            top: size.height * 0.0621,
                            right: size.width * 0.05089,
                            child: Assets.svgs.confeti5.svg()),
                        Positioned(
                            top: size.height * 0.1243,
                            right: size.width * 0.1017,
                            child: Assets.svgs.confeti4.svg()),
                        Positioned(
                            top: size.height * 0.44,
                            child: Container(
                              height: size.height * 0.25,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: myActivity.asMap().entries.map((e) {
                                    var item = e.value;
                                    return itemActivity(item, context);
                                  }).toList(),
                                ),
                              ),
                            ))
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget itemActivity(Activity activity, BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16,bottom: 8),
      width: size.width * 0.70,
      child: Row(
        children: [
          Container(
            color: AppColors.alteredColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16,),
                Container(
                  width: size.width * 0.60,
                  child: Text(
                    activity.name,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.normal14W600ContentTextStyle,
                  ),
                ),
                Text(
                  convertDate(activity.createdAt),
                  style: AppTextStyle.sub12W500NormalContentTextStyle,
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
              color: AppColors.alteredColor,
              child: Text(
            activity.doctorPoints.toString(),
            style: AppTextStyle.boldContentTextStyle,
          )),
        ],
      ),
    );
  }

  double getPositionScored(int scored, BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    switch (scored.toString().length) {
      case 1:
        return size.width * 0.37;
      case 2:
        return size.width * 0.280;
      case 3:
        return size.width * 0.25;
      default:
        return size.width * 0.20;
    }
  }
}
