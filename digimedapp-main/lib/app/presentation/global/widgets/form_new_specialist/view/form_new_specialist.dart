import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_specialist/controller/form_new_specialist_controller.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_specialist/controller/state/form_new_specialist_state.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_specialist/view/widget/item_list_specialist_doctor.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormNewSpecialist extends StatelessWidget {
  final int patientId;
  final int? specialtyID;
  final int? medicalCenterID;

  const FormNewSpecialist({
    super.key,
    required this.patientId,
    this.specialtyID,
    this.medicalCenterID,
  });

  @override
  Widget build(BuildContext context) {
    BuildContext fatherContext = context;
    return ChangeNotifierProvider(
      create: (_) => FormNewSpecialistController(
        const FormNewSpecialistbState(),
        patientId: patientId,
        accountRepository: Repositories.account,
        sessionController: context.read(),
        medicalCenterID: medicalCenterID,
        specialtyID: specialtyID,
      )..init(),
      child: Builder(builder: (contextF) {
        final controller = Provider.of<FormNewSpecialistController>(contextF);
        return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                    top: 12, right: 14, left: 14, bottom: 32),
                decoration: BoxDecoration(color: Colors.white),
                child: Container(
                  margin: const EdgeInsets.only(right: 14, left: 14),
                  child: Form(
                    child: Builder(builder: (formContext) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.backgroundColor,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: AppColors.scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            DigimedIcon.add_doctor,
                            color: AppColors.backgroundSettingSaveColor,
                            size: 80,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Agregar Doctor Especialista",
                            style: AppTextStyle.boldContentTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          _dropMenuSpecialities(contextF),
                          SizedBox(
                            height: 25,
                          ),
                          Visibility(
                            visible: controller.showDoctors,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  style: AppTextStyle.normalTextStyle2,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onChanged: (text) {
                                    controller.searchOnChanged(text);
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.backgroundSearchColor,
                                    hintText: 'Búsqueda detallada',
                                    hintStyle: AppTextStyle.hintTextStyle,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    prefixIcon: const Icon(
                                      DigimedIcon.search,
                                      size: 14,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          width: 0.2,
                                          color:
                                              AppColors.backgroundSearchColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: 250,
                                  height: 150,
                                  margin: const EdgeInsets.only(
                                      right: 2, left: 2, top: 8),
                                  child:
                                      controller.state.associateSpecialist.when(
                                    loading: () {
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    failed: (failure) {
                                      return const Center(
                                        child: Text(
                                            "No hay medicos especialistas asignados"),
                                      );
                                    },
                                    loaded: (list) {
                                      return list.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: list.length,
                                              itemBuilder: (context, index) {
                                                final item = list[index];
                                                return ListTile(
                                                  subtitle:
                                                      ItemsListEspecialistDoctor(
                                                    index: index,
                                                    doctorSpecialists:
                                                        list[index],
                                                        fatherContext: fatherContext,
                                                  ),
                                                  leading: CircleAvatar(
                                                    radius: 20.0,
                                                    child: Text(
                                                      list[index]
                                                          .fullName
                                                          .substring(0, 2),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              child: const Center(
                                                child: Text(
                                                  "No hay medicos especialistas asignados",
                                                  style: AppTextStyle
                                                      .boldBlueTextStyle,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ));
      }),
    );
  }

}

Widget _dropMenuSpecialities(
  BuildContext context,
) {
  final controller = Provider.of<FormNewSpecialistController>(context);

  return controller.state.medicalSpecialtyState.when(loading: () {
    return const CircularProgressIndicator();
  }, failed: (_) {
    return const CircularProgressIndicator();
  }, loaded: (list) {
    return DropdownButtonFormField<String>(
      hint: const Text("Selecciona especialidad"),
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.backgroundColor),
        ),
        filled: true,
        fillColor: AppColors.backgroundInput,
      ),
      items: list
          .map((specialty) => DropdownMenuItem<String>(
                value: specialty.specialtyID.toString(),
                child: Text(specialty.name),
              ))
          .toList(),
      onChanged: (String? value) {
        if (value != null) {
          controller.showDoctors = true;
          controller.getListDoctor(
            idSpecialist: int.tryParse(value ?? "0") ?? 1,
            associateSpecialist: const AssociateSpecialist.loading(),
          );
        } else {
          controller.showDoctors = false;
        }
      },
    );
  });
}
