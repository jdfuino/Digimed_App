import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BannerDigimed extends StatelessWidget {
  const BannerDigimed({Key? key,
  required this.textLeft,
  required this.iconLeft,
  required this.iconRight,
  required this.onClickIconRight,
  required this.firstLine,
  required this.secondLine,
  required this.lastLine,
  required this.imageProvider,
  this.widgetRight}) : super(key: key);

  final String textLeft;
  final IconData iconLeft;
  final IconData iconRight;
  final VoidCallback onClickIconRight;
  final String firstLine;
  final String secondLine;
  final String lastLine;
  final ImageProvider imageProvider;
  final Widget? widgetRight;


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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                widgetRight != null
                ? widgetRight!
                : IconButton(
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
            child: CardDigimed(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 16,),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          firstLine,
                          style: AppTextStyle.normalContentTextStyle,
                        ),
                        Container(
                          width: size.width * 0.45,
                          child: Text(
                            secondLine,
                            style: AppTextStyle.boldContentTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: size.width * 0.45,
                          child: Text(
                            lastLine,
                            style: AppTextStyle.normalContentTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
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
                    SizedBox(width: 16,),
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
