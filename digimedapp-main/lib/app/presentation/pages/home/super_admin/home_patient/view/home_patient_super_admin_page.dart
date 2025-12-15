import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_prescrption_admin.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_report_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/home_patient_super_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/controller/state/home_patient_super_admin_state.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_ap_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_clinic_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_followed_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_historic_data_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_historic_family_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_historic_habit_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_historic_pathology_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_lab_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_so_super_admin.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/widget/card_super_admin_specialist.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePatientSuperAdminPage extends StatelessWidget {
  final int userID;
  final Patients patients;
  final int patientId;

  const HomePatientSuperAdminPage(
      {super.key,
      required this.userID,
      required this.patients,
      required this.patientId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePatientSuperAdminController(
          const HomePatientSuperAdminState(),
          accountRepository: Repositories.account,
          sessionController: context.read(),
          fatherPatient: patients,
          userID: userID,
          patientId: patientId)
        ..init(),
      child: MyScaffold(
        body: Builder(builder: (context) {
          final controller = Provider.of<HomePatientSuperAdminController>(
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
                          child: const Text(
                            'Laboratorio',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
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
                          child: const Text('Registro Clínico',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center),
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
                        ),
                      ),
                    ],
                  ),
                ),
                controller.state.viewState.when(
                  clinicState: () {
                    return const CardClinicSuperAdmin();
                  },
                  labState: () {
                    return const CardLabSuperAdmin();
                  },
                  historicClinic: (historic) {
                    return historic.when(dataBasic: () {
                      return Column(
                        children: [
                          const CardHistoricDataSuperAdmin(),
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
                          const CardHistoricPathologySuperAdmin(),
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
                          const CardHistoryFamilySuperAdmin(),
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
                          const CardHistoricHabitSuperAdmin(),
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
                    }, dataSpecialist: () {
                      return Column(
                        children: [
                          const CardSuperAdminSpecialist(),
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
                    }, dataFallowed: () {
                      return Column(
                        children: [
                          const CardFollowedSuperAdmin(),
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
                    }, dataSO: () {
                      return Column(
                        children: [
                          const CardSOSuperAdmin(),
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
                          const CardAPSuperAdmin(),
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
