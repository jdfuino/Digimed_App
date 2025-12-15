import 'package:digimed/app/domain/constants/value_range.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:flutter/material.dart';
import 'package:digimed/app/generated/assets.gen.dart';

/// Dialog informativo sobre la presión arterial
/// Muestra información educativa sobre presión sistólica y diastólica
class BloodPressureInfoDialog extends StatelessWidget {
  const BloodPressureInfoDialog({super.key});

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
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Assets.svgs.iconPrsion.svg(),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Presión Arterial",
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
                        "¿Qué es la presión arterial?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "La presión arterial es la fuerza que ejerce la sangre contra las paredes de las arterias cuando el corazón bombea sangre.",
                        style: AppTextStyle.grey13W500ContentTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 20),

                      // Card con información de Presión Sistólica
                      _buildPressureCard(
                        title: "Presión Sistólica",
                        description: "Es la presión máxima cuando el corazón se contrae y bombea sangre.",
                        range: "${ValueRange.systolicMin.round()}-${ValueRange.systolicMax.round()} mmHg",
                        isSystemic: true,
                      ),

                      const SizedBox(height: 16),

                      // Card con información de Presión Diastólica
                      _buildPressureCard(
                        title: "Presión Diastólica",
                        description: "Es la presión mínima cuando el corazón se relaja entre latidos.",
                        range: "${ValueRange.diastolicMin.round()}-${ValueRange.diastolicMax.round()} mmHg",
                        isSystemic: false,
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

                      _buildRangeRow("Normal", "< 120/80 mmHg", Colors.green,
                          Icons.check_circle),
                      _buildRangeRow("Elevada", "120-129/< 80 mmHg",
                          Colors.orange, Icons.warning),
                      _buildRangeRow("Hipertensión Etapa 1", "130-139/80-89 mmHg",
                          Colors.orange, Icons.warning),
                      _buildRangeRow("Hipertensión Etapa 2", "≥ 140/90 mmHg",
                          Colors.red, Icons.dangerous),
                      _buildRangeRow("Crisis Hipertensiva", "> 180/120 mmHg",
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

  /// Construye una card para mostrar información de presión
  Widget _buildPressureCard({
    required String title,
    required String description,
    required String range,
    required bool isSystemic,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.backgroundColor.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Indicador visual (línea continua o punteada)
              if (isSystemic)
                Container(
                  width: 24,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                )
              else
                Row(
                  children: List.generate(3, (index) => Container(
                    margin: EdgeInsets.only(right: index < 2 ? 3 : 0),
                    width: 6,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  )),
                ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.backgroundColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
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
            child: Text(
              range,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
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
