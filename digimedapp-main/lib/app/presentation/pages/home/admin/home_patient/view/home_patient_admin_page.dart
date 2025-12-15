import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_ap_admin.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_clinic.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_followed.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_data.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_family.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_habit.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_pathology.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_lab.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_prescription.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_prescrption_admin.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_report_admin.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_so_admin.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_admin_specialist.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePatientAdminPage extends StatelessWidget {
  final int userID;
  final Patients patients;

  const HomePatientAdminPage(
      {super.key, required this.userID, required this.patients});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePatientAdminController(const HomePatientAdminState(), 
          accountRepository: Repositories.account,
          sessionController: context.read(),
          fatherPatient: patients,
          userID: userID, patientId: patients.patientID)
        ..init(),
      child: MyScaffold(
        body: Builder(builder: (context) {
          final controller = Provider.of<HomePatientAdminController>(
            context,
            listen: true,
          );
          return SingleChildScrollView(
            child: Column(
              children: [
                controller.state.patientState.when(loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, failed: (_) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }, loaded: (patient) {
                  return BannerDigimed(
                      textLeft: "Detalle paciente",
                      iconLeft: DigimedIcon.detail_user,
                      iconRight: DigimedIcon.back,
                      onClickIconRight: () {
                        Navigator.of(context).pop();
                      },
                      firstLine: "Paciente",
                      secondLine: patient.user.fullName,
                      lastLine:
                          "${patient.user.identificationType}. ${patient.user.identificationNumber}",
                      imageProvider: isValidUrl(patient.user.urlImageProfile)
                          ? NetworkImage(patient.user.urlImageProfile!)
                          : Assets.images.logo.provider());
                }),
                Container(
                  margin: const EdgeInsets.only(right: 28, left: 28),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 90,
                        child: OutlinedButton(
                          onPressed: () {
                            controller
                                .viewOnChanged(const ViewState.clinicState());
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: controller.state.viewState.when(
                                clinicState: () {
                              return AppColors.backgroundColor;
                            }, labState: () {
                              return Colors.white;
                            }, historicClinic: (_) {
                              return Colors.white;
                            }),
                            foregroundColor: controller.state.viewState.when(
                                clinicState: () {
                              return Colors.white;
                            }, labState: () {
                              return AppColors.contentTextColor;
                            }, historicClinic: (_) {
                              return AppColors.contentTextColor;
                            }),
                            side: const BorderSide(
                                width: 1.0, color: Colors.white),
                          ),
                          child: const Text(
                            'Estado clínico',
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            controller
                                .viewOnChanged(const ViewState.labState());
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: controller.state.viewState.when(
                                clinicState: () {
                              return Colors.white;
                            }, labState: () {
                              return AppColors.backgroundColor;
                            }, historicClinic: (_) {
                              return Colors.white;
                            }),
                            foregroundColor: controller.state.viewState.when(
                                clinicState: () {
                              return AppColors.contentTextColor;
                            }, labState: () {
                              return Colors.white;
                            }, historicClinic: (_) {
                              return AppColors.contentTextColor;
                            }),
                            side: const BorderSide(
                                width: 1.0, color: Colors.white),
                          ),
                          child: const Text(
                            'Laboratorio',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 90,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            controller.viewOnChanged(
                                const ViewState.historicClinic());
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: controller.state.viewState.when(
                                clinicState: () {
                              return Colors.white;
                            }, labState: () {
                              return Colors.white;
                            }, historicClinic: (_) {
                              return AppColors.backgroundColor;
                            }),
                            foregroundColor: controller.state.viewState.when(
                                clinicState: () {
                              return AppColors.contentTextColor;
                            }, labState: () {
                              return AppColors.contentTextColor;
                            }, historicClinic: (_) {
                              return Colors.white;
                            }),
                            side: const BorderSide(
                                width: 1.0, color: Colors.white),
                          ),
                          child: const Text('Registro Clínico',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
                controller.state.viewState.when(
                  clinicState: () {
                    return const CardClinic();
                  },
                  labState: () {
                    return const CardLab();
                  },
                  historicClinic: (historic) {
                    return historic.when(dataBasic: () {
                      return Column(
                        children: [
                          const CardHistoricData(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(AppColors
                                              .buttonDisableBackgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: AppColors.backgroundColor,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                    }, dataPathology: () {
                      return Column(
                        children: [
                          const CardHistoricPathology(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                    }, dataFamilyHistoric: () {
                      return Column(
                        children: [
                          const CardHistoryFamily(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                    }, dataHabit: () {
                      return Column(
                        children: [
                          const CardHistoricHabit(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                      // Aquie se empieza a agregar la capacidad al admin de ver la lista de medicos especialistas del paciente.
                    }, dataSpecialist: () {
                      return Column(
                        children: [
                          const CardAdminSpecialist(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppColors.textColor,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                      // Aqui se termino de agregar el codigo al admin de ver la lista de medicos especialistas del paciente.
                    }, dataFallowed: () {
                      return Column(
                        children: [
                          const CardFollowed(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppColors.textColor,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                      // Se agrego la capacidad al admin de ver el registro SOAP.
                    }, dataSO: () {
                      return Column(
                        children: [
                          const CardSOAdmin(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                    }, dataAP: () {
                      return Column(
                        children: [
                          const CardAPAdmin(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                    }, reports: () {
                      return Column(
                        children: [
                         const CardReportAdmin(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nextStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                    }, prescription: () {
                      return Column(
                        children: [
                          const CardPrescriptionAdmin(),
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.backStateHistoric(historic);
                                    },
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          AppColors.backgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_back_ios_new_outlined,
                                            color: Colors.white,
                                            size: 20)),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      backgroundColor:
                                      MaterialStateProperty.all(AppColors
                                          .buttonDisableBackgroundColor),
                                    ),
                                    child: const FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppColors.backgroundColor,
                                            size: 20)),
                                  ),
                                ),
                                const Spacer()
                              ],
                            ),
                          )
                        ],
                      );
                    });
                  },
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
