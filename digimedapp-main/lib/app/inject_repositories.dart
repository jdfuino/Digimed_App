import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digimed/app/data/http/grapgh_ql_digimed.dart';
import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/data/providers/local/multimedia_service.dart';
import 'package:digimed/app/data/providers/local/position_service.dart';
import 'package:digimed/app/data/providers/local/session_service.dart';
import 'package:digimed/app/data/providers/remote/account_api.dart';
import 'package:digimed/app/data/providers/remote/authentication_api.dart';
import 'package:digimed/app/data/providers/remote/internet_checker.dart';
import 'package:digimed/app/data/repositories_implementation/account_repository_implementation.dart';
import 'package:digimed/app/data/repositories_implementation/authentication_repository_implementation.dart';
import 'package:digimed/app/data/repositories_implementation/connectivity_repository_implementation.dart';
import 'package:digimed/app/data/repositories_implementation/fcm_repository_implementation.dart';
import 'package:digimed/app/data/repositories_implementation/multimedia_repository_implementation.dart';
import 'package:digimed/app/data/repositories_implementation/position_repository_implementation.dart';
import 'package:digimed/app/domain/globals/session_service.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/authentication_repository.dart';
import 'package:digimed/app/domain/repositories/connectivity_repository.dart';
import 'package:digimed/app/domain/repositories/fcm_repository.dart';
import 'package:digimed/app/domain/repositories/multimedia_respository.dart';
import 'package:digimed/app/domain/repositories/position_repository.dart';
import 'package:digimed/app/presentation/service_locator/service_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<void> injectRepositories({required Http http,
  required Connectivity connectivity,
  required InternetChecker internetChecker,
  required FlutterSecureStorage secureStorage,
  required ImagePicker imagePicker,
  required ImageCropper imageCropper,
  required GraphQLDigimed graphQLDigimed,
  required FirebaseMessaging firebaseMessaging,
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  required NavigationService navigationService}) async {
  final authenticationAPI = AuthenticationAPI(http, graphQLDigimed);
  final sessionService = SessionService(secureStorage);
  final serviceMultimedia = MultimediaService(imagePicker, imageCropper);
  final positionService = PositionService();
  final token = await sessionService.sessionId;

  if (token != null) {
    graphQLDigimed.refreshToken(token);
  }

  final accountAPI = AccountAPI(http, sessionService, graphQLDigimed);

  ServiceLocator.instance.put<ConnectivityRepository>(
      ConnectivityRepositoryImplementation(connectivity, internetChecker));

  ServiceLocator.instance.put<AuthenticationRepository>(
      AuthenticationRepositoryImplementation(
          authenticationAPI, accountAPI, sessionService));

  ServiceLocator.instance.put<AccountRepository>(
    AccountRepositoryImplementation(
      accountAPI,
      sessionService,
    ),
  );

  ServiceLocator.instance.put<MultimediaRepository>(
      MultimediaRepositoryImplementation(multimediaService: serviceMultimedia));

  ServiceLocator.instance.put<PositionRepository>(
      PositionRepositoryImplementation(positionService: positionService));

  ServiceLocator.instance.put<FCMRepository>(
      FCMRepositoryImplementation(
          secureStorage: secureStorage,
          firebaseMessaging: firebaseMessaging,
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
          accountRepository: Repositories.account,
          client: graphQLDigimed,));
}

class Repositories {
  Repositories._(); // coverage:ignore-line
  ///
  static ConnectivityRepository get connectivity =>
      ServiceLocator.instance.find();

  ///
  static AuthenticationRepository get authentication =>
      ServiceLocator.instance.find();

  ///
  static AccountRepository get account => ServiceLocator.instance.find();

  ///
  static MultimediaRepository get multimedia => ServiceLocator.instance.find();

  ///
  static PositionRepository get positionService =>
      ServiceLocator.instance.find();

// FCMRepository Getter
  static FCMRepository get fcm => ServiceLocator.instance.find();
}
