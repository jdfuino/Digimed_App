import 'package:cached_network_image/cached_network_image.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/icons/digimed_icon_icons.dart';
import 'package:digimed/app/presentation/global/widgets/banner_digimed.dart';
import 'package:digimed/app/presentation/global/widgets/my_scaffold.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/home_patient_admin_controller.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/controller/state/home_patient_admin_state.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_ap.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_clinic.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_followed.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_data.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_family.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_habit.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_historic_pathology.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_lab.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_prescription.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_report.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_so.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/widget/card_admin_specialist.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home_patient/view/widget/card_clinic_patient.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home_patient/view/widget/card_doctor_specialist.dart';
import 'package:digimed/app/presentation/pages/home/doctor/home_patient/view/widget/card_lab_patient.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDoctorPatientPage extends StatelessWidget {
  final int patientId;
  final Patients patients;

  const HomeDoctorPatientPage(
      {super.key, required this.patients, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePatientAdminController(const HomePatientAdminState(),
          accountRepository: Repositories.account,
          sessionController: context.read(),
          fatherPatient: patients,
          userID: patients.user.id,
          patientId: patientId)
        ..init(),
      child: MyScaffold(
        resizeToAvoidBottomInset: true,
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
                      textLeft: "Mis pacientes",
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
                    return const CardClinicPatient();
                  },
                  labState: () {
                    return const CardLabPatient();
                  },
                  historicClinic: (historic) {
                    return historic.when(
                      dataBasic: () {
                        return Column(
                          children: [
                            const CardHistoricData(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(AppColors
                                                .buttonDisableBackgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_back_ios_new_outlined,
                                              color: AppColors.backgroundColor,
                                              size: 18)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.nextStateHistoric(historic);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.backgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Colors.white,
                                              size: 18)),
                                    ),
                                  ),
                                  const Spacer()
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      dataPathology: () {
                        return Column(
                          children: [
                            const CardHistoricPathology(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.backStateHistoric(historic);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.backgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_back_ios_new_outlined,
                                              color: Colors.white,
                                              size: 18)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.nextStateHistoric(historic);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.backgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Colors.white,
                                              size: 18)),
                                    ),
                                  ),
                                  const Spacer()
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      dataFamilyHistoric: () {
                        return Column(
                          children: [
                            const CardHistoryFamily(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.backStateHistoric(historic);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.backgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_back_ios_new_outlined,
                                              color: Colors.white,
                                              size: 18)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.nextStateHistoric(historic);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.backgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Colors.white,
                                              size: 18)),
                                    ),
                                  ),
                                  const Spacer()
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      dataHabit: () {
                        return Column(
                          children: [
                            const CardHistoricHabit(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.backStateHistoric(historic);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.backgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_back_ios_new_outlined,
                                              color: Colors.white,
                                              size: 18)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.nextStateHistoric(historic);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.backgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Colors.white,
                                              size: 18)),
                                    ),
                                  ),
                                  const Spacer()
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      dataSpecialist: () {
                        return Column(
                          children: [
                            const CardDoctorSpecialist(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
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
                                    height: 50,
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
                                              color: AppColors
                                                  .buttonDisableBackgroundColor,
                                              size: 20)),
                                    ),
                                  ),
                                  const Spacer()
                                ],
                              ),
                            )
                          ],
                        );
                      },
                      dataFallowed: () {
                        return Column(
                          children: [
                            const CardFollowed(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.backStateHistoric(historic);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.backgroundColor),
                                      ),
                                      child: const FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Icon(
                                              Icons.arrow_back_ios_new_outlined,
                                              color: Colors.white,
                                              size: 18)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  SizedBox(
                                    height: 50,
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
                      },
                      dataSO: () {
                        return Column(
                          children: [
                            const CardSO(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
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
                                    height: 50,
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
                      },
                      dataAP: () {
                        return Column(
                          children: [
                            const CardAP(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
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
                                    height: 50,
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
                      },
                      reports: () {
                        return Column(
                          children: [
                            const CardReport(),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  SizedBox(
                                    height: 50,
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
                                    height: 50,
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
                          const CardPrescription(),
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
                    },
                    );
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
