import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:digimed/app/domain/constants/treatment_status.dart';
import 'package:digimed/app/domain/constants/value_range.dart';
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:digimed/app/domain/models/medical_specialty/medical_specialty.dart';
import 'package:digimed/app/domain/models/notification_model/notification_model.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/profile_cardiovascular/profile_cardiovascular.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/generated/assets.gen.dart';
import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:digimed/app/presentation/global/app_text_sytle.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:digimed/app/presentation/global/widgets/button_error_digimed.dart';
import 'package:digimed/app/presentation/pages/change_password/view/change_password_page.dart';
import 'package:digimed/app/presentation/pages/code_verification/view/code_verification_page.dart';
import 'package:digimed/app/presentation/pages/login/views/login_page.dart';
import 'package:digimed/app/presentation/pages/request_restore_password/view/request_restore_password_page.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_coordinator/view/home_super_admin_coordinator_page.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_doctor/view/home_doctor_super_admin_page.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_patient/view/home_patient_super_admin_page.dart';
import 'package:digimed/app/presentation/pages/info_doctor/super_admin/view/info_doctor_super_admin_page.dart';
import 'package:digimed/app/presentation/pages/info_medical_center/view/info_medical_center_specification.dart';
import 'package:digimed/app/presentation/pages/home/super_admin/home_medical_center/view/info_medical_center_coordinator_page.dart';
import 'package:digimed/app/presentation/pages/note_soap_history/view/note_history_page.dart';
import 'package:digimed/app/presentation/routes/routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digimed/app/domain/globals/enums_digimed.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/working_hours/working_hours.dart';
import 'package:digimed/app/presentation/pages/historic/admin/view/historic_patients_admin.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_doctor/view/home_doctor_admin_page.dart';
import 'package:digimed/app/presentation/pages/home/admin/home_patient/view/home_patient_admin_page.dart';
import 'package:digimed/app/presentation/pages/info_doctor/admin/views/InfoDoctorAdminPage.dart';
import 'package:digimed/app/presentation/pages/resumen_hours/admin/resumen_hours/views/resume_hours_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:country_dial_code/country_dial_code.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../global/icons/digimed_icon_icons.dart';
// import 'package:html/parser.dart' show parse;

Future<void> pushNewPageAdminToDoctor(BuildContext context, int id) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => InfoDoctorAdminPage(id: id),
    ),
  );
}

Future<void> pushNewPageSuperAdminToMedicalCenter(BuildContext context,
    int medicalCenterId, MedicalCenter medicalCenter) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => InfoMedicalCenterSpecificationPage(
        medicalCenterId: medicalCenterId,
        medicalCenter: medicalCenter,
      ),
    ),
  );
}

Future<void> pushNewPageSuperAdminToHomeDoctorPatiens(
    BuildContext context, int id, Doctor doctor) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HomeDoctorSuperAdminPage(
        doctorId: id,
        doctor: doctor,
      ),
    ),
  );
}

Future<void> pushNewPageSuperAdminToHomeDoctor(BuildContext context,
    int idMedicalCenter, User coordinadorMedicalCenter) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HomeSuperAdminCoordinatorPage(
        idMedicalCenter: idMedicalCenter,
        coordinadorMedicalCenter: coordinadorMedicalCenter,
      ),
    ),
  );
}

Future<void> pushNewPageInfoMedicalCenter(BuildContext context,
    int idMedicalCenter, MedicalCenter medicalCenter) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HomeMedicalCenterCoordinatorPage(
        medicalCenter: medicalCenter,
        idMedicalCenter: idMedicalCenter,
      ),
    ),
  );
}

Future<void> pushNewPageSuperAdminToInfoDoctor(
    BuildContext context, int doctorID) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => InfoDoctorSuperAdminPage(doctorID: doctorID),
    ),
  );
}

// Future<void> pushNewPageAdminToSettingHours(BuildContext context, User user,
//     List<WorkingHours>? list, int index, int doctorID) async {
//   await Navigator.push(
//     context,
//     MaterialPageRoute(
//         builder: (_) => SettingHoursAdminPage(
//               user: user,
//               listHours: list,
//               index: index,
//               doctorID: doctorID,
//             )),
//   );
// }

Future<void> pushNewPageAdminToHomePatient(
    BuildContext context, int id, Patients patients) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HomePatientAdminPage(
        userID: id,
        patients: patients,
      ),
    ),
  );
}

// Nuevo Super Admin:
Future<void> pushNewPageSuperAdminToHomePatientCards(
    BuildContext context, int id, Patients patients) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HomePatientSuperAdminPage(
        userID: id,
        patients: patients,
        patientId: patients.patientID,
      ),
    ),
  );
}

Future<void> pushNewNoteHistory(BuildContext context, int id, Patients patients,
    {required String soapId}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => NoteHistoryPage(
        userID: id,
        patients: patients,
        soapId: soapId,
      ),
    ),
  );
}

Future<void> pushNewPageAdminToHistoricPatient(
    BuildContext context, int id) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HistoricPatientsAdmin(patientID: id),
    ),
  );
}

Future<void> pushNewPageRestorePassword(BuildContext context) async {
  await Navigator.push(
      context, MaterialPageRoute(builder: (context) => RequestPasswordPage()));
}

Future<void> pushCodeVerification(
    BuildContext context, String userEmail) async {
  await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CodeVerificationPage(
                userEmail: userEmail,
              )));
}

Future<void> pushLogin(BuildContext context) async {
  await Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
}

Future<void> pushChangePassword(
    BuildContext context, String email, String otpCode) async {
  await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ChangePasswordPage(
                email: email,
                otpCode: otpCode,
              )));
}

Future<void> popAndPushNewPageResumeHours(BuildContext context, int id) async {
  await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ResumeHoursPage(id: id)));
}

String convertDate(String dateUTC) {
  try {
    DateTime date = DateTime.parse(dateUTC);

    String dia = date.day.toString().padLeft(2, '0');
    String mes = date.month.toString().padLeft(2, '0');
    String anio = date.year.toString();

    return '$dia/$mes/$anio';
  } catch (e) {
    return "";
  }
}

String convertDateCaracas(String dateUTC) {
  try {
    // Parsear la fecha UTC
    DateTime date = DateTime.parse(dateUTC);

    // Ajustar a la zona horaria de Caracas (UTC-4)
    DateTime caracasDate = date.subtract(Duration(hours: 4));

    String dia = caracasDate.day.toString().padLeft(2, '0');
    String mes = caracasDate.month.toString().padLeft(2, '0');
    String anio = caracasDate.year.toString();
    String hora = caracasDate.hour.toString().padLeft(2, '0');
    String minuto = caracasDate.minute.toString().padLeft(2, '0');

    // return '$dia/$mes/$anio $hora:$minuto';
    return '$dia/$mes/$anio';
  } catch (e) {
    return "";
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

String getAbrevMounth(DateTime fecha) {
  return DateFormat('MMM', 'es_ES').format(fecha).toUpperCase();
}

String obtenerAbreviaturaMes(int numeroMes) {
  Map<int, String> meses = {
    1: "ENE",
    2: "FEB",
    3: "MAR",
    4: "ABR",
    5: "MAY",
    6: "JUN",
    7: "JUL",
    8: "AGO",
    9: "SEP",
    10: "OCT",
    11: "NOV",
    12: "DIC"
  };

  return meses[numeroMes] ?? "ENE";
}

String getWeek(int index) {
  Map<int, String> week = {
    0: "Semana 1",
    1: "Semana 2",
    2: "Semana 3",
    3: "Semana 4",
  };

  return week[index] ?? "Semana 1";
}

String getDay(int index) {
  Map<int, String> day = {
    0: "Día 1",
    1: "Día 2",
    2: "Día 3",
    3: "Día 4",
    4: "Día 5",
    5: "Día 6",
    6: "Día 7",
  };

  return day[index] ?? "Día 1";
}

Map<int, List<String>> organizeList(List<WorkingHours>? list) {
  Map<int, List<String>> map = {};

  if (list != null && list.isNotEmpty) {
    for (WorkingHours element in list) {
      if (!map.containsKey(element.dayOfWeek)) {
        map[element.dayOfWeek] = [];
      }

      if (element.startTime0 != null && element.stopTime0 != null) {
        map[element.dayOfWeek]!.add(
            "${formatTime(element.startTime0!)} - ${formatTime(element.stopTime0!)}");
      }

      if (element.startTime1 != null && element.stopTime1 != null) {
        map[element.dayOfWeek]!.add(
            "${formatTime(element.startTime1!)} - ${formatTime(element.stopTime1!)}");
      }
    }
  }
  return map;
}

Map<int, List<String>?> organizeListDays(Map<int, List<String>> mapDays) {
  Map<int, List<String>?> map = {};
  dayDigimed.forEach((key, value) {
    map[key] = [];
    if (mapDays.containsKey(key)) {
      map[key] = mapDays[key];
    } else {
      map[key] = ["Sin atención"];
    }
  });
  return map;
}

String getHours(List<String> list) {
  String s = "";
  int i = 0;

  for (var element in list) {
    if (i == list.length - 1) {
      s += element;
      i = 0;
    } else {
      s += "$element \n";
      i++;
    }
  }
  return s;
}

String formatTime(String time) {
  DateTime dateTime = DateTime.parse(time);
  String formattedTime = DateFormat('h:mm a').format(dateTime);

  return formattedTime;
}

String convertirTimeOfDay(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  return getDateWithFormatToUpload(dateTime);
}

void launchWhatsapp(String numberWhitCountryCode, String message) async {
  var androidUrl = "whatsapp://send?phone=$numberWhitCountryCode&text=$message";
  var iosUrl =
      "https://wa.me/$numberWhitCountryCode?text=${Uri.parse(message)}";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    showToast('WhatsApp is not installed.');
  }
}

List<WorkingHours> getAllWorkHours(int index, List<WorkingHours> list) {
  List<WorkingHours> listReturn = [];
  for (final e in list) {
    if (e.dayOfWeek == index) {
      listReturn.add(e);
    }
  }
  return listReturn;
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dt =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final format = DateFormat.jm();
  return format.format(dt);
}

String contractDigimed = '''
Al considerar su participación como AFILIADO en el Plan Personalizado de DigiMed, es esencial que comprenda y acepte lo siguiente:
1. Objetivo del Plan: DigiMed, en colaboración con facultativos e infraestructura médica de instituciones de salud afiliadas, ha desarrollado un Plan Personalizado que utiliza tecnologías de medicina digital predictiva, preventiva y resolutiva. El objetivo es predecir y prevenir enfermedades comunes, mejorando la calidad de vida y retrasando la aparición de Enfermedades No Transmisibles (ENT) como enfermedades cardio y cerebrovasculares, cánceres, respiratorias, obesidad y diabetes tipo 2.
2. Datos Recopilados: Para evaluar indicadores clave de salud y monitorear la efectividad del Plan, se registrarán datos relacionados con salud personal, estilo de vida, genética, laboratorio clínico, microbiota, parámetros físicos, entre otros. Estos datos serán recopilados con la colaboración de profesionales seleccionados por la institución participante a la que esté adscrito el AFILIADO.
3. Confidencialidad y Privacidad: Todos los datos recopilados serán tratados con la máxima confidencialidad y se procesarán de forma anónima. No se compartirán con terceros, excepto por requerimientos legales de autoridades competentes. En tal caso, se notificará previamente al AFILIADO.
4. Riesgos y Beneficios: La participación puede llevar a la detección temprana de enfermedades y prevención a largo plazo. Sin embargo, existe el riesgo de exposición de información personal y la posibilidad de recibir resultados inexactos.
5. Alternativas: Se ofrecerán alternativas al programa, incluyendo otras formas de prevención de enfermedades o programas similares disponibles.
6. Derechos del AFILIADO: Tienes el derecho de retirarte del programa en cualquier momento, acceder a tu información personal, solicitar correcciones y ejercer el derecho a no saber cierta información.
7. Contacto: Si tienes preguntas o inquietudes, puedes contactarnos en [proporcionar información de contacto].
Al seleccionar la opción "Aceptar", reconoces y declaras haber leído y comprendido este Consentimiento Informado. Aceptas los términos y condiciones que determinan tu afiliación.
''';

String contractDigimedDoctor = '''
Al utilizar el aplicativo de medicina digital predictiva como médico-guía, usted comprende y acepta lo siguiente:
1. Naturaleza del Aplicativo: Este aplicativo es una herramienta diseñada para la captura digital de información clínica relevante de usuarios de pólizas de seguros de salud. Su principal objetivo es facilitar la labor del médico-guía mediante la consolidación y presentación de datos clínicos y personales.
2. Datos Capturados: El aplicativo recopila y presenta información personal y clínica. Todos los datos se obtienen solo después de que el usuario haya proporcionado su consentimiento informado. Se espera que los datos sean utilizados con responsabilidad y ética profesional.
3. Acceso a la Lista de Usuarios: El sistema proporciona acceso a una lista en línea de usuarios o pacientes. Esta lista puede ser consultada durante cada visita, ya sea personal o virtual. Es esencial garantizar la confidencialidad de esta información en todo momento.
4. Visualización Gráfica: El aplicativo ofrece representaciones gráficas del historial de datos personales y clínicos del usuario, facilitando la interpretación y el análisis.
5. Propiedad, Protección y Retención de Datos: Cada registro clínico es propiedad exclusiva del paciente o usuario. El aplicativo garantiza la protección de estos datos mediante encriptación avanzada y otras medidas de seguridad. Los datos se retendrán de acuerdo con las regulaciones internacionales y se eliminarán o anonimizarán después de este período.
6. Transferencia Internacional de Datos: Si los datos se transfieren internacionalmente, se siguen protocolos estrictos para garantizar su protección de acuerdo con las normas internacionales.
7. Limitaciones del Aplicativo: Este aplicativo no es una historia médica electrónica conforme al estándar HL7. Es un registro clínico simplificado diseñado como una herramienta práctica. Es esencial entender sus limitaciones y no depender únicamente de él para decisiones clínicas.
8. Responsabilidad: Aunque el aplicativo proporciona información valiosa, no reemplaza el juicio clínico ni la relación médico-paciente. El médico-guía es el único responsable de las decisiones clínicas basadas en la información proporcionada.
9. Actualizaciones y Cambios: Cualquier cambio en este descargo de responsabilidad o en las políticas del aplicativo será comunicado adecuadamente. Es responsabilidad del médico-guía mantenerse informado sobre estas actualizaciones.
Nota Final: Al acceder y utilizar este aplicativo como médico-guía, usted reconoce y acepta los términos y condiciones establecidos en este descargo de responsabilidad y se compromete a actuar de acuerdo con las mejores prácticas médicas y éticas.
''';

String contractDigimedAdmin = '''
Al utilizar este aplicativo, usted acepta y comprende lo siguiente:
1. Objetivo del Aplicativo: Este aplicativo ha sido diseñado con el propósito de reducir el riesgo asociado a enfermedades comunes que representan dos tercios de la morbilidad mundial y para disminuir la severidad de los pacientes.
2. Dirigido a Seguros de Salud: La herramienta está principalmente dirigida a entidades y proveedores de seguros de salud.
3. Captura de Datos de Salud: El aplicativo utiliza tecnología avanzada para la captura digital de datos personales de salud. Todos los datos se obtienen solo después de que el usuario haya proporcionado su consentimiento informado. Se espera que los datos sean utilizados con responsabilidad y ética profesional.
4. Médico Guía: Se proporciona un médico guía para asistir y orientar al usuario en su participación activa en el cuidado de su propia salud.
5. Registro Clínico: Cada médico guía mantendrá un registro clínico de sus usuarios o pacientes. Este registro tiene como objetivo principal orientar y hacer seguimiento de la salud personal del usuario. Los usuarios tienen derecho a acceder, rectificar y eliminar sus datos.
6. Portal Digital Complementario: El aplicativo se complementa con un portal digital que proporciona información médica relevante tanto al usuario como al médico guía.
7. Propiedad, Protección y Retención de Datos: Cada registro clínico es propiedad exclusiva del paciente o usuario. El aplicativo garantiza la protección de estos datos mediante encriptación avanzada y otras medidas de seguridad. Los datos se retendrán de acuerdo con las regulaciones internacionales y se eliminarán o anonimizarán después de este período.
8. Limitaciones del Aplicativo: Este aplicativo no pretende ser una herramienta de telemedicina ni una historia médica electrónica en su primera etapa. Es un sistema de captura digital de información de salud diseñado para facilitar la participación tanto del médico como del usuario.
Nota Final: Aunque el aplicativo proporciona información y herramientas valiosas para la gestión de la salud, no reemplaza el juicio clínico ni la relación médico-paciente. Es esencial que los usuarios consulten a profesionales de la salud para cualquier diagnóstico o tratamiento médico.
Al acceder y utilizar este aplicativo, usted reconoce y acepta los términos y condiciones establecidos en este descargo de responsabilidad y se compromete a actuar de acuerdo con las mejores prácticas médicas y éticas.
''';

bool systolicAltered(double value) {
  if (value >= ValueRange.systolicMin && value <= ValueRange.systolicMax) {
    return false;
  }
  return true;
}

bool diastolicAltered(double value) {
  if (value >= ValueRange.diastolicMin && value <= ValueRange.diastolicMax) {
    return false;
  }
  return true;
}

bool rateAltered(double value) {
  if (value >= ValueRange.heartRateMin && value <= ValueRange.heartRateMax) {
    return false;
  }
  return true;
}

bool sleepAltered(double value) {
  if (value >= ValueRange.sleepMin && value <= ValueRange.sleepMax) {
    return false;
  }
  return true;
}

bool glucemiaAltered(double value) {
  if (value >= ValueRange.glucoseMin && value <= ValueRange.glucoseMax) {
    return false;
  }
  return true;
}

bool trigliceriosAltered(double value) {
  if (value < ValueRange.triglyceridesMax) {
    return false;
  }
  return true;
}

bool colesterolAltered(double value) {
  if (value < ValueRange.cholesterolMax) {
    return false;
  }
  return true;
}

bool hemoglobinaAltered(double value, String gender) {
  if (gender.isEmpty || gender == "Male") {
    if (value >= ValueRange.hemoglobinMaleMin &&
        value <= ValueRange.hemoglobinMaleMax) {
      return false;
    }
  } else {
    if (value >= ValueRange.hemoglobinFemaleMin &&
        value <= ValueRange.hemoglobinFemaleMax) {
      return false;
    }
  }
  return true;
}

bool acidoUricoAltered(double value, String gender) {
  if (gender.isEmpty || gender == "Male") {
    if (value >= ValueRange.uricAcidMaleMin &&
        value <= ValueRange.uricAcidMaleMax) {
      return false;
    }
  } else {
    if (value >= ValueRange.uricAcidFemaleMin &&
        value <= ValueRange.uricAcidFemaleMax) {
      return false;
    }
  }
  return true;
}

void closeSession({required BuildContext context, bool mounted = true}) async {
  //showToast("Sesion expirada");
  final SessionController sessionController = context.read();
  await sessionController.signOut();
  if (!mounted) {
    return;
  }
  Navigator.pushReplacementNamed(
    context,
    Routes.login,
  );
}

String getDateWithFormatToUpload(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSSSS');
  final String formattedDate = formatter.format(date);
  const String timeZoneOffset =
      "Z"; //"Z${formatDuration(date.timeZoneOffset)}" ;
  final String formatted = formattedDate + timeZoneOffset;
  return formatted;
}

String twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

String formatDuration(Duration duration) {
  String twoDigitHours = twoDigits(duration.inHours.abs());
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return "${duration.isNegative ? "-" : ""}$twoDigitHours:$twoDigitMinutes";
}

Map<String, String> rangeGraph = {
  "1 semana": "WEEK",
  "1 mes": "MONTH",
  "6 meses": "HALF_YEAR",
  "1 año": "YEAR"
};

Widget errorButton(BuildContext context, VoidCallback action) {
  showToast("Hemos tenido un problema");
  return Center(
    child: ButtonErrorDigimed(
      onTab: () async {
        action();
      },
    ),
  );
}

Widget errorMessage() {
  return Center(
    child: Column(
      children: [
        Assets.svgs.noInfo.svg(),
        const Text(
          "¡No hay datos disponibles!",
          style: AppTextStyle.normalContentTextStyle,
        ),
        const SizedBox(
          height: 16,
        )
      ],
    ),
  );
}

bool alteredValues(ProfileCardiovascular? profileCardiovascular,
    ProfileLaboratory? profileLaboratory, String gender) {
  if (profileLaboratory != null && profileCardiovascular != null) {
    if (profileLaboratory.uricAcid != null) {
      return !(!systolicAltered(profileCardiovascular.systolicPressure!) &&
          !diastolicAltered(profileCardiovascular.diastolicPressure!) &&
          !rateAltered(profileCardiovascular.heartFrequency!) &&
          !sleepAltered(profileCardiovascular.sleepingHours!) &&
          !glucemiaAltered(profileLaboratory.glucose) &&
          !trigliceriosAltered(profileLaboratory.triglycerides) &&
          !colesterolAltered(profileLaboratory.cholesterol) &&
          !hemoglobinaAltered(profileLaboratory.hemoglobin, gender) &&
          !acidoUricoAltered(profileLaboratory.uricAcid!, gender));
    }
  }
  return true;
}

String getIsoCodeFromDialCode(String dialCode) {
  try {
    final f = CountryDialCode.fromDialCode(dialCode);
    return f.code;
  } catch (e) {
    return 'VE';
  }
}

bool isValidUrl(String? url) {
  try {
    if (url == null || url.isEmpty || url == "https://digimed.com") {
      return false;
    }
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  } catch (e) {
    return false;
  }
}

String titleOKDialog = "Valores ideales";
String titleWarningDialog = "Valores anormales";
String messageOKDoctorDialog =
    '''¡Felicidades! los valores de tu paciente se encuentran en el rango normal, mantén el seguimiento de sus resultados para tenerlo siempre en nuestra zona de bienestar.''';
String messageOKPatientDialog =
    '''¡Felicidades! tus valores están en el rango correcto, mantente saludable y disfruta de los beneficios que Digimed ofrece a sus usuarios asegurados.''';

String showNumber2(double number) {
  final format = NumberFormat("#.##", "es_ES");

  return format.format(number);
}

String showNumber(double number) {
  int input = number.toInt();
  return input.toString();
}

Future<Uint8List?> compressImage(File file) async {
  try {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 25,
    );

    return result;
  } catch (e) {
    return null;
  }
}

Future<DateTime?> showMiDatePicker(
    {required BuildContext context, DateTime? initDate}) {
  return showDatePicker(
    context: context,
    initialDate: initDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    locale: const Locale("es", "ES"),
    // Aquí puedes personalizar el DatePicker
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.backgroundColor,
              onPrimary: AppColors.backgroundSearchColor,
              surface: AppColors.backgroundSearchColor,
              onSurface: Colors.black,
            ),
            primaryColor: AppColors.backgroundColor,
            secondaryHeaderColor: AppColors.backgroundColor),
        child: child!,
      );
    },
  );
}

List<Widget> getDataSoap(String? data, String? date) {
  if (data == null || data.isEmpty) {
    return [
      const Spacer(),
      const Text(
        "¡No hay registros disponibles!",
        style: AppTextStyle.grey13W500ContentTextStyle,
      ),
      const Spacer()
    ];
  } else {
    return [
      Expanded(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              convertDate(date!),
              style: AppTextStyle.grey13BoldContentTextStyle,
            ),
            Text(
              data,
              style: AppTextStyle.normal16W500ContentTextStyle,
            )
          ],
        ),
      )),
    ];
  }
}

int convertDateTimeToMinutes(DateTime dateTime) {
  int totalMinutes = 0;

  // Aproximación para calcular el total de minutos en un año
  totalMinutes += dateTime.year * 525600;

  // Aproximación para calcular el total de minutos en un mes
  totalMinutes += dateTime.month * 43800;

  totalMinutes += dateTime.day * 1440;
  totalMinutes += dateTime.hour * 60;
  totalMinutes += dateTime.minute;
  totalMinutes += dateTime.second ~/ 60; // convert seconds to minutes

  return totalMinutes;
}

int searchPositionInTheList(double value, List<FlSpot> list) {
  for (int i = 0; i < list.length; i++) {
    if (list[i].x == value) {
      return i;
    }
  }
  return -1;
}

String formatDate(DateTime date) {
  String day = date.day.toString().padLeft(2, '0');
  String month = date.month.toString().padLeft(2, '0');
  String year = date.year.toString();

  String hour = date.hour.toString().padLeft(2, '0');
  String minute = date.minute.toString().padLeft(2, '0');

  return '$day/$month/$year-$hour:$minute';
}

String getNameSpecialty(List<MedicalSpecialty> specialties) {
  if (specialties.isEmpty) {
    return "";
  }

  return specialties.map((specialty) => specialty.name).join(", ");
}

String? parseHtmlToPlainText(String? html) {
  // if(html != null){
  //   var document = parse(html);
  //   return document.body?.text ?? '';
  // }
  return html;
}

String deltaToHtml(Map<dynamic, dynamic> delta) {
  StringBuffer html = StringBuffer();
  List ops = delta['ops'] ?? [];

  for (var op in ops) {
    if (op['insert'] != null) {
      String text = op['insert'].toString();
      var attributes = op['attributes'];

      if (attributes != null) {
        if (attributes['bold'] == true) {
          html.write('<strong>$text</strong>');
        } else if (attributes['italic'] == true) {
          html.write('<em>$text</em>');
        } else if (attributes['header'] == 1) {
          html.write('<h1>$text</h1>');
        } else if (attributes['header'] == 2) {
          html.write('<h2>$text</h2>');
        } else if (attributes['list'] == 'bullet') {
          html.write('<li>$text</li>');
        } else {
          html.write(text);
        }
      } else {
        html.write(text);
      }
    }
  }

  // Envolver listas si es necesario
  String result = html.toString();
  if (result.contains('<li>')) {
    result = '<ul>$result</ul>';
  }

  return result;
}

Future<bool> createAndSavePdfFromBase64(
    {required String base64String, required String patientName}) async {
  try {
    // 1. Decodificar el string Base64 a bytes
    final bytes = base64Decode(base64String);

    // 2. Formatear el nombre del archivo: "nombre del paciente_dia_mes_ano_hora_minuto_seg"
    final now = DateTime.now();
    final formattedDateTime =
        "${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}";
    final sanitizedPatientName = patientName.replaceAll(" ", "_");
    final fileName = "${sanitizedPatientName}_${formattedDateTime}";

    // 3. Crear un archivo temporal
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/$fileName.pdf';
    final tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(bytes);

    // 4. Compartir el archivo usando share_plus
    await Share.shareXFiles(
      [XFile(tempFilePath, mimeType: 'application/pdf')],
      text: 'Aquí tienes el PDF: $fileName.pdf',
    );

    // 5. Mostrar un mensaje de éxito
    showToast("Archivo compartido: $fileName.pdf");

    // 6. Limpiar el archivo temporal (opcional, dependiendo de tu caso)
    await tempFile.delete();
    return true;
  } catch (e) {
    // Manejo de errores
    showToast("Error al compartir el PDF: $e");
    return false;
  }
}

int calculateYearsFromUtcDate(String utcDateString) {
  try {
    // 1. Convertir el string UTC a un objeto DateTime
    final utcDate = DateTime.parse(utcDateString).toUtc();

    // 2. Obtener la fecha actual en UTC
    final now = DateTime.now().toUtc();

    // 3. Calcular la diferencia en años
    int years = now.year - utcDate.year;

    // 4. Ajustar si el mes/día actual es anterior al mes/día de la fecha proporcionada
    if (now.month < utcDate.month ||
        (now.month == utcDate.month && now.day < utcDate.day)) {
      years--;
    }

    // 5. Asegurarse de que no devolvamos un valor negativo
    return years < 0 ? 0 : years;
  } catch (e) {
    // Manejo de errores: si el formato del string es inválido, devolver 0 o lanzar una excepción
    print("Error al parsear la fecha: $e");
    return 0;
  }
}

/// Funciones que devuelven mensajes descriptivos para valores médicos
/// basados en qué tan cerca o lejos estén de los rangos normales

String getSystolicPressureMessage(double value) {
  if (value >= ValueRange.systolicMin && value <= ValueRange.systolicMax) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else if (value < ValueRange.systolicMin) {
    if (value < 80) {
      return "Tu presión sistólica está muy baja. Es importante que consultes con tu médico de inmediato.";
    } else {
      return "Tu presión sistólica está ligeramente baja. Mantente hidratado y consulta con tu médico.";
    }
  } else {
    if (value > 160) {
      return "Tu presión sistólica está muy elevada. Es urgente que consultes con tu médico.";
    } else if (value > 140) {
      return "Tu presión sistólica está elevada. Consulta con tu médico y revisa tu estilo de vida.";
    } else {
      return "Tu presión sistólica está ligeramente alta. Controla tu dieta y haz ejercicio regularmente.";
    }
  }
}

String getDiastolicPressureMessage(double value) {
  if (value >= ValueRange.diastolicMin && value <= ValueRange.diastolicMax) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else if (value < ValueRange.diastolicMin) {
    if (value < 50) {
      return "Tu presión diastólica está muy baja. Es importante que consultes con tu médico de inmediato.";
    } else {
      return "Tu presión diastólica está ligeramente baja. Mantente hidratado y consulta con tu médico.";
    }
  } else {
    if (value > 100) {
      return "Tu presión diastólica está muy elevada. Es urgente que consultes con tu médico.";
    } else if (value > 90) {
      return "Tu presión diastólica está elevada. Consulta con tu médico y revisa tu estilo de vida.";
    } else {
      return "Tu presión diastólica está ligeramente alta. Controla tu dieta y reduce el estrés.";
    }
  }
}

String getHeartRateMessage(double value) {
  if (value >= ValueRange.heartRateMin && value <= ValueRange.heartRateMax) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else if (value < ValueRange.heartRateMin) {
    if (value < 50) {
      return "Tu frecuencia cardíaca está muy baja. Es importante que consultes con tu médico de inmediato.";
    } else {
      return "Tu frecuencia cardíaca está ligeramente baja. Si no eres atleta, consulta con tu médico.";
    }
  } else {
    if (value > 120) {
      return "Tu frecuencia cardíaca está muy elevada. Es importante que consultes con tu médico.";
    } else {
      return "Tu frecuencia cardíaca está ligeramente alta. Reduce el estrés y evita la cafeína.";
    }
  }
}

String getSleepMessage(double value) {
  if (value >= ValueRange.sleepMin && value <= ValueRange.sleepMax) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else if (value < ValueRange.sleepMin) {
    if (value < 5) {
      return "Duermes muy pocas horas. Esto puede afectar seriamente tu salud. Consulta con un especialista.";
    } else {
      return "Duermes menos de lo recomendado. Trata de establecer una rutina de sueño más regular.";
    }
  } else {
    if (value > 11) {
      return "Duermes demasiadas horas. Esto podría indicar un problema de salud. Consulta con tu médico.";
    } else {
      return "Duermes más de lo recomendado. Trata de mantener un horario de sueño más regular.";
    }
  }
}

String getGlucoseMessage(double value) {
  if (value >= ValueRange.glucoseMin && value <= ValueRange.glucoseMax) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else if (value < ValueRange.glucoseMin) {
    if (value < 60) {
      return "Tu nivel de glucosa está muy bajo. Es importante que consultes con tu médico de inmediato.";
    } else {
      return "Tu nivel de glucosa está ligeramente bajo. Consulta con tu médico sobre tu dieta.";
    }
  } else {
    if (value > 140) {
      return "Tu nivel de glucosa está muy elevado. Es urgente que consultes con tu médico para evaluar diabetes.";
    } else if (value > 125) {
      return "Tu nivel de glucosa está elevado. Consulta con tu médico y controla tu dieta.";
    } else {
      return "Tu nivel de glucosa está ligeramente alto. Controla tu consumo de azúcares y carbohidratos.";
    }
  }
}

String getTriglyceridesMessage(double value) {
  if (value < ValueRange.triglyceridesMax) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else {
    if (value > 500) {
      return "Tus triglicéridos están muy elevados. Es urgente que consultes con tu médico de inmediato.";
    } else if (value > 300) {
      return "Tus triglicéridos están muy altos. Consulta con tu médico y revisa tu dieta urgentemente.";
    } else if (value > 200) {
      return "Tus triglicéridos están elevados. Reduce las grasas saturadas y aumenta el ejercicio.";
    } else {
      return "Tus triglicéridos están ligeramente altos. Controla tu dieta y haz más ejercicio.";
    }
  }
}

String getCholesterolMessage(double value) {
  if (value < ValueRange.cholesterolMax) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else {
    if (value > 300) {
      return "Tu colesterol está muy elevado. Es urgente que consultes con tu médico de inmediato.";
    } else if (value > 250) {
      return "Tu colesterol está muy alto. Consulta con tu médico y cambia tu dieta urgentemente.";
    } else {
      return "Tu colesterol está ligeramente alto. Reduce las grasas saturadas y aumenta la fibra en tu dieta.";
    }
  }
}

String getHemoglobinMessage(double value, String gender) {
  bool isMale = gender.isEmpty || gender == "Male";
  double minValue =
      isMale ? ValueRange.hemoglobinMaleMin : ValueRange.hemoglobinFemaleMin;
  double maxValue =
      isMale ? ValueRange.hemoglobinMaleMax : ValueRange.hemoglobinFemaleMax;

  if (value >= minValue && value <= maxValue) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else if (value < minValue) {
    if (value < (minValue - 2)) {
      return "Tu hemoglobina está muy baja. Es importante que consultes con tu médico de inmediato para evaluar anemia.";
    } else {
      return "Tu hemoglobina está ligeramente baja. Consulta con tu médico sobre suplementos de hierro.";
    }
  } else {
    if (value > (maxValue + 2)) {
      return "Tu hemoglobina está muy elevada. Consulta con tu médico para descartar problemas de salud.";
    } else {
      return "Tu hemoglobina está ligeramente alta. Mantente hidratado y consulta con tu médico.";
    }
  }
}

String getUricAcidMessage(double value, String gender) {
  bool isMale = gender.isEmpty || gender == "Male";
  double minValue =
      isMale ? ValueRange.uricAcidMaleMin : ValueRange.uricAcidFemaleMin;
  double maxValue =
      isMale ? ValueRange.uricAcidMaleMax : ValueRange.uricAcidFemaleMax;

  if (value >= minValue && value <= maxValue) {
    return "Has cumplido con tu meta y te has mantenido en la zona segura.";
  } else if (value < minValue) {
    return "Tu ácido úrico está bajo. Esto generalmente no es preocupante, pero consulta con tu médico.";
  } else {
    if (value > (maxValue + 2)) {
      return "Tu ácido úrico está muy elevado. Es urgente que consultes con tu médico para prevenir gota.";
    } else {
      return "Tu ácido úrico está ligeramente alto. Reduce el consumo de carnes rojas y alcohol.";
    }
  }
}

int getCountUnreadNotification(List<NotificationModel> notifications) {
  int unreadCount =
      notifications.where((notification) => !notification.read).length;
  return unreadCount;
}

Treatment? checkTreatmentPending(List<Treatment> treatments) {
  for (var treatment in treatments) {
    if (treatment.status == TreatmentStatus.pendingToStart) {
      return treatment;
    }
  }
  return null;
}

/// Función que retorna un widget con mensaje de presión arterial
/// basado en valores sistólicos y diastólicos, adaptado según el rol del usuario
Widget getBloodPressureMessageWidget(
  double systolicValue,
  double diastolicValue,
  {bool isPatientView = true}
) {
  // Verificar si ambos valores están en rango normal
  bool systolicInRange = systolicValue >= ValueRange.systolicMin && systolicValue <= ValueRange.systolicMax;
  bool diastolicInRange = diastolicValue >= ValueRange.diastolicMin && diastolicValue <= ValueRange.diastolicMax;
  bool bothInRange = systolicInRange && diastolicInRange;

  // Generar mensaje según el rol y los valores
  String message = _generatePressureMessage(systolicValue, diastolicValue, systolicInRange, diastolicInRange, isPatientView);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icono con animación opcional
      Stack(
        alignment: Alignment.center,
        children: [
          // Animación de confetti cuando los valores están en rango
          if (bothInRange)
            SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                'assets/lottiefiles/Confetti.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          // Icono principal
          Container(
            width: 30,
            height: 30,
            child: bothInRange
              ? SvgPicture.asset(
                  'assets/svgs/trofeo_points.svg',
                  width: 30,
                  height: 30,
                )
              : Icon(
                  DigimedIcon.alert,
                  color: Colors.orange,
                  size: 30,
                ),
          ),
        ],
      ),
      const SizedBox(width: 12),
      // Mensaje de texto
      Expanded(
        child: Text(
          message,
          style: AppTextStyle.grey13W500ContentTextStyle,
        ),
      ),
    ],
  );
}

/// Genera el mensaje de presión arterial según los valores y el rol del usuario
String _generatePressureMessage(
  double systolicValue,
  double diastolicValue,
  bool systolicInRange,
  bool diastolicInRange,
  bool isPatientView
) {
  // Pronombres según el rol
  String subject = isPatientView ? "Tu" : "Su";
  String possessive = isPatientView ? "tu" : "su";
  String verb = isPatientView ? "has" : "ha";
  String imperative = isPatientView ? "Consulta" : "El paciente debe consultar";
  String recommendation = isPatientView ? "Mantente" : "Debe mantenerse";
  String action = isPatientView ? "Controla" : "Debe controlar";

  // Caso ideal: ambos valores en rango
  if (systolicInRange && diastolicInRange) {
    return "$subject $verb cumplido con ${isPatientView ? 'tu' : 'la'} meta y ${isPatientView ? 'te has' : 'se ha'} mantenido en la zona segura.";
  }

  // Análisis de presión sistólica fuera de rango
  if (!systolicInRange) {
    if (systolicValue < ValueRange.systolicMin) {
      if (systolicValue < 80) {
        return "$subject presión sistólica está muy baja. Es importante que ${imperative.toLowerCase()} con ${possessive} médico de inmediato.";
      } else {
        return "$subject presión sistólica está ligeramente baja. $recommendation ${isPatientView ? 'hidratado' : 'hidratado'} y ${imperative.toLowerCase()} con ${possessive} médico.";
      }
    } else {
      if (systolicValue > 160) {
        return "$subject presión sistólica está muy elevada. Es urgente que ${imperative.toLowerCase()} con ${possessive} médico.";
      } else if (systolicValue > 140) {
        return "$subject presión sistólica está elevada. ${imperative} con ${possessive} médico y ${isPatientView ? 'revisa' : 'debe revisar'} ${possessive} estilo de vida.";
      } else {
        return "$subject presión sistólica está ligeramente alta. $action ${possessive} dieta y ${isPatientView ? 'haz' : 'debe hacer'} ejercicio regularmente.";
      }
    }
  }

  // Análisis de presión diastólica fuera de rango
  if (!diastolicInRange) {
    if (diastolicValue < ValueRange.diastolicMin) {
      if (diastolicValue < 50) {
        return "$subject presión diastólica está muy baja. Es importante que ${imperative.toLowerCase()} con ${possessive} médico de inmediato.";
      } else {
        return "$subject presión diastólica está ligeramente baja. $recommendation ${isPatientView ? 'hidratado' : 'hidratado'} y ${imperative.toLowerCase()} con ${possessive} médico.";
      }
    } else {
      if (diastolicValue > 100) {
        return "$subject presión diastólica está muy elevada. Es urgente que ${imperative.toLowerCase()} con ${possessive} médico.";
      } else if (diastolicValue > 90) {
        return "$subject presión diastólica está elevada. ${imperative} con ${possessive} médico y ${isPatientView ? 'revisa' : 'debe revisar'} ${possessive} estilo de vida.";
      } else {
        return "$subject presión diastólica está ligeramente alta. $action ${possessive} dieta y ${isPatientView ? 'reduce' : 'debe reducir'} el estrés.";
      }
    }
  }

  return "$subject presión arterial requiere atención. ${imperative} con ${possessive} médico.";
}

/// Genera un widget con mensaje, icono y animación para frecuencia cardíaca
/// Similar a getBloodPressureMessageWidget pero para frecuencia cardíaca
Widget getHeartRateMessageWidget(
  double heartRateValue,
  {bool isPatientView = true}
) {
  // Verificar si el valor está en rango normal
  bool heartRateInRange = heartRateValue >= ValueRange.heartRateMin && heartRateValue <= ValueRange.heartRateMax;

  // Generar mensaje según el rol y el valor
  String message = _generateHeartRateMessage(heartRateValue, heartRateInRange, isPatientView);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icono con animación opcional
      Stack(
        alignment: Alignment.center,
        children: [
          // Animación de confetti cuando el valor está en rango
          if (heartRateInRange)
            SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                'assets/lottiefiles/Confetti.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          // Icono principal
          Container(
            width: 30,
            height: 30,
            child: heartRateInRange
              ? SvgPicture.asset(
                  'assets/svgs/trofeo_points.svg',
                  width: 30,
                  height: 30,
                )
              : Icon(
                  DigimedIcon.alert,
                  color: Colors.orange,
                  size: 30,
                ),
          ),
        ],
      ),
      const SizedBox(width: 12),
      // Mensaje de texto
      Expanded(
        child: Text(
          message,
          style: AppTextStyle.grey13W500ContentTextStyle,
        ),
      ),
    ],
  );
}

/// Genera el mensaje de frecuencia cardíaca según el valor y el rol del usuario
String _generateHeartRateMessage(
  double heartRateValue,
  bool heartRateInRange,
  bool isPatientView
) {
  // Pronombres según el rol
  String subject = isPatientView ? "Tu" : "Su";
  String possessive = isPatientView ? "tu" : "su";
  String verb = isPatientView ? "has" : "ha";
  String imperative = isPatientView ? "Consulta" : "El paciente debe consultar";
  String recommendation = isPatientView ? "Mantente" : "Debe mantenerse";
  String action = isPatientView ? "Controla" : "Debe controlar";

  // Caso ideal: valor en rango
  if (heartRateInRange) {
    return "$subject $verb cumplido con ${isPatientView ? 'tu' : 'la'} meta y ${isPatientView ? 'te has' : 'se ha'} mantenido en la zona segura.";
  }

  // Análisis de frecuencia cardíaca fuera de rango
  if (heartRateValue < ValueRange.heartRateMin) {
    if (heartRateValue < 50) {
      return "$subject frecuencia cardíaca está muy baja (bradicardia severa). Es importante que ${imperative.toLowerCase()} con ${possessive} médico de inmediato.";
    } else {
      return "$subject frecuencia cardíaca está ligeramente baja. $recommendation con ${possessive} médico si persiste.";
    }
  } else {
    if (heartRateValue > 120) {
      return "$subject frecuencia cardíaca está muy elevada (taquicardia). Es importante que ${imperative.toLowerCase()} con ${possessive} médico.";
    } else if (heartRateValue > 100) {
      return "$subject frecuencia cardíaca está elevada. ${imperative} con ${possessive} médico y ${isPatientView ? 'reduce' : 'debe reducir'} el estrés y la cafeína.";
    } else {
      return "$subject frecuencia cardíaca está ligeramente alta. $action ${possessive} actividad física y ${isPatientView ? 'practica' : 'debe practicar'} técnicas de relajación.";
    }
  }
}

/// Widget que muestra un mensaje con icono para glucosa
/// según si el promedio está dentro de los rangos seguros
Widget getGlucoseMessageWidget(
  double glucoseValue,
  double? minSafeZone,
  double maxSafeZone,
  {bool isPatientView = true}
) {
  // Verificar si el valor está en rango normal
  bool inRange = (minSafeZone != null && glucoseValue >= minSafeZone && glucoseValue <= maxSafeZone) ||
                 (minSafeZone == null && glucoseValue <= maxSafeZone);

  // Generar mensaje según el valor y si está en rango
  String message = _generateGlucoseMessage(glucoseValue, minSafeZone, maxSafeZone, inRange, isPatientView);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icono con animación opcional
      Stack(
        alignment: Alignment.center,
        children: [
          // Animación de confetti cuando el valor está en rango
          if (inRange)
            SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                'assets/lottiefiles/Confetti.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          // Icono principal
          Container(
            width: 30,
            height: 30,
            child: inRange
              ? SvgPicture.asset(
                  'assets/svgs/trofeo_points.svg',
                  width: 30,
                  height: 30,
                )
              : Icon(
                  DigimedIcon.alert,
                  color: Colors.orange,
                  size: 30,
                ),
          ),
        ],
      ),
      const SizedBox(width: 12),
      // Mensaje de texto
      Expanded(
        child: Text(
          message,
          style: AppTextStyle.grey13W500ContentTextStyle,
        ),
      ),
    ],
  );
}

/// Genera el mensaje de glucosa según el valor y si está en rango
String _generateGlucoseMessage(
  double glucoseValue,
  double? minSafeZone,
  double maxSafeZone,
  bool inRange,
  bool isPatientView
) {
  // Pronombres según el rol
  String subject = isPatientView ? "Tu" : "Su";
  String possessive = isPatientView ? "tu" : "su";
  String verb = isPatientView ? "has" : "ha";
  String imperative = isPatientView ? "Consulta" : "El paciente debe consultar";

  // Caso ideal: valor en rango
  if (inRange) {
    return "$subject $verb cumplido con ${isPatientView ? 'tu' : 'la'} meta y ${isPatientView ? 'te has' : 'se ha'} mantenido en la zona segura.";
  }

  // Análisis de glucosa fuera de rango
  bool isHigh = glucoseValue > maxSafeZone;
  bool isLow = minSafeZone != null && glucoseValue < minSafeZone;

  if (isHigh) {
    if (glucoseValue > 180) {
      return "$subject nivel de glucosa está muy elevado. Es urgente que ${imperative.toLowerCase()} con ${possessive} médico de inmediato.";
    } else if (glucoseValue > 140) {
      return "$subject nivel de glucosa está elevado. ${imperative} con ${possessive} médico para evaluar el tratamiento.";
    } else {
      return "$subject nivel de glucosa está ligeramente alto. ${isPatientView ? 'Controla' : 'Debe controlar'} ${possessive} dieta y ${isPatientView ? 'haz' : 'debe hacer'} ejercicio.";
    }
  } else if (isLow) {
    if (glucoseValue < 60) {
      return "$subject nivel de glucosa está muy bajo. Es importante que consultes con tu médico de inmediato.";
    } else {
      return "$subject nivel de glucosa está bajo. ${imperative} con ${possessive} médico sobre ${possessive} alimentación y medicación.";
    }
  } else {
    return "$subject nivel de glucosa requiere atención. ${imperative} con ${possessive} médico para mantener niveles óptimos.";
  }
}

/// Widget que muestra un mensaje con icono para triglicéridos
/// según si el promedio está dentro de los rangos seguros
Widget getTriglyceridesMessageWidget(
  double triglyceridesValue,
  double maxSafeZone,
  {bool isPatientView = true}
) {
  // Verificar si el valor está en rango normal (solo hay máximo para triglicéridos)
  bool inRange = triglyceridesValue <= maxSafeZone;

  // Generar mensaje según el valor y si está en rango
  String message = _generateTriglyceridesMessage(triglyceridesValue, maxSafeZone, inRange, isPatientView);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icono con animación opcional
      Stack(
        alignment: Alignment.center,
        children: [
          // Animación de confetti cuando el valor está en rango
          if (inRange)
            SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                'assets/lottiefiles/Confetti.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          // Icono principal
          Container(
            width: 30,
            height: 30,
            child: inRange
              ? SvgPicture.asset(
                  'assets/svgs/trofeo_points.svg',
                  width: 30,
                  height: 30,
                )
              : Icon(
                  DigimedIcon.alert,
                  color: Colors.orange,
                  size: 30,
                ),
          ),
        ],
      ),
      const SizedBox(width: 12),
      // Mensaje de texto
      Expanded(
        child: Text(
          message,
          style: AppTextStyle.grey13W500ContentTextStyle,
        ),
      ),
    ],
  );
}

/// Genera el mensaje de triglicéridos según el valor y si está en rango
String _generateTriglyceridesMessage(
  double triglyceridesValue,
  double maxSafeZone,
  bool inRange,
  bool isPatientView
) {
  // Pronombres según el rol
  String subject = isPatientView ? "Tu" : "Su";
  String possessive = isPatientView ? "tu" : "su";
  String verb = isPatientView ? "has" : "ha";
  String imperative = isPatientView ? "Consulta" : "El paciente debe consultar";

  // Caso ideal: valor en rango
  if (inRange) {
    return "$subject nivel de triglicéridos está en rango normal y ${isPatientView ? 'has' : 'ha'} mantenido un buen control.";
  }

  // Análisis de triglicéridos fuera de rango (siempre alto, no hay mínimo)
  if (triglyceridesValue >= 500) {
    return "$subject nivel de triglicéridos está muy alto. Es urgente que ${imperative.toLowerCase()} con ${possessive} médico de inmediato para tratamiento.";
  } else if (triglyceridesValue >= 200) {
    return "$subject nivel de triglicéridos está alto. ${imperative} con ${possessive} médico para evaluar cambios en la dieta y posible medicación.";
  } else {
    // Entre 150-199 (límite alto)
    return "$subject nivel de triglicéridos está en el límite. ${isPatientView ? 'Mejora' : 'Debe mejorar'} ${possessive} dieta y ${isPatientView ? 'haz' : 'debe hacer'} más ejercicio.";
  }
}

/// Widget que muestra un mensaje con icono para colesterol
/// según si el promedio está dentro de los rangos seguros
Widget getCholesterolMessageWidget(
  double cholesterolValue,
  double maxSafeZone,
  {bool isPatientView = true}
) {
  // Verificar si el valor está en rango normal (solo hay máximo para colesterol)
  bool inRange = cholesterolValue <= maxSafeZone;

  // Generar mensaje según el valor y si está en rango
  String message = _generateCholesterolMessage(cholesterolValue, maxSafeZone, inRange, isPatientView);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icono con animación opcional
      Stack(
        alignment: Alignment.center,
        children: [
          // Animación de confetti cuando el valor está en rango
          if (inRange)
            SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                'assets/lottiefiles/Confetti.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          // Icono principal
          Container(
            width: 30,
            height: 30,
            child: inRange
              ? SvgPicture.asset(
                  'assets/svgs/trofeo_points.svg',
                  width: 30,
                  height: 30,
                )
              : Icon(
                  DigimedIcon.alert,
                  color: Colors.orange,
                  size: 30,
                ),
          ),
        ],
      ),
      const SizedBox(width: 12),
      // Mensaje de texto
      Expanded(
        child: Text(
          message,
          style: AppTextStyle.grey13W500ContentTextStyle,
        ),
      ),
    ],
  );
}

/// Genera el mensaje de colesterol según el valor y si está en rango
String _generateCholesterolMessage(
  double cholesterolValue,
  double maxSafeZone,
  bool inRange,
  bool isPatientView
) {
  // Pronombres según el rol
  String subject = isPatientView ? "Tu" : "Su";
  String possessive = isPatientView ? "tu" : "su";
  String verb = isPatientView ? "has" : "ha";
  String imperative = isPatientView ? "Consulta" : "El paciente debe consultar";

  // Caso ideal: valor en rango
  if (inRange) {
    return "$subject nivel de colesterol está en rango normal y ${isPatientView ? 'has' : 'ha'} mantenido un buen control cardiovascular.";
  }

  // Análisis de colesterol fuera de rango (siempre alto, no hay mínimo)
  if (cholesterolValue >= 300) {
    return "$subject nivel de colesterol está muy alto. Es urgente que ${imperative.toLowerCase()} con ${possessive} médico de inmediato para tratamiento.";
  } else if (cholesterolValue >= 250) {
    return "$subject nivel de colesterol está alto. ${imperative} con ${possessive} médico para evaluar cambios en la dieta y posible medicación.";
  } else {
    // Entre el límite máximo y 250
    return "$subject nivel de colesterol está ligeramente elevado. ${isPatientView ? 'Mejora' : 'Debe mejorar'} ${possessive} dieta y ${isPatientView ? 'haz' : 'debe hacer'} más ejercicio.";
  }
}

/// Widget que muestra un mensaje con icono para hemoglobina
/// según si el promedio está dentro de los rangos seguros
Widget getHemoglobinMessageWidget(
  double hemoglobinValue,
  double minSafeZone,
  double maxSafeZone,
  {bool isPatientView = true}
) {
  // Verificar si el valor está en rango normal
  bool inRange = hemoglobinValue >= minSafeZone && hemoglobinValue <= maxSafeZone;

  // Generar mensaje según el valor y si está en rango
  String message = _generateHemoglobinMessage(hemoglobinValue, minSafeZone, maxSafeZone, inRange, isPatientView);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icono con animación opcional
      Stack(
        alignment: Alignment.center,
        children: [
          // Animación de confetti cuando el valor está en rango
          if (inRange)
            SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                'assets/lottiefiles/Confetti.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          // Icono principal
          Container(
            width: 30,
            height: 30,
            child: inRange
              ? SvgPicture.asset(
                  'assets/svgs/trofeo_points.svg',
                  width: 30,
                  height: 30,
                )
              : Icon(
                  DigimedIcon.alert,
                  color: Colors.orange,
                  size: 30,
                ),
          ),
        ],
      ),
      const SizedBox(width: 12),
      // Mensaje de texto
      Expanded(
        child: Text(
          message,
          style: AppTextStyle.grey13W500ContentTextStyle,
        ),
      ),
    ],
  );
}

/// Genera el mensaje de hemoglobina según el valor y si está en rango
String _generateHemoglobinMessage(
  double hemoglobinValue,
  double minSafeZone,
  double maxSafeZone,
  bool inRange,
  bool isPatientView
) {
  // Pronombres según el rol
  String subject = isPatientView ? "Tu" : "Su";
  String possessive = isPatientView ? "tu" : "su";
  String verb = isPatientView ? "has" : "ha";
  String imperative = isPatientView ? "Consulta" : "El paciente debe consultar";

  // Caso ideal: valor en rango
  if (inRange) {
    return "$subject $verb cumplido con ${isPatientView ? 'tu' : 'la'} meta y ${isPatientView ? 'te has' : 'se ha'} mantenido en la zona segura.";
  }

  // Análisis de hemoglobina fuera de rango
  bool isHigh = hemoglobinValue > maxSafeZone;
  bool isLow = hemoglobinValue < minSafeZone;

  if (isLow) {
    if (hemoglobinValue < (minSafeZone - 2)) {
      return "$subject hemoglobina está muy baja. Es importante que ${imperative.toLowerCase()} con ${possessive} médico de inmediato para evaluar anemia.";
    } else {
      return "$subject hemoglobina está ligeramente baja. ${imperative} con ${possessive} médico sobre suplementos de hierro.";
    }
  } else if (isHigh) {
    if (hemoglobinValue > (maxSafeZone + 2)) {
      return "$subject hemoglobina está muy elevada. ${imperative} con ${possessive} médico para descartar problemas de salud.";
    } else {
      return "$subject hemoglobina está ligeramente alta. ${isPatientView ? 'Mantente' : 'Debe mantenerse'} hidratado y ${imperative.toLowerCase()} con ${possessive} médico.";
    }
  }

  return "$subject hemoglobina necesita atención médica.";
}
