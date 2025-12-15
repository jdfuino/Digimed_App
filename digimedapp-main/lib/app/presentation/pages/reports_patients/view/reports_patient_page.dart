import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/recipe/recipe.dart';
import 'package:digimed/app/domain/models/report/report.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/icons/i_a_icons_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/banner_report.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/global/widgets/waiting_ia_dialog.dart';
import 'package:digimed/app/presentation/pages/historic/admin/controller/historic_patients_controller.dart';
import 'package:digimed/app/presentation/pages/reports_patients/controller/reports_patient_controller.dart';
import 'package:digimed/app/presentation/pages/reports_patients/controller/state/reports_patient_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ReportsPatientPage extends StatefulWidget {
  final Patients patients;
  final BuildContext fatherContext;

  const ReportsPatientPage(
      {super.key, required this.patients, required this.fatherContext});

  @override
  State<ReportsPatientPage> createState() => _ReportsPatientPageState();
}

class _ReportsPatientPageState extends State<ReportsPatientPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _title = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final reports = [];
    final recipe = [];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
      ReportsPatientController(ReportsPatientState(),
          accountRepository: Repositories.account,
          patients: widget.patients,
          sessionController: context.read())
        ..init(),
      child: MyScaffold(
        body: Builder(
          builder: (context) {
            final Size size = MediaQuery
                .of(context)
                .size;
            final controller = Provider.of<ReportsPatientController>(
              context,
              listen: true,
            );
            return SingleChildScrollView(
              child: Column(
                children: [
                  controller.state.dataDoctorState.when(
                      loading: (){
                        return const CircularProgressIndicator();
                      }, failed: (){
                    return const CircularProgressIndicator();
                  }, loaded: (doctor){
                    return BannerReport(
                        patientName: "Dr. ${doctor!.user.fullName}",
                        imageProvider: isValidUrl(
                            doctor.user.urlImageProfile)
                            ? NetworkImage(doctor.user.urlImageProfile!)
                            : Assets.images.logo.provider());
                  }),
                  Row(
                    children: [
                      Container(
                        width: size.width * 0.55,
                        margin: const EdgeInsets.only(left: 28),
                        decoration: BoxDecoration(
                          color: AppColors.textColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 0.5,
                              blurRadius: 4.0,
                              offset: const Offset(0.0, 4.0),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: AppTextStyle.normalTextStyle2,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (text) {
                            controller.searchOnChanged(text);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.textColor,
                            hintText: 'Búsqueda detallada',
                            hintStyle: AppTextStyle.hintTextStyle,
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 15.0, 20.0, 15.0),
                            prefixIcon: const Icon(
                              DigimedIcon.search,
                              size: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  width: 0.2,
                                  color: AppColors.backgroundSearchColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: size.width * 0.29,
                        child: _dropMenu(context),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  controller.state.reportFetchState.when(loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }, loaded: (reports) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(right: 24, left: 24),
                      child: CardDigimed(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TabBar(
                                controller: _tabController,
                                labelColor: AppColors.contactColor,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: AppColors.contactColor,
                                indicatorPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                indicator: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.contactColor,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                                tabs: const [
                                  Tab(text: 'Informes'),
                                  Tab(text: 'Récipe'),
                                ],
                              ),
                              Container(
                                height: size.height * 0.40,
                                margin:
                                const EdgeInsets.only(right: 8, left: 8),
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    // Pestaña 1: Informes médicos
                                    controller.state.reportFetchState.when(
                                      loading: () =>
                                      const Center(
                                          child: CircularProgressIndicator()),
                                      loaded: (list) {
                                        if (list.isNotEmpty) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: list.length,
                                            itemBuilder: (context, index) {
                                              final item = list[index];
                                              return _itemReport(item, context,
                                                  widget.fatherContext);
                                            },
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                                  "No hay reportes disponibles"));
                                        }
                                      },
                                    ),
                                    // Pestaña 2: Recetas médicas
                                    controller.state.recipeFetchState.when(
                                      loading: () =>
                                      const Center(
                                          child: CircularProgressIndicator()),
                                      loaded: (recipe) {
                                        // Asumo que 'list' para recetas es 'recipe'
                                        if (recipe.isNotEmpty) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: recipe.length,
                                            itemBuilder: (context, index) {
                                              final item = recipe[index];
                                              return _itemRecipe(item, context,
                                                  widget.fatherContext);
                                            },
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                                  "No hay recetas disponibles"));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _itemReport(Report item, BuildContext context,
      BuildContext fatherContext) {
    final Size size = MediaQuery
        .of(context)
        .size;
    final ReportsPatientController controller = Provider.of(context);
    return Card(
      color: AppColors.scaffoldBackgroundColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.only(right: 16, left: 24, bottom: 8, top: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: size.height * 0.1,
        // Ajusté la altura para que se vea mejor
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Fecha y título a la izquierda
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    convertDateCaracas(item.createdAt),
                    style: AppTextStyle.boldBlueTextStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: AppTextStyle.normal16W500ContentTextStyle.copyWith(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            // Botón "Descargar" a la derecha
            ElevatedButton.icon(
              onPressed: () async {
                showDialog(
                  context: fatherContext,
                  barrierDismissible: false,
                  // Impide que el usuario lo cierre tocando fuera
                  builder: (BuildContext dialogContext) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      // Impide que el usuario lo cierre con el botón de retroceso
                      child: const WaitingIaDialog(
                        icon: IAIcons
                            .vector, // Ícono de espera (puedes cambiarlo)
                      ),
                    );
                  },
                );
                try {
                  await controller.getReportBase64(reportID: item.reportID);
                } catch (e) {
                  showToast("Error al compartir el PDF: $e");
                } finally {
                  Navigator.pop(fatherContext);
                }
              },
              icon: const Icon(
                Icons.download, // Ícono de descarga
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                "Descargar",
                style: AppTextStyle.normalWhite15W600ContentTextStyle,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundSettingSaveColor,
                // Color verde como en la imagen
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemRecipe(Recipe item, BuildContext context,
      BuildContext fatherContext) {
    final Size size = MediaQuery
        .of(context)
        .size;
    final ReportsPatientController controller = Provider.of(context);
    return Card(
      color: AppColors.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.only(right: 16, left: 24, bottom: 8, top: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: size.height * 0.1,
        // Ajusté la altura para que se vea mejor
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Fecha y título a la izquierda
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    convertDateCaracas(item.createdAt),
                    style: AppTextStyle.boldBlueTextStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: AppTextStyle.normal16W500ContentTextStyle.copyWith(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            // Botón "Descargar" a la derecha
            ElevatedButton.icon(
              onPressed: () async {
                showDialog(
                  context: fatherContext,
                  barrierDismissible: false,
                  // Impide que el usuario lo cierre tocando fuera
                  builder: (BuildContext dialogContext) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      // Impide que el usuario lo cierre con el botón de retroceso
                      child: const WaitingIaDialog(
                        icon: IAIcons
                            .vector, // Ícono de espera (puedes cambiarlo)
                      ),
                    );
                  },
                );
                try {
                  await controller.getRecipeBase64(reportID: item.reportID);
                } catch (e) {
                  showToast("Error al compartir el PDF: $e");
                } finally {
                  Navigator.pop(fatherContext);
                }
              },
              icon: const Icon(
                Icons.download, // Ícono de descarga
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                "Descargar",
                style: AppTextStyle.normalWhite15W600ContentTextStyle,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundSettingSaveColor,
                // Color verde como en la imagen
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget auxiliar para mensajes de error (ajústalo según tu diseño)
  Widget errorMessage() {
    return const Center(child: Text("Error al cargar los reportes"));
  }

  Widget _dropMenu(BuildContext context) {
    final ReportsPatientController controller = Provider.of(context);
    return PopupMenuButton<String>(
      child: SizedBox(
        height: 55,
        child: Container(
          child: Card(
            shadowColor: Colors.grey.withOpacity(0.3),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: AppColors.textColor,
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.backgroundColor,
                ),
                Text(controller.valueSelected,
                    style: AppTextStyle.normalBlueTextStyle),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
          ),
        ),
      ),
      onSelected: (String value) {},
      itemBuilder: (BuildContext context) {
        return ["1 semana", "1 mes", "6 meses", "1 año"].map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: ListTile(
              title: Text(value),
              leading: Radio<String>(
                value: value,
                groupValue: controller.valueSelected,
                onChanged: (value) {},
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
