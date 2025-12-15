import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/pages/register/doctor/view/widget/step_indicator.dart';
import 'package:digimed/app/presentation/pages/register/patient/controller/register_patient_controller.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StepProfileImagePatient extends StatelessWidget {
  const StepProfileImagePatient({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterPatientController controller = Provider.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 24, left: 24),
      child: Column(
        children: [
          StepIndicator(
            step: 8,
            lastStep: 10,
            onTab: () async {
              controller.step = 7;
              await controller.changeState();
            },
          ),
          const SizedBox(
            height: 32,
          ),
          const Text(
            "Personaliza tu pefil",
            style: AppTextStyle.normal17ContentTextStyle,
          ),
          const SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () async {
              controller.fileTemp =
                  await Repositories.multimedia.getImage(ImageSource.camera);
              if (controller.fileTemp != null) {
                controller.notifyListeners();
              }
            },
            child: CircleAvatar(
              backgroundColor: AppColors.backgroundColor,
              radius: size.width * 0.25,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: (size.width * 0.25) - 5,
                child: controller.fileTemp != null
                    ? CircleAvatar(
                        backgroundImage: Image.file(
                          controller.fileTemp!,
                          fit: BoxFit.cover,
                        ).image,
                        radius: (size.width * 0.25) - 5,
                      )
                    : controller.patientsTemp!.user.urlImageProfile != null
                        ? CircleAvatar(
                            backgroundImage: isValidUrl(controller
                                    .patientsTemp!.user.urlImageProfile)
                                ? NetworkImage(controller
                                    .patientsTemp!.user.urlImageProfile!)
                                : Assets.images.logo.provider(),
                            radius: (size.width * 0.25) - 5,
                          )
                        : Container(
                            margin: EdgeInsets.only(right: size.width * 0.012),
                            child: const Icon(
                              DigimedIcon.camera,
                              size: 30,
                            ),
                          ),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          TextButton(
              onPressed: () async {
                controller.fileTemp =
                    await Repositories.multimedia.getImage(ImageSource.gallery);
                if (controller.fileTemp != null) {
                  controller.notifyListeners();
                }
              },
              child: const Text(
                "Añadir desde galería",
                style: AppTextStyle.normalBlue16W500TextStyle,
              )),
          const SizedBox(
            height: 32,
          ),
          controller.state.requestState.when(fetch: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, normal: () {
            return ButtonDigimed(
                child: const Text(
                  "Siguiente",
                  style: AppTextStyle.normalWhiteContentTextStyle,
                ),
                onTab: () async {
                  await controller.checkFileData();
                  if (controller.nexStep) {
                    controller.nexStep = false;
                    controller.step = 9;
                    await controller.changeState();
                  }
                });
          }),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
