import 'dart:ffi';
import 'dart:io';

import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/assessment_input/assessment_input.dart';
import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/domain/models/doctor_user_points_hours/doctor_user_points_hours.dart';
import 'package:digimed/app/domain/models/item_doctors/item_doctors.dart';
import 'package:digimed/app/domain/models/location_input/location_input.dart';
import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:digimed/app/domain/models/medical_history/medical_history.dart';
import 'package:digimed/app/domain/models/medical_specialty/medical_specialty.dart';
import 'package:digimed/app/domain/models/patient_home/patient_home.dart';
import 'package:digimed/app/domain/models/patients/patients.dart';
import 'package:digimed/app/domain/models/plan_input/plan_input.dart';
import 'package:digimed/app/domain/models/profile_cardio_input/profile_cardio_input.dart';
import 'package:digimed/app/domain/models/profile_cardiovascular/profile_cardiovascular.dart';
import 'package:digimed/app/domain/models/profile_lab_input/profile_lab_input.dart';
import 'package:digimed/app/domain/models/profile_laboratory/profile_laboratory.dart';
import 'package:digimed/app/domain/models/profile_laboratory_edit_input/profile_laboratory_edit_input.dart';
import 'package:digimed/app/domain/models/recipe/recipe.dart';
import 'package:digimed/app/domain/models/recipe_input/recipe_input.dart';
import 'package:digimed/app/domain/models/report/report.dart';
import 'package:digimed/app/domain/models/report_input/report_input.dart';
import 'package:digimed/app/domain/models/soap_note/soap_note.dart';
import 'package:digimed/app/domain/models/upload_followed_up_method_input/upload_followed_up_method_input.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/models/user_input/user_input.dart';
import 'package:digimed/app/domain/models/verification_input/verification_input.dart';
import 'package:digimed/app/domain/models/verification_response/verification_response.dart';
import 'package:digimed/app/domain/models/working_hours_input/working_hours_input.dart';

import '../models/activity/activity.dart';
import '../models/input_soap/input_soap.dart';

abstract class AccountRepository {
  Future<User?> getUserData();

  Future<Either<HttpRequestFailure, void>> setUser();

  Future<Either<HttpRequestFailure, List<ItemDoctors>>> getAdminListDoctors();

  Future<Either<HttpRequestFailure, bool>> registerDoctor(
      UserInput doctor, File? image);

  Future<Either<HttpRequestFailure, bool>> registerPatient(
      UserInput patient, int doctorID, File? image);

  Future<Either<HttpRequestFailure, Doctor>> getDoctorData(int idDoctor);

  Future<Either<HttpRequestFailure, DoctorUserPointsHours>>
      getDoctorWithPointsAndHours(int idDoctor);

  Future<Either<HttpRequestFailure, List<Patients>>> getAdminListPatients(
      int userID);

  Future<Either<HttpRequestFailure, Patients>> getPatientData(int patientId);

  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>> getResultsLabs(
      int patientId, String range);

  Future<Either<HttpRequestFailure, List<ProfileCardiovascular>?>>
      getDataBloodPressure(int patientId, String range);

  Future<Either<HttpRequestFailure, List<ProfileCardiovascular>?>>
      getDataHeartFrequency(int patientId, String range);

  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>> getDataGlucose(
      int patientId, String range);

  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>>
      getDataTriglycerides(int patientId, String range);

  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>>
      getDataCholesterol(int patientId, String range);

  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>>
      getDataHemoglobin(int patientId, String range);

  Future<Either<HttpRequestFailure, Doctor>> getMeDoctor(User user);

  Future<Either<HttpRequestFailure, Patients?>> getMePatient(User user);

  Future<Either<HttpRequestFailure, Doctor?>> getMyDoctorData(int userID);

  Future<Either<HttpRequestFailure, bool>> setDataBasic(
      UserDataInput userDataInput, int userID);

  Future<Either<HttpRequestFailure, bool>> upLoadHistoricMedical(
      MedicalHistory medicalHistoryInput, int patientID);

  Future<Either<HttpRequestFailure, bool>> upLoadFollowedMethod(
      UploadFollowedUpMethodInput input);

  Future<Either<HttpRequestFailure, bool>> completeStep2Doctor(
      UserDataInput userDataInput, int userID, int doctorId);

  Future<Either<HttpRequestFailure, bool>> completeStep1Doctor(
      String newPassword, int userID, int doctorId);

  Future<Either<HttpRequestFailure, bool>> goToStepDoctor(
      int userID, int step, int doctorId);

  Future<Either<HttpRequestFailure, bool>> createNewProfileLab(
      ProfileLabInput input, int doctorID);

  Future<Either<HttpRequestFailure, bool>> goToStepPatient(
      int step, int patientId);

  Future<Either<HttpRequestFailure, bool>> acceptContractPatient(int patientID);

  Future<Either<HttpRequestFailure, bool>> acceptContractDoctor(int doctorID);

  Future<Either<HttpRequestFailure, bool>> completeStep1Patient(
      String newPassword, int userID, int patientId);

  Future<Either<HttpRequestFailure, bool>> completeStep2Patient(
      UserDataInput userDataInput, int userID, int patientId);

  Future<Either<HttpRequestFailure, bool>> createNewProfileCardio(
      ProfileCardioInput input, int patientID, int doctorID);

  Future<Either<HttpRequestFailure, List<Activity>>> getMyActivitys(int userID);

  Future<Either<HttpRequestFailure, List<Activity>>> getMyActivitysDoctor(
      int userID);

  Future<Either<HttpRequestFailure, String>> uploadImage(
      File image, int userID);

  Future<Either<HttpRequestFailure, bool>> upDateWorkingHours(
      WorkingHoursInput input);

  Future<Either<HttpRequestFailure, bool>> recordNewLocation(
      LocationInput input);

  Future<Either<HttpRequestFailure, String?>> getMeUrlImage();

  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteS(InputSOAP input);

  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteO(InputSOAP input);

  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteA(InputSOAP input);

  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteP(InputSOAP input);

  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteS(
      int userID, String rangeTime);

  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteO(
      int userID, String rangeTime);

  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteA(
      int userID, String rangeTime);

  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteP(
      int userID, String rangeTime);

  Future<Either<HttpRequestFailure, List<MedicalCenter>>> medicalCenter();

  Future<Either<HttpRequestFailure, List<User>>> medicalCenterCoordinator(
      int medicalCenterId);

  // Future<Either<HttpRequestFailure, List<DoctorSpecialists>>>
  //     getAdminListDoctorsSpecialist();

  Future<Either<HttpRequestFailure, List<DoctorSpecialists>>>
      getListDoctorsSpecialist(int medicalCenterID, int specialtyID);

  Future<Either<HttpRequestFailure, List<MedicalSpecialty>>>
      medicalSpecialties();

  Future<Either<HttpRequestFailure, bool>> assignSpecialist(
      int patientID, int doctorID);

  Future<Either<HttpRequestFailure, List<DoctorSpecialists>>>
      doctorSpecialitsPatient(int patientId);

  Future<Either<HttpRequestFailure, List<int>>> medicalCenterIdForCordinator(
      int userID);

  Future<Either<HttpRequestFailure, List<ItemDoctors>>>
      getCordinatorListDoctors(
    List<int> listIdMedicalCenters,
  );

  Future<Either<HttpRequestFailure, List<ItemDoctors>>>
      getAdminCoordinatorListDoctors(int medicalCenterID);

  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>> getDataUricAcid(
      int patientId, String range);

  Future<Either<HttpRequestFailure, String>> healthSummary(int patientId);

  Future<Either<HttpRequestFailure, String>> getPatientMedicalHistoryAnalysis(
      int patientId);

  Future<Either<HttpRequestFailure, String>> getIAAssessment(
      AssessmentInput input);

  Future<Either<HttpRequestFailure, String>> getIAPlan(PlanInput input);

  Future<Either<HttpRequestFailure, List<Report>>> getReportsByPatientID(
      int patientId, String range);

  Future<Either<HttpRequestFailure, List<Report>>> getReportsByPatientID2(
      int patientId, String range);

  Future<Either<HttpRequestFailure, String>> createReport(ReportInput input);

  Future<Either<HttpRequestFailure, String>> getReportBase64(int reportID);

  Future<Either<HttpRequestFailure, VerificationResponse>>
      getTreatmentVerification(VerificationInput input);

  Future<Either<HttpRequestFailure, String>> createPrescription(
      RecipeInput input);

  Future<Either<HttpRequestFailure, List<Recipe>>> getPrescriptionByPatientID(
      int patientId, String range);

  Future<Either<HttpRequestFailure, String>> getRecipeBase64(int recipeID);

  Future<Either<HttpRequestFailure, ProfileLaboratory?>> updateResultsLabs(
      ProfileLaboratoryEditInput item, int profileId);

  Future<Either<HttpRequestFailure, bool?>> markReadNotification(
      int notificationId);

  Future<Either<HttpRequestFailure, bool?>> updateTreatment(
      int idTreatment, String status);
}
