import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/card_digimed.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home/controller/super_admin_home_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home/view/widget/item_list_medical_center.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListItemMedicalCenter extends StatefulWidget {
  const ListItemMedicalCenter({Key? key}) : super(key: key);

  @override
  State<ListItemMedicalCenter> createState() => _ListItemMedicalCenterState();
}

class _ListItemMedicalCenterState extends State<ListItemMedicalCenter> {
  @override
  Widget build(BuildContext context) {
    final SuperAdminHomeController controller = context.watch();

    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 32),
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
                        width: 0.2, color: AppColors.backgroundSearchColor),
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
                      "Centros",
                      style: AppTextStyle.normalContentTextStyle,
                    ),
                    Spacer(),
                    Text(
                      "Núm. Medicos",
                      style: AppTextStyle.normalContentTextStyle,
                    )
                  ],
                ),
              ),
              Expanded(
                  child: controller.state.medicalCenterState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                failed: (failure) {
                  return errorMessage();
                },
                loaded: (list) {
                  return list.isNotEmpty
                      ? ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return ItemListMedicalCenter(
                              medicalCenter: item,
                              index: index,
                            );
                          },
                        )
                      : Container(
                          child: errorMessage(),
                        );
                },
              ))
            ],
          ),
        ),
      ),
    ));
  }
}
