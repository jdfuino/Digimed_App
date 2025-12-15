import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';

/// Dialog informativo sobre los triglicéridos
/// Muestra información educativa sobre los niveles de triglicéridos en sangre
class TriglyceridesInfoDialog extends StatelessWidget {
  const TriglyceridesInfoDialog({super.key});

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
                      "Triglicéridos",
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
                        "¿Qué son los triglicéridos?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Los triglicéridos son un tipo de grasa (lípido) que se encuentra en la sangre. Su cuerpo utiliza los triglicéridos para obtener energía. Tener niveles altos puede aumentar el riesgo de enfermedades cardíacas.",
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
                                  "Rango Normal",
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
                              "Para adultos en ayunas",
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
                              child: const Text(
                                "< 150 mg/dL",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.backgroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Rangos de referencia
                      const Text(
                        "Rangos de Referencia",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildRangeRow("Normal", "< 150 mg/dL", Colors.green,
                          Icons.check_circle),
                      _buildRangeRow("Límite alto", "150-199 mg/dL",
                          Colors.orange, Icons.warning),
                      _buildRangeRow("Alto", "200-499 mg/dL",
                          Colors.red, Icons.dangerous),
                      _buildRangeRow("Muy alto", "≥ 500 mg/dL",
                          Colors.red, Icons.dangerous),

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
}
