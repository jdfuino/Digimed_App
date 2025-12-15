import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/icons/tools_dimed_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/treatments/controller/state/treatment_state.dart';
import 'package:digimed/app/presentation/pages/treatments/controller/treatment_controller.dart';
import 'package:digimed/app/presentation/pages/treatments/views/treatment_detail_page.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TreatmentPage extends StatelessWidget {
  const TreatmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController sessionController = context.read();
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
        create: (_) => TreatmentController(
              TreatmentState(
                  treatmentsFetchState: TreatmentsFetchState.loaded(
                      sessionController.patients!.treatments)),
              accountRepository: Repositories.account,
              sessionController: sessionController,
            ),
        child: MyScaffold(body: Builder(builder: (context) {
          final controller = Provider.of<TreatmentController>(
            context,
            listen: true,
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Custom App Bar (similar structure) =====
              BannerDigimed(
                  textLeft: "Tratamiento",
                  iconLeft: DigimedIcon.detail_user,
                  iconRight: DigimedIcon.back,
                  onClickIconRight: () {
                    Navigator.of(context).pop();
                  },
                  firstLine: "Paciente",
                  secondLine:
                      controller.sessionController.patients!.user.fullName,
                  lastLine:
                      "${sessionController.state!.identificationType} ${sessionController.state!.identificationNumber}",
                  imageProvider: isValidUrl(
                          sessionController.patients!.user.urlImageProfile)
                      ? NetworkImage(
                          sessionController.patients!.user.urlImageProfile!)
                      : Assets.images.logo.provider()),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 24, left: 24, top: 16),
                child: CardDigimed(
                    child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(right: 8, left: 24, bottom: 8),
                      child: Row(
                        children: [
                          const Text(
                            "Listado de tratamientos",
                            style: AppTextStyle.normal16W500ContentTextStyle,
                          ),
                          const Spacer(),
                          _dropMenu(context)
                        ],
                      ),
                    ),
                    // Aseguramos que el ListView tenga un tamaño definido
                    Container(
                      height: size.height * 0.5,
                      margin: const EdgeInsets.only(right: 8, left: 8),
                      child: controller.state.treatmentsFetchState.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        loaded: (data) {
                          if (data.isEmpty) {
                            return RefreshIndicator(
                              onRefresh: () => controller.onRefresh(),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 200,
                                  child: _buildEmptyState(),
                                ),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () => controller.onRefresh(),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final treatment = data[index];
                                return _buildTreatmentCard(treatment, context,
                                    controller.sessionController.state!);
                              },
                            ),
                          );
                        },
                        failed: (failure) {
                          return Center(child: Text('Error: $failure'));
                        },
                      ),
                    ),
                  ],
                )),
              )
            ],
          );
        })));
  }

  Widget _buildTreatmentCard(
      Treatment treatment, BuildContext context, User user) {
    final controller = Provider.of<TreatmentController>(
      context,
      listen: true,
    );
    return GestureDetector(
      onTap: () {
        //navegar a detalle del tratamiento
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TreatmentDetailPage(
                      treatment: treatment,
                      user: user,
                      onStartTreatment: (treatment) {
                        controller.initTreatment(treatment);
                      },
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backGroundColorButton,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          treatment.name,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.normalBlue14W600TextStyle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(treatment.status.value),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTreatmentDescription(treatment),
                    style: AppTextStyle.hintTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    logger.i("Building status chip for status: $status");

    switch (status) {
      case 'PROGRESS':
        backgroundColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        displayText = 'En Progreso';
        break;
      case 'PENDING_INITIATION':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        displayText = 'Por Empezar';
        break;
      case 'FINISHED':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        displayText = 'Finalizado';
        break;
      case 'PASUSED':
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        displayText = 'Pausado';
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        displayText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  String _getTreatmentDescription(Treatment treatment) {
    if (treatment.medications.isEmpty) {
      return 'Sin medicamentos asignados';
    }

    final mainMedication = treatment.medications.first;
    final frequency = _getFrequencyText(mainMedication.frequency);

    return '$frequency (${treatment.medications.length == 1 ? 'medicamento único' : '${treatment.medications.length} medicamentos'})';
  }

  String _getFrequencyText(int frequency) {
    switch (frequency) {
      case 4:
        return '6 veces al día';
      case 6:
        return '4 veces al día';
      case 8:
        return '3 veces al día';
      case 12:
        return '2 veces al día';
      default:
        return 'Según indicación médica';
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No tiene tratamientos disponibles'),
    );
  }

  Widget _dropMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        ToolsDimed.icon_tools,
        color: AppColors.backgroundColor,
        size: 22,
      ),
      onSelected: (String value) async {},
      itemBuilder: (BuildContext context) {
        return [
          // const PopupMenuItem<String>(
          //   value: "Crear_nota",
          //   child: Row(
          //     children: [
          //       Icon(
          //         IAIcons.vector,
          //         color: AppColors.backgroundColor,
          //         size: 25,
          //       ),
          //       SizedBox(width: 8),
          //       Text('Crear reporte con IA'),
          //     ],
          //   ),
          // ),
        ];
      },
    );
  }
}
