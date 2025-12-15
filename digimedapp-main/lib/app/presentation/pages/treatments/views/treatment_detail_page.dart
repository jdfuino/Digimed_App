import 'package:digimed/app/domain/constants/treatment_status.dart';
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';

class TreatmentDetailPage extends StatefulWidget {
  final User user;
  final Treatment treatment;
  final Function(Treatment treatment)? onStartTreatment;
  final VoidCallback? onCompleteTreatment;
  final VoidCallback? onPauseResumeTreatment;
  final Function(String note, TreatmentStatus status)? onSaveTreatment;

  const TreatmentDetailPage({
    super.key,
    required this.treatment,
    this.onStartTreatment,
    this.onCompleteTreatment,
    this.onPauseResumeTreatment,
    this.onSaveTreatment,
    required this.user,
  });

  @override
  State<TreatmentDetailPage> createState() => _TreatmentDetailPageState();
}

class _TreatmentDetailPageState extends State<TreatmentDetailPage> {
  late TextEditingController _noteController;
  late TreatmentStatus _selectedStatus;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.treatment.note ?? '');
    _selectedStatus = widget.treatment.status;

    _noteController.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final noteChanged = _noteController.text != (widget.treatment.note ?? '');
    final statusChanged = _selectedStatus != widget.treatment.status;

    setState(() {
      _hasChanges = noteChanged || statusChanged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        children: [
          // Header Banner
          BannerDigimed(
              textLeft: "Tratamiento",
              iconLeft: DigimedIcon.detail_user,
              iconRight: DigimedIcon.back,
              onClickIconRight: () {
                Navigator.of(context).pop();
              },
              firstLine: "Paciente",
              secondLine: widget.user.fullName,
              lastLine:
                  "${widget.user.identificationType} ${widget.user.identificationNumber}",
              imageProvider: isValidUrl(widget.user.urlImageProfile)
                  ? NetworkImage(widget.user.urlImageProfile!)
                  : Assets.images.logo.provider()),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Treatment Information Card
                  _buildTreatmentInfoCard(),

                  const SizedBox(height: 16),

                  // Medications Card
                  _buildMedicationsCard(),

                  const SizedBox(height: 16),

                  _buildPrimaryActionButton(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentInfoCard() {
    return CardDigimed(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.backgroundColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Información del Tratamiento',
                  style: AppTextStyle.normal16W500ContentTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Nombre:', widget.treatment.name),
            const SizedBox(height: 8),
            _buildInfoRow('Duración:', widget.treatment.formattedDuration),
            const SizedBox(height: 8),
            _buildInfoRow(
                'Recetada el:', _formatDate(widget.treatment.createdAt)),
            const SizedBox(height: 8),
            _buildInfoRow('Estado:', _getStatusText(widget.treatment.status)),
            if (widget.treatment.startedOn != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                  'Fecha de Inicio:', _formatDate(widget.treatment.startedOn!)),
            ],
            if (widget.treatment.finishedOn != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow('Fecha de Completado:',
                  _formatDate(widget.treatment.finishedOn!)),
            ],
            if (widget.treatment.note != null &&
                widget.treatment.note!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Notas:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.backgroundColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.treatment.note!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: AppTextStyle.normalBlue14W600TextStyle,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.normal14W400ContentTextStyle,
          ),
        ),
      ],
    );
  }

  String _getStatusText(TreatmentStatus status) {
    logger.i("Getting status text for $status");
    switch (status) {
      case TreatmentStatus.pendingToStart:
        return 'Pendiente de Iniciar';
      case TreatmentStatus.inProgress:
        return 'En Progreso';
      case TreatmentStatus.completed:
        return 'Completado';
      case TreatmentStatus.paused:
        return 'Pausado';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildMedicationsCard() {
    return CardDigimed(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.medication,
                  color: AppColors.backgroundColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Medicamentos',
                  style: AppTextStyle.normal16W500ContentTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Grid layout for medications
            ...widget.treatment.medications.asMap().entries.map((entry) {
              final index = entry.key;
              final medication = entry.value;
              final isEven = index % 2 == 0;

              if (isEven && index + 1 < widget.treatment.medications.length) {
                // Show two medications in a row
                final nextMedication = widget.treatment.medications[index + 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(child: _buildMedicationItem(medication)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMedicationItem(nextMedication)),
                    ],
                  ),
                );
              } else if (isEven) {
                // Last medication, show full width
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMedicationItem(medication),
                );
              } else {
                // Skip odd indexed items as they're handled in the previous even iteration
                return const SizedBox.shrink();
              }
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationItem(medication) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backGroundColorButton,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medication.name,
            style: AppTextStyle.normalBlue14W600TextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Dosis: ${medication.dose} ${medication.doseUnit}',
            style: AppTextStyle.hintTextStyle,
          ),
          Text(
            'Frecuencia: ${_getFrequencyText(medication.frequency)}',
            style: AppTextStyle.hintTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionButton(BuildContext context) {
    if (widget.treatment.isPending) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            if (widget.onStartTreatment != null) {
              logger.i("Starting treatment ${widget.treatment.id}");
              await widget.onStartTreatment!(widget.treatment);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.backgroundColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Iniciar Tratamiento',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String _getFrequencyText(int frequency) {
    switch (frequency) {
      case 4:
        return 'Cada 4 horas (6 veces al día)';
      case 6:
        return 'Cada 6 horas (4 veces al día)';
      case 8:
        return 'Cada 8 horas (3 veces al día)';
      case 12:
        return 'Cada 12 horas (2 veces al día)';
      default:
        return 'Según indicación médica';
    }
  }
}
