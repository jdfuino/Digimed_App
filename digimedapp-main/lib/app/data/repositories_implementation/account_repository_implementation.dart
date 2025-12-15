import 'dart:io';

import 'package:digimed/app/data/providers/data_test/data_test.dart';
import 'package:digimed/app/data/providers/local/session_service.dart';
import 'package:digimed/app/data/providers/remote/account_api.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/activity/activity.dart';
import 'package:digimed/app/domain/models/assessment_input/assessment_input.dart';
import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/domain/models/doctor_user_points_hours/doctor_user_points_hours.dart';
import 'package:digimed/app/domain/models/input_soap/input_soap.dart';
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
import 'package:digimed/app/domain/repositories/accountRepository.dart';

class AccountRepositoryImplementation implements AccountRepository {
  AccountRepositoryImplementation(this._accountAPI, this._sessionService);

  final AccountAPI _accountAPI;
  final SessionService _sessionService;

  @override
  Future<User?> getUserData() async {
    final user =
        await _accountAPI.getAccount(await _sessionService.sessionId ?? '');
    return user;
  }

  @override
  Future<Either<HttpRequestFailure, void>> setUser() {
    // TODO: implement setUser
    throw UnimplementedError();
  }

  @override
  Future<Either<HttpRequestFailure, List<ItemDoctors>>> getAdminListDoctors() {
    return _accountAPI.getAdminListDoctors();
  }

  @override
  Future<Either<HttpRequestFailure, Doctor>> getDoctorData(int idDoctor) {
    return _accountAPI.getDoctorData(idDoctor);
  }

  @override
  Future<Either<HttpRequestFailure, List<Patients>>> getAdminListPatients(
      int userID) {
    return _accountAPI.getAdminListPatients(userID);
  }

  @override
  Future<Either<HttpRequestFailure, Patients>> getPatientData(int patientId) {
    return _accountAPI.getPatientData(patientId);
  }

  @override
  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>> getResultsLabs(
      int patientId, String range) {
    return _accountAPI.getResultsLabs(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, List<ProfileCardiovascular>?>>
      getDataBloodPressure(int patientId, String range) {
    return _accountAPI.getDataProfileCardiovascular(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>>
      getDataCholesterol(int patientId, String range) {
    return _accountAPI.getResultsLabs(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>> getDataGlucose(
      int patientId, String range) {
    return _accountAPI.getResultsLabs(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, List<ProfileCardiovascular>?>>
      getDataHeartFrequency(int patientId, String range) {
    return _accountAPI.getDataProfileCardiovascular(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>>
      getDataHemoglobin(int patientId, String range) {
    return _accountAPI.getResultsLabs(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>>
      getDataTriglycerides(int patientId, String range) {
    return _accountAPI.getResultsLabs(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, Doctor>> getMeDoctor(User user) {
    return _accountAPI.getMeDoctor(user);
  }

  @override
  Future<Either<HttpRequestFailure, Patients?>> getMePatient(User user) {
    return _accountAPI.getMePatient(user);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> registerDoctor(
      UserInput doctor, File? image) {
    return _accountAPI.registerDoctor(doctor, image);
  }

  @override
  Future<Either<HttpRequestFailure, DoctorUserPointsHours>>
      getDoctorWithPointsAndHours(int idDoctor) {
    return _accountAPI.getDoctorUserPointsHours(idDoctor);
  }

  @override
  Future<Either<HttpRequestFailure, Doctor?>> getMyDoctorData(int userID) {
    return _accountAPI.getMyDoctor(userID);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> setDataBasic(
      UserDataInput userDataInput, int userID) {
    return _accountAPI.setUserData(userDataInput, userID);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> registerPatient(
      UserInput patient, int doctorID, File? image) {
    return _accountAPI.registerPatient(patient, doctorID, image);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> upLoadHistoricMedical(
      MedicalHistory medicalHistoryInput, int patientID) {
    return _accountAPI.upLoadHistoricMedical(medicalHistoryInput, patientID);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> upLoadFollowedMethod(
      UploadFollowedUpMethodInput input) {
    return _accountAPI.uploadFollowedMethod(input);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> completeStep2Doctor(
      UserDataInput userDataInput, int userID, int doctorId) {
    return _accountAPI.completeStep2Doctor(userDataInput, userID, doctorId);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> completeStep1Doctor(
      String newPassword, int userID, int doctorId) {
    return _accountAPI.completeStep1Doctor(newPassword, userID, doctorId);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> goToStepDoctor(
      int userID, int step, int doctorId) {
    return _accountAPI.goToStepDoctor(userID, step, doctorId);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> createNewProfileLab(
      ProfileLabInput input, int doctorID) {
    return _accountAPI.createNewProfileLab(input, doctorID);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> acceptContractPatient(
      int patientID) {
    return _accountAPI.acceptContractPatient(patientID);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> goToStepPatient(
      int step, int patientId) {
    return _accountAPI.goToStepPatient(step, patientId);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> completeStep1Patient(
      String newPassword, int userID, int patientId) {
    return _accountAPI.completeStep1Patient(newPassword, userID, patientId);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> completeStep2Patient(
      UserDataInput userDataInput, int userID, int patientId) {
    return _accountAPI.completeStep2Patient(userDataInput, userID, patientId);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> createNewProfileCardio(
      ProfileCardioInput input, int patientID, int doctorID) {
    return _accountAPI.createNewProfileCardio(input, patientID, doctorID);
  }

  @override
  Future<Either<HttpRequestFailure, List<Activity>>> getMyActivitys(
      int userID) {
    return _accountAPI.getMyActivitys(userID);
  }

  @override
  Future<Either<HttpRequestFailure, List<Activity>>> getMyActivitysDoctor(
      int userID) {
    return _accountAPI.getMyActivitysDoctor(userID);
  }

  @override
  Future<Either<HttpRequestFailure, String>> uploadImage(
      File image, int userID) {
    return _accountAPI.uploadImage(image, userID);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> upDateWorkingHours(
      WorkingHoursInput input) {
    return _accountAPI.upDateWorkingHours(input);
  }

  @override
  Future<Either<HttpRequestFailure, bool>> recordNewLocation(
      LocationInput input) {
    return _accountAPI.recordNewLocation(input);
  }

  @override
  Future<Either<HttpRequestFailure, String?>> getMeUrlImage() {
    return _accountAPI.getMeUrlImage();
  }

  @override
  Future<Either<HttpRequestFailure, bool>> acceptContractDoctor(int doctorID) {
    return _accountAPI.acceptContractDoctor(doctorID);
  }

  @override
  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteS(
      InputSOAP input) {
    return _accountAPI.recordNewNoteS(input);
  }

  @override
  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteA(
      InputSOAP input) {
    return _accountAPI.recordNewNoteA(input);
  }

  @override
  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteO(
      InputSOAP input) {
    return _accountAPI.recordNewNoteO(input);
  }

  @override
  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteP(
      InputSOAP input) {
    return _accountAPI.recordNewNoteP(input);
  }

  @override
  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteA(
      int userID, String rangeTime) {
    return _accountAPI.getSoapNoteA(userID, rangeTime);
  }

  @override
  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteO(
      int userID, String rangeTime) {
    return _accountAPI.getSoapNoteO(userID, rangeTime);
  }

  @override
  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteP(
      int userID, String rangeTime) {
    return _accountAPI.getSoapNoteP(userID, rangeTime);
  }

  @override
  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteS(
      int userID, String rangeTime) {
    return _accountAPI.getSoapNoteS(userID, rangeTime);
  }

  @override
  Future<Either<HttpRequestFailure, List<MedicalCenter>>> medicalCenter() {
    return _accountAPI.medicalCenter();
  }

  @override
  Future<Either<HttpRequestFailure, List<User>>> medicalCenterCoordinator(
      int medicalCenterId) {
    return _accountAPI.medicalCenterCoordinator(medicalCenterId);
  }

  // @override
  // Future<Either<HttpRequestFailure, List<DoctorSpecialists>>>
  //     getAdminListDoctorsSpecialist() {
  //   return _accountAPI.getAdminListDoctorsSpecialist();
  // }

  @override
  Future<Either<HttpRequestFailure, List<DoctorSpecialists>>>
      getListDoctorsSpecialist(int medicalCenterID, int specialtyID) {
    return _accountAPI.getListDoctorsSpecialist(medicalCenterID, specialtyID);
  }

  @override
  Future<Either<HttpRequestFailure, List<MedicalSpecialty>>>
      medicalSpecialties() {
    return _accountAPI.medicalSpecialties();
  }

  @override
  Future<Either<HttpRequestFailure, bool>> assignSpecialist(
      int patientID, int doctorID) {
    return _accountAPI.assignSpecialist(patientID, doctorID);
  }

  @override
  Future<Either<HttpRequestFailure, List<DoctorSpecialists>>>
      doctorSpecialitsPatient(int patientId) {
    return _accountAPI.doctorSpecialitsPatient(patientId);
  }

  @override
  Future<Either<HttpRequestFailure, List<int>>> medicalCenterIdForCordinator(
      int userID) {
    return _accountAPI.medicalCenterIdForCordinator(userID);
  }

  @override
  Future<Either<HttpRequestFailure, List<ItemDoctors>>>
      getCordinatorListDoctors(List<int> listIdMedicalCenters) {
    return _accountAPI.getCordinatorListDoctors(listIdMedicalCenters);
  }

  @override
  Future<Either<HttpRequestFailure, List<ItemDoctors>>>
      getAdminCoordinatorListDoctors(int medicalCenterID) {
    return _accountAPI.getAdminCoordinatorListDoctors(medicalCenterID);
  }

  @override
  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>> getDataUricAcid(
      int patientId, String range) {
    return _accountAPI.getResultsLabs(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, String>> getPatientMedicalHistoryAnalysis(
      int patientId) {
    return _accountAPI.getPatientMedicalHistoryAnalysis(patientId);
  }

  @override
  Future<Either<HttpRequestFailure, String>> healthSummary(int patientId) {
    return _accountAPI.healthSummary(patientId);
  }

  @override
  Future<Either<HttpRequestFailure, String>> getIAAssessment(
      AssessmentInput input) {
    return _accountAPI.getIAAssessment(input);
  }

  @override
  Future<Either<HttpRequestFailure, String>> getIAPlan(PlanInput input) {
    return _accountAPI.getIAPlan(input);
  }

  @override
  Future<Either<HttpRequestFailure, List<Report>>> getReportsByPatientID(
      int patientId, String range) {
    return _accountAPI.getReportsByPatientID(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, String>> createReport(ReportInput input) {
    return _accountAPI.createReportServer(input);
  }

  @override
  Future<Either<HttpRequestFailure, String>> getReportBase64(int input) {
    return _accountAPI.getReportBase64(input);
  }

  @override
  Future<Either<HttpRequestFailure, List<Report>>> getReportsByPatientID2(
      int patientId, String range) {
    return _accountAPI.getReportsByPatientID2(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, String>> createPrescription(
      RecipeInput input) {
    return _accountAPI.createPrescription(input);
  }

  @override
  Future<Either<HttpRequestFailure, List<Recipe>>> getPrescriptionByPatientID(
      int patientId, String range) {
    return _accountAPI.getPrescriptionByPatientID(patientId, range);
  }

  @override
  Future<Either<HttpRequestFailure, VerificationResponse>>
      getTreatmentVerification(VerificationInput input) {
    return _accountAPI.getTreatmentVerification(input);
  }

  @override
  Future<Either<HttpRequestFailure, String>> getRecipeBase64(int recipeID) {
    return _accountAPI.getRecipeBase64(recipeID);
  }

  @override
  Future<Either<HttpRequestFailure, ProfileLaboratory?>> updateResultsLabs(
      ProfileLaboratoryEditInput item, int profileId) {
    return _accountAPI.updateResultsLabs(item, profileId);
  }

  @override
  Future<Either<HttpRequestFailure, bool?>> markReadNotification(
      int notificationId) {
    return _accountAPI.markReadNotification(notificationId);
  }

  @override
  Future<Either<HttpRequestFailure, bool?>> updateTreatment(
      int idTreatment, String status) {
    return _accountAPI.updateTreatment(idTreatment, status);
  }
}
