import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_doctor/controller/home_doctor_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_doctor/view/widget/list_item_patients_super_admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPatientSuperAdmin extends StatelessWidget {
  const ListPatientSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeDoctorSuperAdminController controller = context.watch();
    final Size size = MediaQuery.of(context).size;
    return Expanded(
        child: Container(
          margin: const EdgeInsets.only(
              left: 24, right: 24, top: 8, bottom: 32),
          width: double.infinity,
          child: CardDigimed(
            child: Container(
              padding: const EdgeInsets.all(16) ,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
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
                      prefixIcon: const Icon(DigimedIcon.search,
                      size: 14,),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            width: 0.2,
                            color: AppColors.backgroundSearchColor
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    child: Row(
                      children: [
                        Text("Paciente" ,style: AppTextStyle.normalContentTextStyle,),
                        Spacer(),
                        Text("Estado clínico", style: AppTextStyle.normalContentTextStyle,)
                      ],
                    ),
                  ),
                  Expanded(child: controller.state.associatePatientState.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    failed: () => Container(),
                    loaded: (list) {
                      if(list != null && list.isNotEmpty){
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return ListItemPatientSuperAdmin(itemPatient: item, index: index,);
                          },
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 8),
                        child: Column(
                          children: [
                            Assets.svgs.noInfo.svg(),
                            Text(
                              "¡No hay registros disponibles!",
                              style: AppTextStyle.normalContentTextStyle,
                            )
                            ,SizedBox(height: 16,)
                          ],
                        ),
                      );
                    },
                  )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
