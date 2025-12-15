import 'dart:async';
import 'dart:io';

import 'package:digimed/app/data/http/grapgh_ql_digimed.dart';
import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/data/providers/local/session_service.dart';
import 'package:digimed/app/data/providers/utils/handle_failure.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/globals/logger.dart';
import 'package:digimed/app/domain/models/activity/activity.dart';
import 'package:digimed/app/domain/models/activity_input/activity_input.dart';
import 'package:digimed/app/domain/models/assessment_input/assessment_input.dart';
import 'package:digimed/app/domain/models/coordinador_medical_center/coordinator_medical_center.dart';
import 'package:digimed/app/domain/models/doctor/doctor.dart';
import 'package:digimed/app/domain/models/doctor_specialist/doctor_specialist.dart';
import 'package:digimed/app/domain/models/doctor_user_points_hours/doctor_user_points_hours.dart';
import 'package:digimed/app/domain/models/input_soap/input_soap.dart';
import 'package:digimed/app/domain/models/item_doctors/item_doctors.dart';
import 'package:digimed/app/domain/models/last_soap/last_soap.dart';
import 'package:digimed/app/domain/models/location_input/location_input.dart';
import 'package:digimed/app/domain/models/medical_center/medical_center.dart';
import 'package:digimed/app/domain/models/medical_history/medical_history.dart';
import 'package:digimed/app/domain/models/medical_specialty/medical_specialty.dart';
import 'package:digimed/app/domain/models/notification_model/notification_model.dart';
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
import 'package:digimed/app/domain/models/treatment/treatment.dart';
import 'package:digimed/app/domain/models/upload_followed_up_method_input/upload_followed_up_method_input.dart';
import 'package:digimed/app/domain/models/uric_acid_fake/uric_acid_fake.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/models/user_input/user_input.dart';
import 'package:digimed/app/domain/models/verification_input/verification_input.dart';
import 'package:digimed/app/domain/models/verification_response/verification_response.dart';
import 'package:digimed/app/domain/models/working_hours_input/working_hours_input.dart';
import 'package:digimed/app/presentation/utils/utils.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../data_test/data_test.dart';

class AccountAPI {
  AccountAPI(this._http, this._sessionService, this._graphQLDigimed);

  final Http _http;
  final SessionService _sessionService;
  final GraphQLDigimed _graphQLDigimed;

  Future<User?> getAccount(String sessionId) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final userData = data["me"] as Map<String, dynamic>;

            // Ahora podemos usar directamente User.fromJson sin parseo manual
            final user = User.fromJson(userData);
            return user;
          } catch (e) {
            logger.e("request ME: ${e.toString()}");
            return null;
          }
        },
        body: '''query Me {
        me {
          id,
          full_name,
          role,
          identification_type,
          identification_number,
          email,
          phone_number,
          country_code,
          ocupation,
          fcm_token,
          notifications{
          id,
          title,
          body,
          data,
          category,
          read,
          },
          birthday,
          created_at,
          updated_at,
        }
      }''');
    return result.when(
      left: (_) => null,
      right: (user) {
        logger.i("Notificaciones parseadas: ${user!.notifications.length}");
        return user;
      },
    );
  }

  Future<Either<HttpRequestFailure, String?>> getMeUrlImage() async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            return data["me"]["profile_img_url"] as String;
          } catch (e) {
            return null;
          }
        },
        body: '''
        query Me {
          me {
            profile_img_url
          }
        }
        ''');
    return result.when(
        left: handleHttpFailure, right: (url) => Either.right(url));
  }

  Future<Either<HttpRequestFailure, List<ItemDoctors>>>
      getAdminListDoctors() async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final list = json["doctors"] as List;
          final iterable = list.map((e) => ItemDoctors.fromJson(e)).toList();
          return iterable;
        },
        body: '''
    query doctors{
          doctors{
        User{
          id
          full_name
          gender
          identification_type
          identification_number
          profile_img_url
        }
        PatientsCount
      }
    }''');
    return result.when(
        left: handleHttpFailure, right: (list) => Either.right(list));
  }

  Future<Either<HttpRequestFailure, DoctorUserPointsHours>>
      getDoctorUserPointsHours(int userID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final doctor = DoctorUserPointsHours.fromJson(json["doctorProfile"]);
          return doctor;
        },
        body: '''
      query doctorProfile{
        doctorProfile(userId:$userID){
          ID
          TotalScore
          User{
            id
            full_name
            gender
            identification_type
            identification_number
            birthday
            email
            country_code
            phone_number
            ocupation
            profile_img_url
            role
          }
          WorkingHour{
            ID
            Tag
            DayOfWeek
            StartHour0
            StopHour0
            StartHour1
            StopHour1
          }
        }
      }
      ''');
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, Doctor>> getDoctorData(int idDoctor) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final result = json["doctorProfile"];
          Doctor myDoctor = Doctor.fromJson(result);
          return myDoctor;
        },
        body: '''
    query doctorProfile{
        doctorProfile(userId:$idDoctor){
          ID
          TotalScore
          User{
            id
            full_name
            gender
            identification_type
            identification_number
            birthday
            email
            country_code
            phone_number
            ocupation
            profile_img_url
            role
          }
          WorkingHour{
            ID
            Tag
            DayOfWeek
            StartHour0
            StopHour0
            StartHour1
            StopHour1
          }
        }
      }
    ''');
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, List<Patients>>> getAdminListPatients(
      int userID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final list = json["doctorProfile"]["Patients"] as List;
          final iterable = list.map((e) {
            ProfileCardiovascular? profileCardiovascular;
            ProfileLaboratory? profileLaboratory;
            if (e["Patient"] != null) {
              try {
                profileCardiovascular = ProfileCardiovascular.fromJson(
                    e["Patient"]["ProfileCardiovascular"]["Latest"]);
              } catch (_) {}
              try {
                profileLaboratory = ProfileLaboratory.fromJson(
                    e["Patient"]["ProfileLaboratory"]["Latest"]);
              } catch (_) {}
            }
            return Patients(
                patientID: e["Patient"]["ID"],
                user: User.fromJson(e["User"]),
                profileCardiovascular: profileCardiovascular,
                profileLaboratory: profileLaboratory);
          }).toList();
          return iterable;
        },
        body: '''
            query doctorProfile{
        doctorProfile(userId:$userID){
          Patients{
            User{
              id
              full_name
              identification_type
              identification_number
              birthday
              gender
              email
              country_code
              phone_number
              ocupation
              profile_img_url
              role
            }
            Patient{
              ID
              ProfileCardiovascular{
                Latest{
                  id
                  SystolicPressure
                  DiastolicPressure
                  HeartRate
                  SleepHours
                  created_at
                }
              }
              ProfileLaboratory{
                Latest{
                  id
                  Glucose
                  Triglycerides
                  Cholesterol
                  Hemoglobin
                  UricAcid
                  created_at
                }
              }
            }
          }
        }
      }  
      ''');
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, Patients>> getPatientData(
      int userID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final e = json["patientProfile"];
          ProfileCardiovascular? profileCardiovascular;
          ProfileLaboratory? profileLaboratory;
          MedicalHistory? medicalHistory;
          List<String>? listFollowed;
          if (e["Patient"] != null) {
            try {
              profileCardiovascular = ProfileCardiovascular.fromJson(
                  e["Patient"]["ProfileCardiovascular"]["Latest"]);
            } catch (_) {
              print("error parciando el ProfileCardiovascular");
            }
            try {
              profileLaboratory = ProfileLaboratory.fromJson(
                  e["Patient"]["ProfileLaboratory"]["Latest"]);
            } catch (_) {
              print("error parciando el ProfileLaboratory");
            }
            try {
              medicalHistory =
                  MedicalHistory.fromJson(e["Patient"]["MedicalHistory"]);
            } catch (_) {
              medicalHistory = const MedicalHistory();
            }
            final list = e["Patient"]["FollowUpMethod"] as List?;
            listFollowed = list?.map((e) => e.toString()).toList();
          }
          return Patients(
              patientID: e["Patient"]["ID"],
              user: User.fromJson(e["User"]),
              followUpMethod: listFollowed,
              profileCardiovascular: profileCardiovascular,
              profileLaboratory: profileLaboratory,
              medicalHistory: medicalHistory,
              meDoctorID: e["Patient"]["Doctor"]["ID"] == null
                  ? 1
                  : e["Patient"]["Doctor"]["ID"] as int,
              lastSoap: e["Patient"]["LatestSOAPNote"] == null
                  ? null
                  : LastSOAP.fromJson(e["Patient"]["LatestSOAPNote"]));
        },
        body: '''
      query patientProfile{
      patientProfile(userId: $userID){
          User{
            id
            full_name
            gender
            identification_type
            identification_number
            birthday
            email
            country_code
            phone_number
            ocupation
            profile_img_url
            role
            weight
            height
          }
          Patient{
            ID
            FollowUpMethod
            ProfileCardiovascular{
              Latest{
                id
                SystolicPressure
                DiastolicPressure
                HeartRate
                SleepHours
                created_at
              }
            }
            ProfileLaboratory{
              Latest{
                id
                Glucose
                Triglycerides
                Cholesterol
                Hemoglobin
                UricAcid
                created_at
              }
            }
            MedicalHistory{
              HasCardiovacularProblems
              HasCancerProblems
              HasDiabeticsProblems
              HasObesityProblems
              HasRespiratoryProblems
              HasMentalProblems
              HasFrequentFluProblems
              HaveRelativesCardiovascularProblems
              HaveRelativesCancerProblems
              HaveRelativesDiabeticsProblems
              HaveRelativesObesityProblems
              HaveRelativesRespiratoryProblems
              HaveRelativesMentalProblems
              HasDrinkingHabit
              HasSmokingHabit
              HasDrinkingCaffeineHabit
              HasMedication
              HasFitnessHabit
              HasEatingAfterHoursHabit
              ConsumeCannedFood,
              ConsumeSugaryFood,
              ConsumeSaturedFood,
              ConsumeHighlySeasonedFoods
              ConsumePreparedFoods,
              SatisfiedWithJob,
              HavePersonalGoals,
              HaveAccessEssentialService,
              HaveProperties,
              HaveProblemEnviromentalContamination
            }
            Doctor{
              ID
            }
            LatestSOAPNote{
              Subjective{
                Note
                LastUpdatedAt
              }
              Objective{
                Note
                LastUpdatedAt
              }
              Assessment{
                Note
                LastUpdatedAt
              }
              Plan{
                Note
                LastUpdatedAt
              }
            }
          }
        }
      }
      ''');
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, List<ProfileLaboratory>?>> getResultsLabs(
      int patientId, String range) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final list = json["laboratoryProfileHistory"]["History"] as List?;
          if (list != null) {
            final iterable =
                list.map((e) => ProfileLaboratory.fromJson(e)).toList();
            return iterable;
          }
          return null;
        },
        body: '''
      query laboratoryProfileHistory{
        laboratoryProfileHistory(patientId:$patientId,
        range:$range){
          History{
            id
            CreatedBy
            Glucose
            Triglycerides
            Cholesterol
            Hemoglobin
            UricAcid
            created_at
          }
        }
      }
      ''');
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, List<ProfileCardiovascular>?>>
      getDataProfileCardiovascular(int patientId, String range) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final list = json["cardiovascularProfileHistory"]["History"] as List?;
          if (list != null) {
            final iterable =
                list.map((e) => ProfileCardiovascular.fromJson(e)).toList();
            return iterable;
          }
          return null;
        },
        body: '''
      query cardiovascularProfileHistory{
        cardiovascularProfileHistory(patientId:$patientId,
        range:$range){
          History{
            id
            SystolicPressure
            DiastolicPressure
            HeartRate
            SleepHours
            created_at
          }
        }
      }
      ''');

    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, Doctor>> getMeDoctor(User user) async {
    final userId = user.id;
    print(user.id);
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final result = json["doctorProfile"];
          Doctor myDoctor = Doctor.fromJson(result);
          return myDoctor;
        },
        body: '''
    query doctorProfile{
        doctorProfile(userId:$userId){
          ID
          TotalScore
          RegisterStep
          SignedContract
          User{
            id
            full_name
            gender
            identification_type
            identification_number
            birthday
            email
            country_code
            phone_number
            ocupation
            profile_img_url
            role
          }
          WorkingHour{
            ID
            Tag
            DayOfWeek
            StartHour0
            StopHour0
            StartHour1
            StopHour1
          }
          MedicalCenters{
            ID
            Name
            Address
            Hospitalization
            Emergencies
            Laboratory
            Imaging
            Radiology
            TotalDoctors
            LogoUrl
            Latitude
            Longitude
            SpecialtiesCount
          }
        }
      }
    ''');
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, Patients?>> getMePatient(User user) async {
    final userId = user.id;
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final response = json["patientProfile"];
          logger.i(response["Patient"]["Treatments"]);
          return Patients(
              patientID: response["Patient"]["ID"] as int,
              totalScore: response["Patient"]["TotalScore"] as int?,
              signedContract: response["Patient"]["SignedContract"] as bool?,
              registerStep: response["Patient"]["RegisterStep"] as int?,
              followUpMethod: (response["Patient"]["FollowUpMethod"] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList(),
              user: User.fromJson(response["User"]),
              medicalHistory: response["Patient"]["MedicalHistory"] == null
                  ? const MedicalHistory()
                  : MedicalHistory.fromJson(response["Patient"]
                      ["MedicalHistory"] as Map<String, dynamic>),
              profileLaboratory: response["Patient"]["ProfileLaboratory"] == null
                  ? null
                  : ProfileLaboratory.fromJson(response["Patient"]
                      ["ProfileLaboratory"]["Latest"] as Map<String, dynamic>),
              profileCardiovascular:
                  response["Patient"]["ProfileCardiovascular"] == null
                      ? null
                      : ProfileCardiovascular.fromJson(response["Patient"]
                              ["ProfileCardiovascular"]["Latest"]
                          as Map<String, dynamic>),
              treatments: response["Patient"]["Treatments"] == null ? [] : (response["Patient"]["Treatments"] as List).map((t) => Treatment.fromJson(t)).toList(),
              meDoctorID: response["Patient"]["Doctor"]["ID"] == null ? 1 : response["Patient"]["Doctor"]["ID"] as int,
              doctorCountryCode: response["Patient"]["Doctor"]["User"]["country_code"] == null ? null : response["Patient"]["Doctor"]["User"]["country_code"] as String,
              doctorPhoneNumber: response["Patient"]["Doctor"]["User"]["phone_number"] == null ? null : response["Patient"]["Doctor"]["User"]["phone_number"] as String);
        },
        body: '''
    query patientProfile{
      patientProfile(userId: $userId){
        User{
          id
          full_name
          gender
          role
          identification_type
          identification_number
          email
          profile_img_url
          phone_number
          country_code
          ocupation
          birthday
          weight
          height
          fcm_token
          notifications{
            id
            title
            body
            data
            category
            read
          }
        }
        Patient{
          ID
          TotalScore
          RegisterStep
          SignedContract
          FollowUpMethod
          ProfileCardiovascular{
            Latest{
              id
              SystolicPressure
              DiastolicPressure
              HeartRate
              SleepHours
              created_at
            }
          }
          ProfileLaboratory{
            Latest{
              id
              Glucose
              Triglycerides
              Cholesterol
              Hemoglobin
              UricAcid
              created_at
            }
          }
          MedicalHistory{
            HasCardiovacularProblems
            HasCancerProblems
            HasDiabeticsProblems
            HasObesityProblems
            HasRespiratoryProblems
            HasMentalProblems
            HasFrequentFluProblems
            HaveRelativesCardiovascularProblems
            HaveRelativesCancerProblems
            HaveRelativesDiabeticsProblems
            HaveRelativesObesityProblems
            HaveRelativesRespiratoryProblems
            HaveRelativesMentalProblems
            HasDrinkingHabit
            HasSmokingHabit
            HasDrinkingCaffeineHabit
            HasMedication
            HasFitnessHabit
            HasEatingAfterHoursHabit
            ConsumeCannedFood,
            ConsumeSugaryFood,
            ConsumeSaturedFood,
            ConsumeHighlySeasonedFoods
            ConsumePreparedFoods,
            SatisfiedWithJob,
            HavePersonalGoals,
            HaveAccessEssentialService,
            HaveProperties,
            HaveProblemEnviromentalContamination
          }
          Treatments{
            ID,
            Name,
            Duration,
            DoctorID,
            Status,
            StartedOn,
            FinishedOn,
            CreatedAt,
            Medications{
              Name,
              Dose,
              DoseUnit,
              Frequency
            }
          }
          Doctor{
            ID
            User{
            country_code
            phone_number
            }
          }
        }
      }
    }
    ''');

    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
    // {
    //       final treatment = treatmentFake["result"] as List;
    //       List<Treatment> listTreatment = treatment
    //           .map((treatment) => Treatment.fromJson(treatment))
    //           .toList();
    //       data = data.copyWith(treatments: listTreatment);
    //       return Either.right(data);
    //     });
  }

  Future<Either<HttpRequestFailure, Doctor?>> getMyDoctor(int userID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final response = json["patientProfile"];
          Doctor myDoctor = Doctor.fromJson(response["Patient"]["Doctor"]);
          return myDoctor;
        },
        body: '''
        query patientProfile{
      patientProfile(userId: $userID){
        Patient{
         Doctor{
            ID
            User{
              id
              full_name
              gender
              role
              identification_type
              identification_number
              email
              profile_img_url
              phone_number
              country_code
              ocupation
              birthday
            }
           WorkingHour{
                ID
                Tag
                DayOfWeek
                StartHour0
                StopHour0
                StartHour1
                StopHour1
            }
          }
        }
      }
    }
    ''');
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> setUserData(
      UserDataInput userDataInput, int userID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            return true;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UpdateUserData(\$input: UserSettingInput!){
          UpdateUserData(input: \$input, userID:$userID) {
            id
          }
        }
      """,
        variables: {
          'input': userDataInput.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> registerDoctor(
      UserInput doctor, File? image) async {
    Map<String, dynamic> input = doctor.toJson();
    if (image != null) {
      var byteData = await compressImage(image) ?? image.readAsBytesSync();
      var multipartFile = MultipartFile.fromBytes(
        'profile_img',
        byteData,
        filename: '${DateTime.now().second}.jpg',
        contentType: MediaType("image", "jpg"),
      );
      input["profile_img"] = multipartFile;
    }
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final user = User.fromJson(data["createUserWithRole"]);
            return true;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation CreateUserWithRole(\$userInput: UserInput!, \$role: Role!) {
          createUserWithRole(userInput: \$userInput, role: \$role) {
            id
            full_name
            role
            identification_type
            identification_number
            email
            phone_number
            country_code
            ocupation
            birthday
          }
        }
      """,
        variables: {
          'userInput': input,
          'role': 'DOCTOR',
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> registerPatient(
      UserInput patient, int doctorID, File? image) async {
    Map<String, dynamic> input = patient.toJson();
    if (image != null) {
      var byteData = await compressImage(image) ?? image.readAsBytesSync();
      var multipartFile = MultipartFile.fromBytes(
        'profile_img',
        byteData,
        filename: '${DateTime.now().second}.jpg',
        contentType: MediaType("image", "jpg"),
      );
      input["profile_img"] = multipartFile;
    }
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final user = User.fromJson(data["createUserWithRole"]);
            return true;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation CreateUserWithRole(\$userInput: UserInput!, \$role: Role!) {
          createUserWithRole(userInput: \$userInput, role: \$role ,doctorId:$doctorID) {
            id
            full_name
            role
            identification_type
            identification_number
            email
            phone_number
            country_code
            ocupation
            birthday
          }
        }
      """,
        variables: {
          'userInput': input,
          'role': 'PATIENT',
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> upLoadHistoricMedical(
      MedicalHistory medicalHistoryInput, int patientID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            return true;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UpdateMedicalHistoryData(\$input: MedicalHistoryInput!) {
          UpdateMedicalHistoryData(input: \$input, patientId:$patientID) {
            HasFitnessHabit
          }
        }
      """,
        variables: {
          'input': medicalHistoryInput.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> uploadFollowedMethod(
      UploadFollowedUpMethodInput input) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["UpdateFollowUpMethod"];
            if (json.containsKey("ID")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UpdateFollowUpMethod(\$input: FollowUpMethodInput!) {
          UpdateFollowUpMethod(input: \$input) {
            ID
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> completeStep2Doctor(
      UserDataInput userDataInput, int userID, int doctorId) async {
    final result = await setUserData(userDataInput, userID);
    return result.when(
        left: (fail) => Either.left(fail),
        right: (data) async {
          if (data) {
            final response = await _graphQLDigimed.request(
                onSuccess: (data) {
                  try {
                    final Map<String, dynamic> json =
                        data["UploadRegisterStepDoctor"];
                    if (json.containsKey("RegisterStep")) {
                      return true;
                    }
                    return false;
                  } catch (e) {
                    return false;
                  }
                },
                method: GraphQLMethod.mutation,
                body: """
                  mutation UploadRegisterStepDoctor {
                    UploadRegisterStepDoctor(step: 2, doctorID: $doctorId) {
                      RegisterStep
                    }
                  }
                """);
            return response.when(
                left: handleHttpFailure, right: (data) => Either.right(data));
          }
          return Either.left(HttpRequestFailure.unknown());
        });
  }

  Future<Either<HttpRequestFailure, bool>> completeStep2Patient(
      UserDataInput userDataInput, int userID, int patientId) async {
    final result = await setUserData(userDataInput, userID);
    return result.when(
        left: (fail) => Either.left(fail),
        right: (data) async {
          if (data) {
            return await goToStepPatient(2, patientId);
          }
          return Either.left(HttpRequestFailure.unknown());
        });
  }

  Future<Either<HttpRequestFailure, bool>> goToStepDoctor(
      int userID, int step, int doctorId) async {
    final response = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["UploadRegisterStepDoctor"];
            if (json.containsKey("RegisterStep")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UploadRegisterStepDoctor {
          UploadRegisterStepDoctor(step: $step, doctorID: $doctorId) {
            RegisterStep
          }
        }
        """);
    return response.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> goToStepPatient(
      int step, int patientId) async {
    final response = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["UploadRegisterStePatient"];
            if (json.containsKey("RegisterStep")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UploadRegisterStePatient {
          UploadRegisterStePatient(step: $step, patienID: $patientId) {
            RegisterStep
          }
        }
        """);
    return response.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> completeStep1Doctor(
      String newPassword, int userID, int doctorId) async {
    final response = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final status = data["UploadPassword"] as bool;
            if (status) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UploadPassword(\$newPassword: String!) {
          UploadPassword(newPassword:\$newPassword,userID: $userID) 
        }
        """,
        variables: {
          'newPassword': newPassword,
        });
    return response.when(
        left: handleHttpFailure,
        right: (data) async {
          if (data) {
            return await goToStepDoctor(userID, 1, doctorId);
          }
          return Either.left(HttpRequestFailure.unknown());
        });
  }

  Future<Either<HttpRequestFailure, bool>> completeStep1Patient(
      String newPassword, int userID, int patientId) async {
    final response = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final status = data["UploadPassword"] as bool;
            if (status) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UploadPassword(\$newPassword: String!) {
          UploadPassword(newPassword:\$newPassword,userID: $userID) 
        }
        """,
        variables: {
          'newPassword': newPassword,
        });
    return response.when(
        left: handleHttpFailure,
        right: (data) async {
          if (data) {
            return await goToStepPatient(1, patientId);
          }
          return Either.left(HttpRequestFailure.unknown());
        });
  }

  Future<Either<HttpRequestFailure, bool>> acceptContractPatient(
      int patientID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["AcceptTerm"];
            if (json.containsKey("SignedContract")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation AcceptTerm {
          AcceptTerm(patientID: $patientID) {
            ID
            SignedContract
          }
        }
      """);
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> acceptContractDoctor(
      int doctorID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["AcceptTermDoctor"];
            if (json.containsKey("SignedContract")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation AcceptTermDoctor {
          AcceptTermDoctor(doctorID: $doctorID) {
            SignedContract
          }
        }
      """);
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> createNewProfileLab(
      ProfileLabInput input, int doctorID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["CreateNewProfileLaboratoy"];
            if (json.containsKey("PatientID")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation CreateNewProfileLaboratoy(\$input: ProfileLaboratoryInput!) {
          CreateNewProfileLaboratoy(input: \$input) {
            PatientID
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure,
        right: (data) {
          // ActivityInput activity1 = const ActivityInput(
          //     name: "Actualizar Glucemia",
          //     roleID: 1 ,
          //     doctorPoints: 10,
          //     patientPoints: 0);
          // ActivityInput activity2 = const ActivityInput(
          //     name: "Actualizar Triglicéridos",
          //     roleID: 1 ,
          //     doctorPoints: 10,
          //     patientPoints: 0);
          // ActivityInput activity3 = const ActivityInput(
          //     name: "Actualizar Colesterol LDL",
          //     roleID: 1 ,
          //     doctorPoints: 10,
          //     patientPoints: 0);
          // ActivityInput activity4 = const ActivityInput(
          //     name: "Actualizar Hemoglobina",
          //     roleID: 1 ,
          //     doctorPoints: 10,
          //     patientPoints: 0);
          //
          // await addNewActivity(activity1, input.patientID , doctorID);
          // await addNewActivity(activity2, input.patientID , doctorID);
          // await addNewActivity(activity3, input.patientID , doctorID);
          //await addNewActivity(activity4, input.patientID , doctorID);
          return Either.right(data);
        });
  }

  Future<Either<HttpRequestFailure, bool>> createNewProfileCardio(
      ProfileCardioInput input, int patientID, int doctorID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json =
                data["CreateNewProfileCardiovascular"];
            if (json.containsKey("PatientID")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation CreateNewProfileCardiovascular(\$input: ProfileCardiovascularInput!) {
          CreateNewProfileCardiovascular(input: \$input) {
            PatientID
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure,
        right: (data) async {
          return Either.right(data);
        });
  }

  Future<Either<HttpRequestFailure, bool>> addNewActivity(
      ActivityInput input, int patientID, int doctorID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["AddNewActivity"];
            if (json.containsKey("Name")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation AddNewActivity(\$input: ActivityInput!) {
          AddNewActivity(input: \$input, patienID: $patientID, doctorID: $doctorID) {
            Name
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, List<Activity>>> getMyActivitys(
      int userID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final response = json["patientProfile"];
          final list = response["Patient"]["Activities"] as List;
          final iterable = list.map((e) => Activity.fromJson(e)).toList();
          return iterable;
        },
        body: '''
    query patientProfile{
      patientProfile(userId: $userID){
        Patient{
          Activities{
            Name
            PatientPoints
            DoctorPoints
            CreatedAt
          }
        }
      }
    }
    ''');

    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, List<Activity>>> getMyActivitysDoctor(
      int userID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final response = json["doctorProfile"];
          final list = response["Activities"] as List;
          final iterable = list.map((e) => Activity.fromJson(e)).toList();
          return iterable;
        },
        body: '''
    query doctorProfile{
      doctorProfile(userId: $userID){
        Activities{
          Name
          PatientPoints
          DoctorPoints
          CreatedAt
        }
      }
    }
    ''');

    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, String>> uploadImage(
      File image, int userID) async {
    Map<String, dynamic> input = {};
    input["userId"] = userID;
    var byteData = await compressImage(image) ?? image.readAsBytesSync();
    var multipartFile = MultipartFile.fromBytes(
      'file',
      byteData,
      filename: '${DateTime.now().second}.jpg',
      contentType: MediaType("image", "jpg"),
    );
    input["file"] = multipartFile;

    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          return json["uploadProfileImage"] as String;
        },
        method: GraphQLMethod.mutation,
        body: '''
        mutation uploadProfileImage(\$input: ProfileImage!){
          uploadProfileImage(input: \$input)
        }
        ''',
        variables: {
          'input': input,
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> upDateWorkingHours(
      WorkingHoursInput input) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["UpDateWorkingHour"];
            if (json.containsKey("ID")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UpDateWorkingHour(\$input: WorkingHourInput!) {
          UpDateWorkingHour(input: \$input) {
            ID
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool>> recordNewLocation(
      LocationInput input) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final Map<String, dynamic> json = data["RecordLocation"];
            if (json.containsKey("ID")) {
              return true;
            }
            return false;
          } catch (e) {
            return false;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation RecordLocation(\$input: LocationInput!) {
          RecordLocation(input: \$input) {
            ID
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteS(
      InputSOAP input) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final subjective =
                SOAPNote.fromJson(data["RecordSoapNotes"]["Subjective"]);
            return subjective;
          } catch (e) {
            return null;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation RecordSoapNotes(\$input: SOAPNoteInput!) {
          RecordSoapNotes(input: \$input) {
            Subjective{
              Note
              LastUpdatedAt
            }
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteO(
      InputSOAP input) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final subjective =
                SOAPNote.fromJson(data["RecordSoapNotes"]["Objective"]);
            return subjective;
          } catch (e) {
            return null;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation RecordSoapNotes(\$input: SOAPNoteInput!) {
          RecordSoapNotes(input: \$input) {
            Objective{
              Note
              LastUpdatedAt
            }
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteA(
      InputSOAP input) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final subjective =
                SOAPNote.fromJson(data["RecordSoapNotes"]["Assessment"]);
            return subjective;
          } catch (e) {
            return null;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation RecordSoapNotes(\$input: SOAPNoteInput!) {
          RecordSoapNotes(input: \$input) {
            Assessment{
              Note
              LastUpdatedAt
            }
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, SOAPNote?>> recordNewNoteP(
      InputSOAP input) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final subjective =
                SOAPNote.fromJson(data["RecordSoapNotes"]["Plan"]);
            return subjective;
          } catch (e) {
            return null;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation RecordSoapNotes(\$input: SOAPNoteInput!) {
          RecordSoapNotes(input: \$input) {
            Plan{
              Note
              LastUpdatedAt
            }
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

// Aqui las funciones de consulta para las notas soap para traer la lista de notasSOAP:

  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteS(
      int userID, String rangeTime) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final patientProfile = json['patientProfile'];
        final notesData = patientProfile['Patient']['SOAPNotes'] as List?;
        if (notesData == null || notesData.isEmpty) {
          List<SOAPNote> soapNotes = [];
          return soapNotes;
        }

        List<SOAPNote> soapNotes = notesData
            .where((note) =>
                note['Subjective'] != null &&
                note['Subjective']['Note'] != null)
            .map((note) => SOAPNote.fromJson(note['Subjective']))
            .toList();

        return soapNotes;
      },
      body: '''
    query{
      patientProfile(userId: $userID, range: $rangeTime){
        Patient{
          SOAPNotes{
            Subjective{
              Note
              LastUpdatedAt
            }
          }
        }
      }
    }
    ''',
      variables: {'userId': userID},
    );

    return result.when(
        left: handleHttpFailure,
        right: (notes) {
          return Either.right(notes);
        });
  }

  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteO(
      int userID, String rangeTime) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final patientProfile = json['patientProfile'];
        final notesData = patientProfile['Patient']['SOAPNotes'] as List?;
        if (notesData == null || notesData.isEmpty) {
          List<SOAPNote> soapNotes = [];
          return soapNotes;
        }

        List<SOAPNote> soapNoteo = notesData
            .where((note) =>
                note['Objective'] != null && note['Objective']['Note'] != null)
            .map((note) => SOAPNote.fromJson(note['Objective']))
            .toList();

        return soapNoteo;
      },
      body: '''
    query{
      patientProfile(userId: $userID, range: $rangeTime){
        Patient{
          SOAPNotes{
            Objective{
              Note
              LastUpdatedAt
            }
          }
        }
      }
    }
    ''',
      variables: {'userId': userID},
    );

    return result.when(
        left: handleHttpFailure,
        right: (notes) {
          return Either.right(notes);
        });
  }

  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteA(
      int userID, String rangeTime) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final patientProfile = json['patientProfile'];
        final notesData = patientProfile['Patient']['SOAPNotes'] as List?;
        if (notesData == null || notesData.isEmpty) {
          List<SOAPNote> soapNotes = [];
          return soapNotes;
        }

        List<SOAPNote> soapNotea = notesData
            .where((note) =>
                note['Assessment'] != null &&
                note['Assessment']['Note'] != null)
            .map((note) => SOAPNote.fromJson(note['Assessment']))
            .toList();

        return soapNotea;
      },
      body: '''
    query{
      patientProfile(userId: $userID, range: $rangeTime){
        Patient{
          SOAPNotes{
            Assessment{
              Note
              LastUpdatedAt
            }
          }
        }
      }
    }
    ''',
      variables: {'userId': userID},
    );

    return result.when(
      left: handleHttpFailure,
      right: (notes) {
        return Either.right(notes);
      },
    );
  }

  Future<Either<HttpRequestFailure, List<SOAPNote>>> getSoapNoteP(
      int userID, String rangeTime) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final patientProfile = json['patientProfile'];
        final notesData = patientProfile['Patient']['SOAPNotes'] as List?;
        if (notesData == null || notesData.isEmpty) {
          List<SOAPNote> soapNotes = [];
          return soapNotes;
        }

        List<SOAPNote> soapNotep = notesData
            .where(
                (note) => note['Plan'] != null && note['Plan']['Note'] != null)
            .map((note) => SOAPNote.fromJson(note['Plan']))
            .toList();

        return soapNotep;
      },
      body: '''
    query{
      patientProfile(userId: $userID, range: $rangeTime){
        Patient{
          SOAPNotes{
            Plan{
              Note
              LastUpdatedAt
            }
          }
        }
      }
    }
    ''',
      variables: {'userId': userID},
    );

    return result.when(
      left: handleHttpFailure,
      right: (notes) {
        return Either.right(notes);
      },
    );
  }

  // Aqui la funcion para traer los datos del MedicalCenter:
  Future<Either<HttpRequestFailure, List<MedicalCenter>>>
      medicalCenter() async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final medicalCenter = json['medicalCenters'] as List?;
        if (medicalCenter == null || medicalCenter.isEmpty) {
          List<MedicalCenter> madicalCenter = [];
          return madicalCenter;
        }

        List<MedicalCenter> madicalCenterData =
            medicalCenter.map((data) => MedicalCenter.fromJson(data)).toList();

        return madicalCenterData;
      },
      body: '''
      query{
        medicalCenters{
          ID
          Name
          Address
          Hospitalization
          Emergencies
          Laboratory
          Imaging
          Radiology
          TotalDoctors
          LogoUrl
          Latitude
          Longitude
          SpecialtiesCount
        }
      }
      ''',
    );
    return result.when(
      left: handleHttpFailure,
      right: (listData) => Either.right(listData),
    );
  }

  Future<Either<HttpRequestFailure, List<User>>> medicalCenterCoordinator(
      int medicalCenterId) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final coordinators = json['coordinatorsList'] as List?;
        if (coordinators == null || coordinators.isEmpty) {
          return <User>[];
        }

        List<User> listCordinatorData =
            coordinators.map((data) => User.fromJson(data)).toList();

        return listCordinatorData;
      },
      body: '''
      query{
        coordinatorsList(medicalCenterID: $medicalCenterId){
          id
          full_name
          email
          role
          gender
          phone_number
          ocupation
          identification_type
          identification_number
          country_code
          weight
          height
          birthday
          profile_img_url
          created_at
          updated_at
          deleted_at
        }
      }
      ''',
    );
    return result.when(
      left: handleHttpFailure,
      right: (listData) => Either.right(listData),
    );

    // List<dynamic> listCordinadoresData;

    // switch (medicalCenterId) {
    //   case 5:
    //     listCordinadoresData =
    //         listCoordinatorsGE['coordinators'] as List<dynamic>;
    //     break;
    //   case 4:
    //     listCordinadoresData =
    //         listCoordinatorsMT['coordinators'] as List<dynamic>;
    //     break;
    //   default:
    //     listCordinadoresData =
    //         listCoordinators['coordinators'] as List<dynamic>;
    //     break;
    // }

    // List<User> listCordinator = listCordinadoresData
    //     .map((centerJson) => User.fromJson(centerJson))
    //     .toList();

    // return Right(listCordinator);
  }

  Future<Either<HttpRequestFailure, List<DoctorSpecialists>>>
      getListDoctorsSpecialist(int medicalCenterID, int specialtyID) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final doctorSpecialties = json['specialists'] as List?;
        if (doctorSpecialties == null || doctorSpecialties.isEmpty) {
          return <DoctorSpecialists>[];
        }

        // Cambio de la forma de transformar el json en una lista de objeto
        List<DoctorSpecialists> doctorSpecialtiesData =
            doctorSpecialties.map((data) {
          List<MedicalSpecialty> specialtiesData =
              (data['MedicalSpecialties'] as List?)
                      ?.map((specialtyJson) =>
                          MedicalSpecialty.fromJson(specialtyJson))
                      .toList() ??
                  [];

          return DoctorSpecialists(
              doctorID: data["ID"] as int,
              fullName: data["User"]["full_name"] as String,
              email: data["User"]["email"] as String,
              countryCode: data["User"]["country_code"] as String,
              phoneNumber: data["User"]["phone_number"] as String,
              medicalSpecialties: specialtiesData);
        }).toList();

        return doctorSpecialtiesData;
      },
      body: '''
      query{
        specialists(medicalCenterID: $medicalCenterID, specialtyID: $specialtyID){
          ID
          User{
            full_name
            email
            country_code
            phone_number
          }
          MedicalSpecialties{
            ID
            Name
          }
        }
      }
    ''',
    );
    return result.when(
      left: handleHttpFailure,
      right: (data) => Either.right(data),
    );
  }

  // Consultar las especialidades medicas
  Future<Either<HttpRequestFailure, List<MedicalSpecialty>>>
      medicalSpecialties() async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final specialties = json['medicalSpecialties'] as List?;
        if (specialties == null || specialties.isEmpty) {
          return <MedicalSpecialty>[];
        }

        List<MedicalSpecialty> specialtiesData =
            specialties.map((data) => MedicalSpecialty.fromJson(data)).toList();

        return specialtiesData;
      },
      body: '''
      query {
        medicalSpecialties {
          ID
          Name
        }
      }
    ''',
    );
    return result.when(
      left: handleHttpFailure,
      right: (data) => Either.right(data),
    );
  }

  Future<Either<HttpRequestFailure, bool>> assignSpecialist(
      int patientID, int doctorID) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final boolSpecialist = json['AssignSpecialist'] as bool;
        print(boolSpecialist);
        if (boolSpecialist) {
          return true;
        }
        return false;
      },
      method: GraphQLMethod.mutation,
      body: '''
      mutation AssignSpecialist{
        AssignSpecialist(patientID: $patientID, doctorID: $doctorID)
      }
    ''',
      variables: {},
    );
    return result.when(
      left: handleHttpFailure,
      right: (dataBool) => Either.right(dataBool),
    );
  }

  Future<Either<HttpRequestFailure, List<DoctorSpecialists>>>
      doctorSpecialitsPatient(int patientId) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final specialtiesPatients = json['patientSpecialists'] as List?;
        if (specialtiesPatients == null || specialtiesPatients.isEmpty) {
          return <DoctorSpecialists>[];
        }

        // Cambio de la forma de transformar el json en una lista de objeto
        List<DoctorSpecialists> specialtiesPatientsData =
            specialtiesPatients.map((data) {
          List<MedicalSpecialty> specialtiesData =
              (data['MedicalSpecialties'] as List?)
                      ?.map((specialtyJson) =>
                          MedicalSpecialty.fromJson(specialtyJson))
                      .toList() ??
                  [];

          return DoctorSpecialists(
              doctorID: data["ID"] as int,
              fullName: data["User"]["full_name"] as String,
              email: data["User"]["email"] as String,
              countryCode: data["User"]["country_code"] as String,
              phoneNumber: data["User"]["phone_number"] as String,
              medicalSpecialties: specialtiesData);
        }).toList();

        return specialtiesPatientsData;
      },
      body: '''
      query{
        patientSpecialists(patientId: $patientId){
          ID
          User{
            id
            full_name
            email
            country_code
            phone_number
            birthday
          }
          MedicalSpecialties{
            ID
            Name
          }
        }
      }
    ''',
    );
    return result.when(
      left: handleHttpFailure,
      right: (data) => Either.right(data),
    );
  }

  Future<Either<HttpRequestFailure, List<int>>> medicalCenterIdForCordinator(
      int userID) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final medicalCentersListByUser =
            json['medicalCentersListByUser'] as List?;
        if (medicalCentersListByUser == null ||
            medicalCentersListByUser.isEmpty) {
          return <int>[];
        }
        List<int> medicalCentersListByUserData =
            medicalCentersListByUser.map((data) => data['ID'] as int).toList();
        return medicalCentersListByUserData;
      },
      body: '''
      query{
        medicalCentersListByUser(userID: $userID){
          ID
        }
      }
      ''',
    );
    return result.when(
      left: handleHttpFailure,
      right: (data) => Either.right(data),
    );
  }

  Future<Either<HttpRequestFailure, List<ItemDoctors>>>
      getCordinatorListDoctors(
    List<int> listmedicalCenterIds,
  ) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final list = json["doctors"] as List;
        final data = list.map((e) => ItemDoctors.fromJson(e)).toList();
        return data;
      },
      body: '''
      query{
        doctors( medicalCenterID: ${listmedicalCenterIds[0]}, specialists: false){
          ID
          User{
            id
            full_name
            gender
            identification_type
            identification_number
            profile_img_url
          }
          PatientsCount
        }
      }
    ''',
    );
    return result.when(
      left: handleHttpFailure,
      right: (list) => Either.right(list),
    );
  }

  Future<Either<HttpRequestFailure, List<ItemDoctors>>>
      getAdminCoordinatorListDoctors(int medicalCenterID) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          print(json);
          final list = json["doctors"] as List;
          final iterable = list.map((e) => ItemDoctors.fromJson(e)).toList();
          return iterable;
        },
        body: '''
    query{
      doctors(medicalCenterID: $medicalCenterID, specialists:false){
        User{
          id
          full_name
          gender
          identification_type
          identification_number
          profile_img_url
        }
        PatientsCount
      }
    }
    ''');
    return result.when(
        left: handleHttpFailure, right: (list) => Either.right(list));
  }

  Future<Either<HttpRequestFailure, String>> healthSummary(
      int patientId) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final response = json['healthSummary'] as String;
          return response;
        },
        body: '''
    query{
      healthSummary(patientID: $patientId)
    }
    ''');
    return result.when(
        left: handleHttpFailure, right: (list) => Either.right(list));
  }

  Future<Either<HttpRequestFailure, String>> getPatientMedicalHistoryAnalysis(
      int patientId) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final response = json['getPatientMedicalHistoryAnalysis'] as String;
          return response;
        },
        body: '''
    query{
      getPatientMedicalHistoryAnalysis(patientID: $patientId)
    }
    ''');
    return result.when(
        left: handleHttpFailure, right: (list) => Either.right(list));
  }

  Future<Either<HttpRequestFailure, String>> getIAAssessment(
      AssessmentInput input) async {
    final result = await _http.request("ecg9wn4a1hwv3qkgbn83f91avspnfpw2",
        onSuccess: (json) {
      //  final response = json['Resultado'] as String;
      return json;
    }, body: input.toJson(), method: HttpMethod.post);

    return result.when(
        left: handleHttpFailure, right: (response) => Either.right(response));
  }

  Future<Either<HttpRequestFailure, String>> getIAPlan(PlanInput input) async {
    final result = await _http.request("blfritj2cmufnpqc8i58q0c4xu1qsjum",
        onSuccess: (json) {
      return json;
    }, body: input.toJson(), method: HttpMethod.post);

    return result.when(
        left: handleHttpFailure, right: (response) => Either.right(response));
  }

  Future<Either<HttpRequestFailure, String>> createReport(
      ReportInput input) async {
    input = input.copyWith(token: _graphQLDigimed.getMyToken() ?? "");
    final result = await _http.request("4sk9ox599ba8ky0az4r2rwkspgk462d3",
        onSuccess: (json) {
      return json;
    }, body: input.toJson(), method: HttpMethod.post);

    return result.when(
        left: handleHttpFailure, right: (response) => Either.right(response));
  }

  Future<Either<HttpRequestFailure, String>> createReportServer(
      ReportInput input) async {
    print(input.toJson());
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final id = data["CreatePatientReport"]["id"] as String;
            return id;
          } catch (e) {
            return "";
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation CreatePatientReport (\$input: PatientReportInput!) {
          CreatePatientReport (input: \$input) {
            id
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, List<Report>>> getReportsByPatientID(
      int patientId, String range) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final list = json["patientReports"] as List;
          final iterable = list.map((e) => Report.fromJson(e)).toList();
          iterable.sort((a, b) {
            // Si ambos createAt son cadenas vacías, no hay diferencia
            if (a.createdAt.isEmpty && b.createdAt.isEmpty) return 0;
            // Si a tiene createAt vacío, va al final (menos reciente)
            if (a.createdAt.isEmpty) return 1;
            // Si b tiene createAt vacío, va al final (menos reciente)
            if (b.createdAt.isEmpty) return -1;
            // Si ambos tienen valores válidos, comparar como DateTime
            return DateTime.parse(b.createdAt)
                .compareTo(DateTime.parse(a.createdAt));
          });
          print(iterable);
          return iterable;
        },
        body: '''
        query{
        patientReports(patientId:$patientId){
            id,
            report,
            title,
            createdAt
          }
        }
    ''');
    return result.when(
        left: handleHttpFailure, right: (list) => Either.right(list));
  }

  Future<Either<HttpRequestFailure, List<Report>>> getReportsByPatientID2(
      int patientId, String range) async {
    final json = reportsFake;
    final list = json["result"] as List;
    final iterable = list.map((e) => Report.fromJson(e)).toList();

    return Future.value(Either.right(iterable));
  }

  Future<Either<HttpRequestFailure, String>> getReportBase64(
      int reportID) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final data = json["patientReportPDF"]["pdfData"] as String;
        return data;
      },
      body: '''
        query{
        patientReportPDF(reportId: $reportID){
            pdfData
          }
        }
    ''',
    );
    return result.when(
        left: handleHttpFailure, right: (list) => Either.right(list));
  }

  Future<Either<HttpRequestFailure, VerificationResponse>>
      getTreatmentVerification(VerificationInput input) async {
    input = input.copyWith(token: _graphQLDigimed.getMyToken() ?? "");
    final result = await _http.request("pcmaypwjmsfl2f450ifx2y8wulr2xfry",
        onSuccess: (json) {
      return VerificationResponse.fromJson(json);
    }, body: input.toJson(), method: HttpMethod.post);

    return result.when(
        left: handleHttpFailure, right: (response) => Either.right(response));
  }

  Future<Either<HttpRequestFailure, String>> createPrescription(
      RecipeInput input) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            final id = data["CreatePatientRecipe"]["id"] as String;
            return id;
          } catch (e) {
            return "";
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation CreatePatientRecipe (\$input: PatientRecipeInput!) {
          CreatePatientRecipe (input: \$input) {
            id
          }
        }
      """,
        variables: {
          'input': input.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, List<Recipe>>> getPrescriptionByPatientID(
      int patientId, String range) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final list = json["patientRecipes"] as List;
          final iterable = list.map((e) => Recipe.fromJson(e)).toList();
          iterable.sort((a, b) {
            // Si ambos createAt son cadenas vacías, no hay diferencia
            if (a.createdAt.isEmpty && b.createdAt.isEmpty) return 0;
            // Si a tiene createAt vacío, va al final (menos reciente)
            if (a.createdAt.isEmpty) return 1;
            // Si b tiene createAt vacío, va al final (menos reciente)
            if (b.createdAt.isEmpty) return -1;
            // Si ambos tienen valores válidos, comparar como DateTime
            return DateTime.parse(b.createdAt)
                .compareTo(DateTime.parse(a.createdAt));
          });
          print(iterable);
          return iterable;
        },
        body: '''
        query{
          patientRecipes(patientId:$patientId){
            id,
            recipe,
            title,
            createdAt
          }
        }
    ''');
    return result.when(
        left: handleHttpFailure, right: (list) => Either.right(list));
  }

  Future<Either<HttpRequestFailure, String>> getRecipeBase64(
      int reportID) async {
    final result = await _graphQLDigimed.request(
      onSuccess: (json) {
        final data = json["patientRecipePDF"]["pdfData"] as String;
        return data;
      },
      body: '''
        query{
        patientRecipePDF(recipeId: $reportID){
            pdfData
          }
        }
    ''',
    );
    return result.when(
        left: handleHttpFailure, right: (list) => Either.right(list));
  }

  Future<Either<HttpRequestFailure, ProfileLaboratory?>> updateResultsLabs(
      ProfileLaboratoryEditInput item, int profileId) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (data) {
          try {
            logger.i(data["UpdateProfileLaboratory"]);
            return ProfileLaboratory.fromJson(data["UpdateProfileLaboratory"]);
          } catch (e) {
            logger.e(e.toString());
            return null;
          }
        },
        method: GraphQLMethod.mutation,
        body: """
        mutation UpdateLabProfile(\$input:ProfileLaboratoryEditInput!){
          UpdateProfileLaboratory(profileLaboratoryID: $profileId, input: \$input){
           id,
            Glucose,
            Triglycerides,
            Cholesterol,
            Hemoglobin,
            UricAcid,
            created_at
          }
        }
      """,
        variables: {
          'input': item.toJson(),
        });
    return result.when(
        left: handleHttpFailure, right: (data) => Either.right(data));
  }

  Future<Either<HttpRequestFailure, bool?>> markReadNotification(
      int notificationId) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final response = json['markNotificationRead'] as bool;
          return response;
        },
        body: '''
      mutation {
        markNotificationRead(id:$notificationId)
      }
    ''');
    return result.when(
        left: handleHttpFailure, right: (response) => Either.right(response));
  }

  Future<Either<HttpRequestFailure, bool?>> updateTreatment(
      int idTreatment, String status) async {
    final result = await _graphQLDigimed.request(
        onSuccess: (json) {
          final response = json['updateTreatmentStatus'];
          if(response != null && response['ID'] != null){
            return true;
          }
          return false;
        },
        method: GraphQLMethod.mutation,
        body: '''
        mutation{
          updateTreatmentStatus(treatmentID:$idTreatment, status: $status){
            ID
          }
        }
        '''
    );
    return result.when(
        left: handleHttpFailure, right: (response) => Either.right(response));
  }
}
