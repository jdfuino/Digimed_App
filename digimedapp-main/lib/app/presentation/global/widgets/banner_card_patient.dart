import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';

class BannerCardPatient extends StatelessWidget {
  final String textLeft;
  final IconData iconLeft;
  final IconData iconRight;
  final VoidCallback onClickIconRight;
  final String firstLine;
  final String secondLine;
  final String lastLine;
  final ImageProvider imageProvider;
  final Widget? widgetRight;
  final String datePatient;
  final String emailPatient;
  final String phonePatient;
  final String occupationPatient;
  double? weightPatient;
  double? heightPatient;

  BannerCardPatient(
      {super.key,
      required this.textLeft,
      required this.iconLeft,
      required this.iconRight,
      required this.onClickIconRight,
      required this.firstLine,
      required this.secondLine,
      required this.lastLine,
      required this.imageProvider,
      this.widgetRight,
      required this.datePatient,
      required this.emailPatient,
      required this.phonePatient,
      required this.occupationPatient,
      this.heightPatient,
      this.weightPatient});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print(size.height);
    return Container(
      height: 660,
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
              height: size.height * 0.30,
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
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      textLeft,
                      style: AppTextStyle.bannerWhiteContentTextStyle,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
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
            right: 24,
            left: 24,
            child: Container(
              height: 540,
              child: CardDigimed(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 16, bottom: 8),
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                          ),
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
                                backgroundImage: imageProvider,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Fecha de nacimiento",
                              style: AppTextStyle.subW500NormalContentTextStyle,
                            ),
                            Text(
                              convertDate(datePatient),
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.normal17ContentTextStyle,
                            ),
                            const Divider(),
                            const Text(
                              "Correo electrónico",
                              style: AppTextStyle.subW500NormalContentTextStyle,
                            ),
                            Text(
                              emailPatient,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.normal17ContentTextStyle,
                            ),
                            const Divider(),
                            const Text(
                              "Teléfono",
                              style: AppTextStyle.subW500NormalContentTextStyle,
                            ),
                            Text(
                              phonePatient,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.normal17ContentTextStyle,
                            ),
                            const Divider(),
                            const Text(
                              "Ocupación o profesión",
                              style: AppTextStyle.subW500NormalContentTextStyle,
                            ),
                            Text(
                              occupationPatient,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.normal17ContentTextStyle,
                            ),
                            const Divider(),
                            const Text(
                              "Peso",
                              style: AppTextStyle.subW500NormalContentTextStyle,
                            ),
                            Text(
                              weightPatient != null
                                  ? "${showNumber2(weightPatient!)} kg"
                                  : "0 kg",
                              softWrap: true,
                              maxLines: 1,
                              style: AppTextStyle.normal17ContentTextStyle,
                            ),
                            const Divider(),
                            const Text(
                              "Estatura",
                              style: AppTextStyle.subW500NormalContentTextStyle,
                            ),
                            Text(
                              heightPatient != null
                                  ? "${showNumber2(heightPatient!)} m"
                                  : "0 m",
                              softWrap: true,
                              maxLines: 1,
                              style: AppTextStyle.normal17ContentTextStyle,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
