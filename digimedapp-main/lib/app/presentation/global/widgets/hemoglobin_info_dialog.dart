import 'package:digimed/app/domain/constants/value_range.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';

/// Dialog informativo sobre la hemoglobina
/// Muestra información educativa sobre los niveles de hemoglobina en sangre
class HemoglobinInfoDialog extends StatelessWidget {
  const HemoglobinInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          // Hacer el diálogo más ancho usando un porcentaje del ancho de pantalla
          width: screenWidth * 0.85, // 85% del ancho de pantalla
          constraints: const BoxConstraints(
            maxWidth: 600, // Máximo 600px para pantallas grandes
            maxHeight: 650, // Altura máxima para evitar overflow
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con icono y título
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: Assets.svgs.iconSangre.svg(),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Hemoglobina",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ),
                  // Botón cerrar
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.backgroundColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Contenido scrolleable
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Descripción general
                      const Text(
                        "¿Qué es la hemoglobina?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "La hemoglobina es una proteína rica en hierro que transporta oxígeno desde los pulmones hacia todos los tejidos del cuerpo. Su nivel se mide en gramos por decilitro (g/dL).",
                        style: AppTextStyle.grey13W500ContentTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 12),

                      // Card con información del rango normal
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bloodtype,
                                    color: AppColors.backgroundColor, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Valores Normales",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.backgroundColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Rangos de referencia por género",
                              style: AppTextStyle.grey13W500ContentTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Hombres: ${ValueRange.hemoglobinMaleMin.toStringAsFixed(1)} - ${ValueRange.hemoglobinMaleMax.toStringAsFixed(1)} g/dL",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.backgroundColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Mujeres: ${ValueRange.hemoglobinFemaleMin.toStringAsFixed(1)} - ${ValueRange.hemoglobinFemaleMax.toStringAsFixed(1)} g/dL",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.backgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Rangos de referencia
                      const Text(
                        "Clasificación de Niveles",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildRangeRow("Normal (Hombres)", "${ValueRange.hemoglobinMaleMin.toStringAsFixed(1)}-${ValueRange.hemoglobinMaleMax.toStringAsFixed(1)} g/dL", Colors.green,
                          Icons.check_circle),
                      _buildRangeRow("Normal (Mujeres)", "${ValueRange.hemoglobinFemaleMin.toStringAsFixed(1)}-${ValueRange.hemoglobinFemaleMax.toStringAsFixed(1)} g/dL", Colors.green,
                          Icons.check_circle),
                      _buildRangeRow("Anemia Leve", "10.0-11.9 g/dL",
                          Colors.orange, Icons.warning),
                      _buildRangeRow("Anemia Moderada", "8.0-9.9 g/dL",
                          Colors.red, Icons.dangerous),
                      _buildRangeRow("Anemia Severa", "< 8.0 g/dL",
                          Colors.red.shade800, Icons.dangerous),
                      _buildRangeRow("Policitemia", "> 17.0 g/dL",
                          Colors.orange, Icons.warning),

                      const SizedBox(height: 20),

                      // Botón de cerrar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.backgroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Entendido",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  /// Construye una fila para mostrar rangos de referencia
  Widget _buildRangeRow(
      String category, String range, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              range,
              style: AppTextStyle.grey13W500ContentTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye una tarjeta con información de síntomas
  Widget _buildSymptomCard(String title, String symptoms, String causes, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Síntomas: $symptoms",
            style: AppTextStyle.grey13W500ContentTextStyle,
          ),
          const SizedBox(height: 4),
          Text(
            "Causas: $causes",
            style: AppTextStyle.grey13W500ContentTextStyle,
          ),
        ],
      ),
    );
  }
}
