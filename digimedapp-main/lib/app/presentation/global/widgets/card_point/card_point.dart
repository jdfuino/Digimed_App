import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:flutter/material.dart';

class CardPoint extends StatelessWidget {
  final int point;
  final VoidCallback open;
  const CardPoint({super.key, required this.point,
    required this.open});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24),
      child: GestureDetector(
        onTap: open,
        child: CardDigimed(
          child: Padding(
            padding: const EdgeInsets.only(right: 32,top: 8,left: 8,bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: open,
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0 ,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.all(5),
                      backgroundColor: AppColors.backgroundColor,
                    ),
                    child: const Icon(DigimedIcon.points,
                        color: Colors.white, size: 20,),
                  ),
                ),
                Spacer(),
                Text("Puntos de salud", style: AppTextStyle.semiBold17W500ContentTextStyle,),
                Spacer(),
                Text("$point",style: AppTextStyle.bold20ContentTextStyle,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
