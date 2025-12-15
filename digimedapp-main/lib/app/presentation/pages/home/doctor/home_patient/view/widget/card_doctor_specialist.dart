import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_specialist/view/form_new_specialist.dart';
import 'package:digimed/app/presentation/pages/home/admin/home/views/widget/list_item_doctor_specialist.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardDoctorSpecialist extends StatelessWidget {
  const CardDoctorSpecialist({super.key});

  @override
  Widget build(BuildContext context) {
    final HomePatientAdminController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 24, left: 24, bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 4, left: 10),
                  child: Text(
                    "Agregar Medicos Especialistas",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.normal16W500ContentTextStyle,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline_sharp,
                  color: AppColors.backgroundColor,
                  size: 32,
                ),
                onPressed: () async {
                  var result = await showDialog(
                      context: context,
                      builder: (context) => FormNewSpecialist(
                            patientId: controller.patients.patientID,
                          ));

                  if (result != null && result) {
                    controller.loadListDoctorsSpecialist(
                        associateDoctorSpecialist:
                            const AssociateDoctorSpecialist.loading());
                  }
                },
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: const Divider(),
          ),
          Container(
            height: 290,
            margin: const EdgeInsets.only(left: 2, right: 2),
            width: double.infinity,
            child: CardDigimed(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: AppTextStyle.normalTextStyle2,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (text) {
                        controller.searchOnChanged(text);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.backgroundSearchColor,
                        hintText: 'Búsqueda detallada',
                        hintStyle: AppTextStyle.hintTextStyle,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: const Icon(
                          DigimedIcon.search,
                          size: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              width: 0.2,
                              color: AppColors.backgroundSearchColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8, left: 8),
                      child: Row(
                        children: [
                          Text(
                            "Medicos Especialistas",
                            style: AppTextStyle.normalContentTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(right: 2, left: 2, top: 8),
                      child: controller.state.associateDoctorSpecialist.when(
                        loading: () {
                          const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        failed: (failure) {
                          return const Center(
                            child:
                                Text("No hay medicos especialistas asignados"),
                          );
                        },
                        loaded: (list) {
                          return list.isNotEmpty
                              ? ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    final item = list[index];
                                    return ListTile(
                                      subtitle: ItemsListEspecialist(
                                        index: index,
                                        doctorSpecialists: list[index],
                                      ),
                                      leading: CircleAvatar(
                                        radius: 20.0,
                                        child: Text(
                                          list[index].fullName.substring(0, 2),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  child: const Center(
                                    child: Text(
                                        "No hay medicos especialistas asignados"),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
