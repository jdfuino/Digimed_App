import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/treatments/views/treatment_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CardMyTreatment extends StatelessWidget {
  final List<Treatment> myTreatments;

  const CardMyTreatment({super.key, required this.myTreatments});

  @override
  Widget build(BuildContext context) {
    // Contar tratamientos por estado
    final inProgressCount = myTreatments.where((treatment) => treatment.isActive).length;
    final pendingCount = myTreatments.where((treatment) => treatment.isPending).length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
      child: CardDigimed(
        child: Container(
          margin: const EdgeInsets.only(right: 24, left: 24, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.backgroundColor,
                    radius: 5,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Mis tratamientos",
                    style: AppTextStyle.normalContentTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Contadores de tratamientos
              Row(
                children: [
                  // Tratamiento en progreso
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD), // Azul claro
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tratamiento en\nprogreso",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2563EB), // Azul
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                inProgressCount.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tratamiento por empezar
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7), // Amarillo claro
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tratamiento por\nEmpezar",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF59E0B), // Amarillo/naranja
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                pendingCount.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF59E0B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(),

              // Botón "Más información"
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const TreatmentPage(),
                        withNavBar: false,
                      );
                    },
                    child: const Text(
                      "Más información",
                      style: AppTextStyle.normalBlue16W500TextStyle,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const TreatmentPage(),
                        withNavBar: false,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.backgroundColor,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
