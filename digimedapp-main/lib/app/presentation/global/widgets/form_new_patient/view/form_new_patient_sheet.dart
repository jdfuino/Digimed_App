import 'dart:io';

import 'package:digimed/app/domain/globals/utils_extencion.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/button_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_patient/controller/form_new_patient_controller.dart';
import 'package:digimed/app/presentation/global/widgets/form_new_patient/controller/state/form_new_patient_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_doctor/controller/state/home_doctor_admin_state.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home/controller/home_doctor_controller.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home/controller/state/home_doctor_state.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class FormNewPatientSheet extends StatelessWidget {
  final VoidCallback onFinish;
  final int idDoctor;

  const FormNewPatientSheet(
      {super.key, required this.onFinish, required this.idDoctor});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return ChangeNotifierProvider<FormNewPatientController>(
      create: (_) =>
          FormNewPatientController(const FormNewPatientState(),
              sessionController: context.read(),
              accountRepository: Repositories.account,
              doctorId: idDoctor),
      child: Builder(builder: (context) {
        final controller = Provider.of<FormNewPatientController>(
          context,
          listen: true,
        );
        return Container(
          height: MediaQuery
              .of(context)
              .copyWith()
              .size
              .height * 0.85,
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(
                        flex: 2,
                      ),
                      const Text(
                        "Nuevo Paciente",
                        style: AppTextStyle.boldContentTextStyle,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.close,
                            size: 15,
                            color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                          backgroundColor: AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () async {
                      File? file = await Repositories.multimedia
                          .getImage(ImageSource.gallery);
                      if (file != null) {
                        controller.file = file;
                        controller.onChangedImage(file.path);
                      }
                    },
                    child: controller.file == null
                        ? CircleAvatar(
                      backgroundColor:
                      AppColors.buttonDisableBackgroundColor,
                      radius: size.width * 0.18,
                      child: Container(
                        margin: EdgeInsets.only(right: size.width * 0.012),
                        child: const Icon(
                          DigimedIcon.camera,
                          size: 30,
                        ),
                      ),
                    )
                        : CircleAvatar(
                      backgroundImage: Image
                          .file(
                        controller.file!,
                        fit: BoxFit.cover,
                      )
                          .image,
                      radius: size.width * 0.20,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "Información personal",
                    style: AppTextStyle.semiBold14W500ContentTextStyle,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          controller.onChangedGender("Male");
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: controller.state.gender == null ||
                              controller.state.gender == "Famele"
                              ? Colors.white
                              : Colors.blue,
                          foregroundColor: controller.state.gender == null ||
                              controller.state.gender == "Famele"
                              ? Colors.blue
                              : Colors.white,
                          side: const BorderSide(width: 1.0, color: Colors.blue),
                        ),
                        child: const Text('Masculino',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          controller.onChangedGender("Famele");
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: controller.state.gender == null ||
                              controller.state.gender == "Male"
                              ? Colors.white
                              : Colors.blue,
                          foregroundColor: controller.state.gender == null ||
                              controller.state.gender == "Male"
                              ? Colors.blue
                              : Colors.white,
                          side: const BorderSide(width: 1.0, color: Colors.blue),
                        ),
                        child: const Text('Femenino',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Form(
                    child: Builder(builder: (fContext) {
                      return AbsorbPointer(
                        absorbing: controller.state.fetching,
                        child: Container(
                          margin: const EdgeInsets.only(right: 16, left: 16),
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.name,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: 'Nombre y apellido',
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Este campo es obligatorio";
                                  }
                                  return null;
                                },
                                onSaved: (text) {
                                  if (text != null) {
                                    controller.fullName = text;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: 'Cédula de identidad ej: V12344566',
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (text) {
                                  Map<String, String> typeId = {
                                    "V": "Venezolano",
                                    "E": "Extranjero"
                                  };

                                  if (text == null || text.isEmpty) {
                                    return "Este campo es obligatorio";
                                  } else if (!typeId.containsKey(
                                      text[0].toUpperCase().trim())) {
                                    return "Este valor debe contener V o E al inicio";
                                  } else
                                  if (!text.isValidIdentificationNumber()) {
                                    return "Formato invalido";
                                  }
                                  return null;
                                },
                                onSaved: (text) {
                                  if (text != null) {
                                    controller.identificationType =
                                        text.substring(0, 1).toUpperCase();
                                    controller.identificationNumber =
                                        text.substring(1);
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: controller.dateCtl,
                                onTap: () async {
                                  DateTime? date = DateTime(1900);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  date = await showMiDatePicker(
                                    context: context,
                                  );
                                  if (date != null) {
                                    if (date.isLegalAge()) {
                                      controller.onChangedDate(date);
                                    } else {
                                      showToast(
                                          "El usuario no es mayor de edad.");
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: 'Fecha de nacimiento',
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Este campo es obligatorio";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                onChanged: (text) {},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: 'Correo electrónico',
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Este campo es obligatorio";
                                  } else if (!text.isValidEmail()) {
                                    return "Formato de email no valido";
                                  }
                                  return null;
                                },
                                onSaved: (text) {
                                  if (text != null) {
                                    controller.email = text;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              IntlPhoneField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: "Teléfono ej: 414xxxxxxx",
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (phone) {
                                  if (phone != null) {
                                    if (phone.number.isEmpty) {
                                      return "Este campo es obligatorio";
                                    } else if (!phone.number
                                        .isValidIdNumber()) {
                                      return "El numero telefonico no puede empezar con 0";
                                    }
                                  } else {
                                    return "Este campo es obligatorio";
                                  }
                                  return null;
                                },
                                initialCountryCode: 'VE',
                                disableLengthCheck: true,
                                onSaved: (phone) {
                                  if (phone != null) {
                                    controller.countryCode = phone.countryCode;
                                    controller.phoneNumber = phone.number;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                style: AppTextStyle.normalTextStyle2,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                onChanged: (text) {
                                  //controller.onChangedOccupation(text);
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.backgroundSearchColor,
                                  hintText: 'Ocupación o profesión',
                                  hintStyle: AppTextStyle.hintTextStyle,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        width: 0.2,
                                        color: AppColors.backgroundSearchColor),
                                  ),
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Este campo es obligatorio";
                                  }
                                  return null;
                                },
                                onSaved: (text) {
                                  if (text != null) {
                                    controller.occupation = text;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: size.width * 0.40,
                                    child: TextFormField(
                                      keyboardType:TextInputType.text,
                                      style: AppTextStyle.normalTextStyle2,
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      onChanged: (text) {},
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                        AppColors.backgroundSearchColor,
                                        hintText: "Peso en kg",
                                        hintStyle: AppTextStyle.hintTextStyle,
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            20.0, 15.0, 20.0, 15.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 0.2,
                                              color: AppColors
                                                  .backgroundSearchColor),
                                        ),
                                      ),
                                      validator: (weight) {
                                        if (weight == null || weight.isEmpty) {
                                          return "Este campo es obligatorio";
                                        } else if (!weight
                                            .isValidWeightNumber()) {
                                          return "ej: 70.0";
                                        }
                                        else
                                        if (!weight.isWeightInValidRange()) {
                                          return "Fuera de rango";
                                        }
                                        return null;
                                      },
                                      onSaved: (weight) {
                                        print("peso:${weight}s");
                                        if (weight != null &&
                                            weight.isNotEmpty) {
                                          controller.weightTemp =
                                              double.parse(weight ?? "0.0");
                                        }
                                      },
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: size.width * 0.40,
                                    child: TextFormField(
                                      keyboardType:TextInputType.text,
                                      style: AppTextStyle.normalTextStyle2,
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      onChanged: (text) {},
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                        AppColors.backgroundSearchColor,
                                        hintText: "Altura en m",
                                        hintStyle: AppTextStyle.hintTextStyle,
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            20.0, 15.0, 20.0, 15.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              width: 0.2,
                                              color: AppColors
                                                  .backgroundSearchColor),
                                        ),
                                      ),
                                      validator: (weight) {
                                        if (weight == null || weight.isEmpty) {
                                          return "Este campo es obligatorio";
                                        } else if (!weight
                                            .isValidWeightNumber()) {
                                          return "1.7";
                                        }
                                        else
                                        if (!weight.isHeightInValidRange()) {
                                          return "Fuera de rango";
                                        }
                                        return null;
                                      },
                                      onSaved: (weight) {
                                        if (weight != null &&
                                            weight.isNotEmpty) {
                                          controller.heightTemp =
                                              double.parse(weight ?? "0.0");
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              controller.state.requestState.when(
                                  fetch: () {
                                    return const Center(
                                      child: CircularProgressIndicator(),);
                                  },
                                  normal: (){
                                    return ButtonDigimed(
                                        child: const Text(
                                          "Crear paciente",
                                          style: AppTextStyle
                                              .normalWhiteContentTextStyle,
                                        ),
                                        onTab: () async {
                                          final isValid =
                                          Form.of(fContext).validate();
                                          if (isValid) {
                                            Form.of(fContext).save();
                                            if (!controller.state.fetching) {
                                              final result =
                                              await controller.checkedData();
                                              result.when(left: (failure) {
                                                failure.when(
                                                    notFound: () =>
                                                        showToast(
                                                            "Datos no encontrado"),
                                                    network: () =>
                                                        showToast(
                                                            "No hay conexion con Internet"),
                                                    unauthorized: () =>
                                                        showToast(
                                                            "No estas autorizado para realizar esta accion"),
                                                    tokenInvalided: () {
                                                      showToast("Sesion expirada");
                                                      controller.
                                                      sessionController.
                                                      globalCloseSession();
                                                    },
                                                    unknown: () =>
                                                        showToast(
                                                            "Hemos tenido un problema"),
                                                    emailExist: () =>
                                                        showToast(
                                                            "Email ya registrado"),
                                                    formData: (String message) {
                                                      showToast(message);
                                                    });
                                              }, right: (value) {
                                                showToast(
                                                    "Proceso completado correctamente.");
                                                onFinish();
                                                Navigator.of(context).pop();
                                              });
                                            } else {
                                              showToast(
                                                  "Estamos procesando su petición...");
                                            }
                                          }
                                        });
                                  }),

                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
