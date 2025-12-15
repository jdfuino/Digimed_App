import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphDiastolic extends StatelessWidget {
  const GraphDiastolic({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoricPatientsController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container();
    // return Container(
    //   margin: const EdgeInsets.only(right: 20, left: 8, bottom: 16),
    //   height: 200,
    //   child: Stack(
    //     children: [
    //       BarChart(
    //         BarChartData(
    //           barTouchData: BarTouchData(
    //             touchTooltipData: BarTouchTooltipData(
    //               // tooltipBgColor: AppColors.backgroundColor,
    //               getTooltipItem: (group, groupIndex, rod, rodIndex) {
    //                 // para mostrar solo 2 digitos despues de la coma.
    //                 String formattedValue = rod.toY.toStringAsFixed(2);
    //                 return BarTooltipItem(
    //                   formattedValue,
    //                   const TextStyle(color: AppColors.scaffoldBackgroundColor),
    //                 );
    //               },
    //             ),
    //           ),
    //           minY: 0,
    //           maxY: 150,
    //           gridData: const FlGridData(
    //             show: true,
    //             drawVerticalLine: false,
    //             drawHorizontalLine: true,
    //             horizontalInterval: 50,
    //           ),
    //           titlesData: FlTitlesData(
    //             show: true,
    //             rightTitles: const AxisTitles(
    //               sideTitles: SideTitles(showTitles: false),
    //             ),
    //             topTitles: const AxisTitles(
    //               sideTitles: SideTitles(showTitles: false),
    //             ),
    //             bottomTitles: AxisTitles(
    //               sideTitles: SideTitles(
    //                 showTitles: true,
    //                 getTitlesWidget: (values, meta) {
    //                   int index = values.toInt();
    //                   String textX = "";
    //                   switch (rangeGraph[controller.valueSelectedSystolic]) {
    //                     case "WEEK":
    //                       textX = getDay(index);
    //                       break;
    //                     case "MONTH":
    //                       textX = getWeek(
    //                           controller.listXSistolica[index].x.toInt());
    //                       break;
    //                     case "HALF_YEAR":
    //                       textX = obtenerAbreviaturaMes(
    //                           controller.listXSistolica[index].x.toInt());
    //                       break;
    //                     case "YEAR":
    //                       textX = obtenerAbreviaturaMes(
    //                           controller.listXSistolica[index].x.toInt());
    //                       break;
    //                     default:
    //                   }
    //                   return Container();
    //                   // SideTitleWidget(
    //                   //   axisSide: meta.axisSide,
    //                   //   child: Text(textX,
    //                   //       style:
    //                   //           TextStyle(color: Colors.black, fontSize: 10)),
    //                   // );
    //                 },
    //               ),
    //             ),
    //             leftTitles: AxisTitles(
    //               sideTitles: SideTitles(
    //                 showTitles: true,
    //                 interval: 50,
    //                 reservedSize: 32,
    //                 getTitlesWidget: (values, meta) {
    //                   TextStyle style = AppTextStyle.sub9BoldContentTextStyle;
    //                   Widget text = Text(
    //                     values.round().toString(),
    //                     style: style,
    //                   );
    //                   return Container();
    //                   // SideTitleWidget(
    //                   //   axisSide: meta.axisSide,
    //                   //   child: text,
    //                   // );
    //                 },
    //               ),
    //             ),
    //           ),
    //           borderData: FlBorderData(
    //             show: false,
    //           ),
    //           barGroups: controller.listXDiastolic.map((yValue) {
    //             var x = searchPositionInTheList(
    //                 yValue.x, controller.listXDiastolic);
    //
    //             double barWidth =
    //                 (rangeGraph[controller.valueSelectedSystolic] == "YEAR")
    //                     ? 20.0
    //                     : 25.0;
    //
    //             return BarChartGroupData(
    //               x: x,
    //               barRods: [
    //                 BarChartRodData(
    //                   fromY: 0,
    //                   toY: yValue.y,
    //                   width: barWidth,
    //                   color: AppColors.backgroundColor.withOpacity(0.7),
    //                   borderRadius: BorderRadius.circular(2),
    //                   borderSide: const BorderSide(
    //                     color: AppColors.backgroundColor,
    //                     width: 2.0,
    //                   ),
    //                 ),
    //               ],
    //             );
    //           }).toList(),
    //         ),
    //       ),
    //       Stack(
    //         children: [
    //           Container(
    //             width: double.infinity,
    //             height: 30,
    //             margin: EdgeInsets.only(top: 77, left: 31),
    //             color: Colors.green.withOpacity(0.5),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
