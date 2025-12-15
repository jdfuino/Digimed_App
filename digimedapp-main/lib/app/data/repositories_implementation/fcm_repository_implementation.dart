import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:digimed/app/data/http/grapgh_ql_digimed.dart';
import 'package:digimed/app/domain/constants/notification_constants.dart';
import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/notification_model/notification_model.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:digimed/app/domain/models/user_data_input/user_data_input.dart';
import 'package:digimed/app/domain/repositories/accountRepository.dart';
import 'package:digimed/app/domain/repositories/fcm_repository.dart';
import 'package:digimed/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/globals/logger.dart';

class FCMRepositoryImplementation implements FCMRepository {
  final GraphQLDigimed _graphQLDigimed;
  final AccountRepository _accountRepository;
  final FirebaseMessaging _firebaseMessaging;
  final FlutterSecureStorage _secureStorage;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static const String _fcmTokenKey = 'fcm_token';
  final Uuid _uuid = const Uuid();

  // Stream para notificaciones
  final StreamController<NotificationModel> _notificationStreamController =
      StreamController<NotificationModel>.broadcast();

  Stream<NotificationModel> get notificationStream =>
      _notificationStreamController.stream;

  // Callbacks para navegación
  Function(String?)? _onPropertyUpdateCallback;
  Function(String?)? _onPropertyDetailCallback;
  Function()? _onHomeCallback;

  // Token actual
  String? _currentToken;

  String? get currentToken => _currentToken;

  // Callback para cuando se obtiene un nuevo token
  Function(String)? _onTokenRefresh;

  FCMRepositoryImplementation({
    required GraphQLDigimed client,
    required FirebaseMessaging firebaseMessaging,
    required FlutterSecureStorage secureStorage,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    required AccountRepository accountRepository,
  })  : _graphQLDigimed = client,
        _firebaseMessaging = firebaseMessaging,
        _secureStorage = secureStorage,
        _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin,
        _accountRepository = accountRepository;

  @override
  Future<void> initialize({
    Function(String)? onTokenRefresh,
    Function(String?)? onPropertyUpdate,
    Function(String?)? onPropertyDetail,
    Function()? onHome,
  }) async {
    try {
      _onTokenRefresh = onTokenRefresh;
      _onPropertyUpdateCallback = onPropertyUpdate;
      _onPropertyDetailCallback = onPropertyDetail;
      _onHomeCallback = onHome;

      // Inicializar timezone
      tz.initializeTimeZones();

      // Configuración específica por plataforma
      if (Platform.isAndroid) {
        await _configureAndroid();
      } else if (Platform.isIOS) {
        await _configureIOS();
      }

      // Inicializar notificaciones locales
      await _initializeLocalNotifications();

      // Inicializar y manejar token
      // await initializeAndManageToken();

      // Configurar listeners
      _setupListeners();

      logger.i('FCM Repository initialized successfully');
    } catch (e) {
      logger.e('Error initializing FCM repository: $e');
      // Reintentar después de 5 segundos
      Future.delayed(
          const Duration(seconds: 5),
          () => initialize(
                onTokenRefresh: onTokenRefresh,
                onPropertyUpdate: onPropertyUpdate,
                onPropertyDetail: onPropertyDetail,
                onHome: onHome,
              ));
    }
  }

  /// Configura FCM para Android con permisos y alta prioridad
  /// Solicita permisos de notificación y alarmas exactas
  /// Habilita métricas de entrega para mejor rendimiento
  Future<void> _configureAndroid() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _requestPermissions();
    await _setHighPriorityMessaging();
  }

  /// Configura FCM para iOS con permisos específicos de la plataforma
  /// Solicita permisos de notificación con configuración optimizada
  /// Habilita auto-inicialización para mejor experiencia
  Future<void> _configureIOS() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _requestIOSPermissions();
    await _firebaseMessaging.setAutoInitEnabled(true);

    logger.i('iOS FCM configuration completed');
  }

  /// Solicita permisos de notificación específicos para iOS
  /// Configura permisos de alerta, badge y sonido
  /// Maneja diferentes estados de autorización
  Future<void> _requestIOSPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      logger.i('iOS Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        logger.e('User denied notification permissions on iOS');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.notDetermined) {
        logger.w('iOS notification permissions not determined');
      } else {
        logger.i('iOS notification permissions granted');
      }
    } catch (e) {
      logger.e('Error requesting iOS FCM permissions: $e');
    }
  }

  /// Solicita permisos de notificación para Android
  /// Incluye permisos para alarmas exactas necesarias para notificaciones programadas
  /// Valida el estado de autorización del usuario
  Future<void> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: true,
        carPlay: false,
        criticalAlert: false,
      );

      logger.i('Android Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        logger.e('User declined or has not accepted notification permissions');
      }

      // Solicitar permiso para alarmas exactas
      var alarmPermissionStatus = await Permission.scheduleExactAlarm.request();
      if (alarmPermissionStatus.isDenied ||
          alarmPermissionStatus.isPermanentlyDenied) {
        logger.e('User denied exact alarm permissions on Android');
      }
    } catch (e) {
      logger.e('Error requesting Android FCM permissions: $e');
    }
  }

  /// Configura Firebase Messaging para alta prioridad
  /// Habilita auto-inicialización y métricas de BigQuery
  /// Mejora la entrega de notificaciones importantes
  Future<void> _setHighPriorityMessaging() async {
    try {
      await _firebaseMessaging.setAutoInitEnabled(true);
      await _firebaseMessaging.setDeliveryMetricsExportToBigQuery(true);
    } catch (e) {
      logger.e('Error setting high priority: $e');
    }
  }

  /// Inicializa el sistema de notificaciones locales
  /// Configura canales de Android y permisos de iOS
  /// Establece timezone correcto para notificaciones programadas
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      requestCriticalPermission: false,
      requestProvisionalPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // CRITICAL: Initialize timezone BEFORE initializing the plugin
    tz.initializeTimeZones();
    final currentTimezoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezoneName));

    logger.i('Timezone initialized: $currentTimezoneName');

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          backgroundNotificationResponseHandler,
    );

    // Crear canal de alta prioridad para Android
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }

    logger.i(
        "Successfully initialized local notifications for ${Platform.isIOS ? 'iOS' : 'Android'}");
  }

  /// Configura los listeners de mensajes FCM
  /// Maneja mensajes en primer plano, background y app cerrada
  /// Establece listener de refresh de tokens
  void _setupListeners() {
    // Mensajes en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('Got a message in foreground!');
      logger.i('Message data: ${message.data}');

      if (message.notification != null) {
        logger.i(
            'Message also contained a notification: ${message.notification}');
      }

      _handleMessage(message);
    });

    // App abierta desde notificación (estaba en background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i('Message clicked! App was in background');
      _handleNotificationTap(message);
    });

    // Verificar si la app fue abierta desde una notificación (estaba cerrada)
    _checkInitialMessage();

    // Configurar listener para refrescos de token
    _setupTokenRefreshListener();
  }

  /// Configura el listener para actualizaciones automáticas de token
  /// Guarda el nuevo token localmente y en base de datos
  /// Notifica a la app sobre el cambio de token
  void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      logger.i('FCM Token refreshed: $newToken');
      _currentToken = newToken;

      try {
        await saveLocalToken(newToken);
        await updateDBToken(newToken);
        _onTokenRefresh?.call(newToken);
      } catch (e) {
        logger.e('Error updating refreshed token: $e');
        _onTokenRefresh?.call(newToken);
      }
    });
  }

  /// Verifica si la app fue abierta desde una notificación
  /// Se ejecuta cuando la app estaba completamente cerrada
  /// Maneja la navegación inicial basada en la notificación
  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      logger.i('App opened from terminated state via notification');
      _handleNotificationTap(initialMessage);
    }
  }

  /// Procesa mensajes FCM recibidos en primer plano
  /// Muestra notificación local y añade al stream
  /// Convierte RemoteMessage a NotificationModel
  Future<void> _handleMessage(RemoteMessage message) async {
    await _showLocalNotification(message);

    final notification = NotificationModel.fromRemoteMessage(message);
    _notificationStreamController.add(notification);
  }

  /// Muestra notificación local basada en RemoteMessage
  /// Aplica estilos específicos por categoría y plataforma
  /// Incluye acciones personalizadas según el tipo
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final categoryString = message.data['category'] ?? 'promotions';
    final category = NotificationCategory.values.firstWhere(
      (e) => e.value == categoryString,
      orElse: () => NotificationCategory.promotions,
    );

    final String? title =
        message.notification?.title ?? (message.data['title'] as String?);
    final String? body = message.notification?.body ??
        (message.data['body'] as String?) ??
        (message.data['message'] as String?);

    if (title == null || title.isEmpty || body == null || body.isEmpty) {
      logger.i('No se muestra notificación local por contenido vacío');
      return;
    }

    NotificationDetails details;

    if (Platform.isAndroid) {
      details = NotificationDetails(
        android: _buildAndroidNotificationDetails(
            category, title, body, message.data),
      );
    } else {
      details = NotificationDetails(
        iOS: _buildIOSNotificationDetails(category, title, body),
      );
    }

    final int notificationId = message.messageId?.hashCode ??
        DateTime.now().millisecondsSinceEpoch.hashCode;

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      details,
      payload: message.data.toString(),
    );

    logger.i(
        'Local notification shown for ${Platform.isIOS ? 'iOS' : 'Android'}');
  }

  /// Construye detalles de notificación específicos para Android
  /// Configura importancia, prioridad y acciones según categoría
  /// Aplica estilos expandidos y configuración de canal
  AndroidNotificationDetails _buildAndroidNotificationDetails(
      NotificationCategory category,
      String title,
      String body,
      Map<String, dynamic> data) {
    return AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: category == NotificationCategory.healthAlert
          ? Importance.max
          : Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      autoCancel: true,
      onlyAlertOnce: true,
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: _getCategorySummary(category),
      ),
      actions: _getNotificationActions(category, data),
    );
  }

  /// Construye detalles de notificación específicos para iOS
  /// Configura badges, sonidos y nivel de interrupción
  /// Agrupa notificaciones por categoría usando threadIdentifier
  DarwinNotificationDetails _buildIOSNotificationDetails(
      NotificationCategory category, String title, String body) {
    return DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
      subtitle: _getCategorySummary(category),
      threadIdentifier: category.value,
      interruptionLevel: category == NotificationCategory.reminder
          ? InterruptionLevel.timeSensitive
          : InterruptionLevel.active,
      categoryIdentifier: _getIOSCategoryIdentifier(category),
    );
  }

  /// Retorna identificador de categoría para iOS
  /// Usado para agrupar y gestionar tipos de notificaciones
  /// Permite configuraciones específicas por tipo en iOS
  String _getIOSCategoryIdentifier(NotificationCategory category) {
    // switch (category) {
    //   case NotificationCategory.propertyUpdateReminder:
    //     return 'PROPERTY_UPDATE_CATEGORY';
    //   case NotificationCategory.propertySuspensionWarning:
    //     return 'PROPERTY_WARNING_CATEGORY';
    //   case NotificationCategory.priceChangeAlert:
    //     return 'PRICE_CHANGE_CATEGORY';
    //   case NotificationCategory.userReengagement:
    //     return 'USER_ENGAGEMENT_CATEGORY';
    //   case NotificationCategory.promotions:
    //     return 'PROMOTIONS_CATEGORY';
    //   case NotificationCategory.newPropertyMatch:
    //     return 'NEW_PROPERTY_MATCH_CATEGORY';
    //   case NotificationCategory.likedPropertySold:
    //     return 'LIKED_PROPERTY_SOLD_CATEGORY';
    // }
    return category.value;
  }

  /// Retorna resumen localizado por categoría de notificación
  /// Texto descriptivo mostrado en la notificación
  /// Ayuda al usuario a entender el tipo de mensaje
  String _getCategorySummary(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.reminder:
        return 'Recordatorio de actualización';
      case NotificationCategory.healthAlert:
        return '⚠️ Advertencia importante';
      case NotificationCategory.medicalInfo:
        return 'Te extrañamos';
      case NotificationCategory.promotions:
        return 'Promoción';
      default:
        return 'Nueva propiedad disponible';
    }
  }

  /// Retorna acciones contextuales para notificaciones Android
  /// Botones de acción rápida según el tipo de notificación
  /// Permite interacción directa sin abrir la app
  List<AndroidNotificationAction>? _getNotificationActions(
      NotificationCategory category, Map<String, dynamic> data) {
    switch (category) {
      case NotificationCategory.reminder:
        return [
          const AndroidNotificationAction(
            'update_now',
            'Actualizar ahora',
            showsUserInterface: true,
          ),
          const AndroidNotificationAction(
            'remind_later',
            'Recordar después',
          ),
        ];
      case NotificationCategory.examResult:
        return [
          const AndroidNotificationAction(
            'view_property',
            'Ver inmueble',
            showsUserInterface: true,
          ),
        ];
      default:
        return null;
    }
  }

  /// Maneja el tap en notificaciones locales
  /// Procesa acciones rápidas y payload de notificación
  /// Ejecuta callbacks de navegación apropiados
  void _onNotificationTapped(NotificationResponse response) {
    logger.i('Notification tapped with payload: ${response.payload}');

    if (response.payload != null) {
      try {
        if (response.actionId == 'update_now') {
          _onPropertyUpdateCallback?.call(null);
        } else if (response.actionId == 'view_property') {
          _onPropertyDetailCallback?.call(null);
        }
      } catch (e) {
        logger.e('Error parsing notification payload: $e');
      }
    }
  }

  /// Maneja el tap en notificaciones push (FCM)
  /// Navega según la categoría y datos del mensaje
  /// Ejecuta callbacks con parámetros específicos
  void _handleNotificationTap(RemoteMessage message) {
    final categoryString = message.data['category'] ?? 'promotions';
    final category = NotificationCategory.values.firstWhere(
      (e) => e.value == categoryString,
      orElse: () => NotificationCategory.promotions,
    );

    switch (category) {
      case NotificationCategory.promotions:
      case NotificationCategory.generalMessage:
        _onPropertyUpdateCallback?.call(message.data['property_id']);
        break;
      case NotificationCategory.examResult:
        _onPropertyDetailCallback?.call(message.data['property_id']);
        break;
      default:
        _onPropertyDetailCallback?.call(message.data['property_id']);
        break;
    }
  }

  @override
  Future<Either<HttpRequestFailure, String>> initializeAndManageToken(
      User user) async {
    try {
      final localToken = await getLocalToken();
      final dbToken = user.fcmToken; //TODO: implement getDBToken with user

      logger.i('Local token: ${localToken != null ? "exists" : "null"}');
      logger.i('DB token: ${dbToken != null ? "exists" : "null"}');

      String? finalToken;

      if (localToken == null && dbToken == null) {
        logger.w('Nuevo usuario, generando primer token FCM');
        finalToken = await _firebaseMessaging.getToken();
        if (finalToken == null) {
          return Either.left(
              HttpRequestFailure.formData("Error al fenerar token FCM"));
        }
      } else if (localToken != null &&
          dbToken != null &&
          localToken == dbToken) {
        logger.i('Tokens coinciden, usando token existente');
        finalToken = localToken;
      } else {
        logger.w('Tokens no coinciden, generando nuevo token FCM');
        finalToken = await _firebaseMessaging.getToken();
        if (finalToken == null) {
          return Either.left(
              HttpRequestFailure.formData("Error al fenerar token FCM"));
        }
      }

      await saveLocalToken(finalToken);

      if (dbToken != finalToken) {
        UserDataInput data = UserDataInput(fcmToken: finalToken);
        final response = await _accountRepository.setDataBasic(data, user.id);

        response.when(left: (error) {
          logger.e('Error actualizando token en BD: $error');
        }, right: (success) {
          logger.i('Token FCM actualizado en BD');
        });
      }

      await subscribeToTopic('all');

      _currentToken = finalToken;
      _onTokenRefresh?.call(finalToken);

      logger.i('Token FCM inicializado correctamente');
      return Either.right(finalToken);
    } catch (e) {
      logger.e('Error inicializando FCM token: $e');
      return Either.left(HttpRequestFailure.unknown());
    }
  }

  @override
  Future<String?> getLocalToken() async {
    try {
      return await _secureStorage.read(key: _fcmTokenKey);
    } catch (e) {
      logger.e('Error leyendo token local: $e');
      return null;
    }
  }

  @override
  Future<void> saveLocalToken(String token) async {
    try {
      await _secureStorage.write(key: _fcmTokenKey, value: token);
      logger.i('Token guardado localmente');
    } catch (e) {
      logger.e('Error guardando token local: $e');
    }
  }

  @override
  Future<String?> getDBToken() async {
    // TODO: implement test
    throw UnimplementedError();
    // try {
    //   final user = _client.auth.currentUser;
    //   if (user == null) return null;
    //
    //   final response = await _client
    //       .from('profiles')
    //       .select('fcm_token')
    //       .eq('id', user.id)
    //       .maybeSingle();
    //
    //   return response?['fcm_token'] as String?;
    // } catch (e) {
    //   logger.e('Error obteniendo token de BD: $e');
    //   return null;
    // }
  }

  @override
  Future<Either<HttpRequestFailure, bool>> updateDBToken(String token) async {
    // TODO: implement test
    throw UnimplementedError();
    // try {
    //   final user = _client.auth.currentUser;
    //   if (user == null) {
    //     return Either.left(const FCMFailure.notAuthenticated());
    //   }
    //
    //   await _client.from('profiles').update({
    //     'fcm_token': token,
    //     'updated_at': DateTime.now().toUtc().toIso8601String(),
    //   }).eq('id', user.id);
    //
    //   logger.i('Token FCM actualizado en BD');
    //   return Either.right(true);
    // } catch (e) {
    //   logger.e('Error actualizando token en BD: $e');
    //   return Either.left(FCMFailure.unknown(e.toString()));
    // }
  }

  @override
  Future<Either<HttpRequestFailure, bool>> subscribeToTopic(
      String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      logger.i('Suscrito al topic: $topic');
      return Either.right(true);
    } catch (e) {
      logger.e('Error suscribiendo a topic $topic: $e');
      return Either.left(HttpRequestFailure.unknown());
    }
  }

  @override
  Future<Either<HttpRequestFailure, bool>> unsubscribeFromTopic(
      String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      logger.i('Desuscrito del topic: $topic');
      return Either.right(true);
    } catch (e) {
      logger.e('Error desuscribiendo de topic $topic: $e');
      return Either.left(HttpRequestFailure.unknown());
    }
  }

  @override
  Future<Either<HttpRequestFailure, bool>> clearToken() async {
    try {
      await _secureStorage.delete(key: _fcmTokenKey);

      // await _client.from('profiles').update({
      //   'fcm_token': null,
      //   'updated_at': DateTime.now().toUtc().toIso8601String(),
      // }).eq('id', user.id);

      await unsubscribeFromTopic('all');
      await _firebaseMessaging.deleteToken();

      logger.i('Token FCM limpiado completamente');
      return Either.right(true);
    } catch (e) {
      logger.e('Error limpiando FCM token: $e');
      return Either.left(HttpRequestFailure.unknown());
    }
  }

  @override
  Future<int> scheduleNotification(
      DateTime scheduledDate, String title, String body) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        autoCancel: true,
        ongoing: false,
        groupKey: 'kasapp_scheduled_notifications',
        setAsGroupSummary: false,
        category: AndroidNotificationCategory.reminder,
        visibility: NotificationVisibility.public,
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
        presentBanner: true,
        presentList: true,
        sound: 'default',
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      final int notificationId = _generateUniqueId();

      final currentTimezoneName = await FlutterTimezone.getLocalTimezone();
      final location = tz.getLocation(currentTimezoneName);
      final scheduledDateTz = tz.TZDateTime.from(scheduledDate, location);
      final now = tz.TZDateTime.now(location);

      if (scheduledDateTz.isBefore(now)) {
        logger.w(
            'Scheduled date is in the past: $scheduledDateTz, current time: $now');
        throw Exception('Cannot schedule notification in the past');
      }

      logger.i('Current timezone: $currentTimezoneName');
      logger.i('Current time: $now');
      logger.i('Scheduled time: $scheduledDateTz');
      logger.i(
          'Time difference: ${scheduledDateTz.difference(now).inSeconds} seconds');
      logger.i('Using notification ID: $notificationId');

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledDateTz,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'scheduled_notification_$notificationId',
      );

      logger.i(
          '✅ Notification scheduled successfully for $scheduledDateTz with ID: $notificationId');
      return notificationId;
    } catch (e) {
      logger.e('❌ Error scheduling notification: $e');
      throw Exception('Failed to schedule notification: $e');
    }
  }

  int _generateUniqueId() {
    // Obtener los últimos 7 dígitos del timestamp (para dejar espacio para el random)
    final timestamp = DateTime.now().millisecondsSinceEpoch % 10000000;

    // Generar un número aleatorio de 2 dígitos
    final random = Random().nextInt(100);

    // Combinar timestamp + random
    final combined = timestamp * 100 + random;

    // Asegurar que esté dentro del rango de 32-bit integer
    // El rango es -2,147,483,648 a 2,147,483,647
    return combined &
        0x7FFFFFFF; // Esto asegura que sea positivo y dentro del rango
  }

  @override
  Future<List<int?>> schedulePropertyReminders(
      String propertyId, DateTime creationDate) async {
    try {
      logger.i('📅 Programando recordatorios para propiedad: $propertyId');

      final notificationIds = <int?>[];
      final week2Date = creationDate.add(const Duration(days: 14));
      final week3Date = creationDate.add(const Duration(days: 21));

      final week2NotificationId = await scheduleNotification(
          week2Date,
          '📝 Actualiza tu propiedad',
          'Han pasado 2 semanas desde que publicaste tu propiedad. ¿Sigues interesado en venderla? Actualiza la información para mantenerla visible.');

      final week3NotificationId = await scheduleNotification(
          week3Date,
          '⚠️ Tu propiedad necesita atención',
          'Tu propiedad lleva 3 semanas sin actualizar. Actualízala ahora o se ocultará de las búsquedas.');

      logger.i('✅ Recordatorios programados para propiedad $propertyId:');
      logger.i('   - Semana 2: ID $week2NotificationId para $week2Date');
      logger.i('   - Semana 3: ID $week3NotificationId para $week3Date');
      notificationIds.add(week2NotificationId);
      notificationIds.add(week3NotificationId);
      return notificationIds;
    } catch (e) {
      logger.e('❌ Error programando recordatorios de propiedad: $e');
      return [];
    }
  }

  @override
  Future<void> reschedulePropertyReminders(
      String propertyId, DateTime updateDate) async {
    try {
      logger.i('🔄 Reagendando recordatorios para propiedad: $propertyId');

      // await cancelPropertyReminders(propertyId);
      await schedulePropertyReminders(propertyId, updateDate);

      logger.i(
          '✅ Recordatorios reagendados para propiedad $propertyId desde $updateDate');
    } catch (e) {
      logger.e('❌ Error reagendando recordatorios de propiedad: $e');
      throw Exception('Failed to reschedule property reminders: $e');
    }
  }

  @override
  Future<void> cancelPropertyReminders(
      int? notificationId1, int? notificationId2) async {
    try {
      logger.w('🗑️ Cancelando recordatorios de propiedad...');
      if (notificationId1 != null) {
        await cancelScheduledNotification(notificationId1);
        logger.i('   - Cancelada notificación semana 2: $notificationId1');
      }

      if (notificationId2 != null) {
        await cancelScheduledNotification(notificationId2);
        logger.i('   - Cancelada notificación semana 3: $notificationId2');
      }

      logger.i('✅ Recordatorios cancelados');
    } catch (e) {
      logger.e('❌ Error cancelando recordatorios de propiedad: $e');
      throw Exception('Failed to cancel property reminders: $e');
    }
  }

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pendingNotificationRequests =
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      logger.i(
          '📋 Notificaciones pendientes: ${pendingNotificationRequests.length}');

      for (var notification in pendingNotificationRequests) {
        logger.i('   - ID: ${notification.id}, Title: ${notification.title}');
      }

      return pendingNotificationRequests;
    } catch (e) {
      logger.e('❌ Error obteniendo notificaciones pendientes: $e');
      return [];
    }
  }

  @override
  Future<void> cancelAllScheduledNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      logger.i('🗑️ Todas las notificaciones programadas han sido canceladas');
    } catch (e) {
      logger.e('❌ Error cancelando todas las notificaciones: $e');
      throw Exception('Failed to cancel all scheduled notifications: $e');
    }
  }

  @override
  Future<void> cancelScheduledNotification(int notificationId) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(notificationId);
      logger.i('🗑️ Notificación cancelada con ID: $notificationId');
    } catch (e) {
      logger.e('❌ Error cancelando notificación $notificationId: $e');
      throw Exception('Failed to cancel scheduled notification: $e');
    }
  }

  @override
  Future<void> showTestNotification() async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        999999,
        '🧪 Notificación de prueba',
        'Esta es una notificación de prueba para verificar que el sistema funciona correctamente.',
        details,
        payload: 'test_notification',
      );

      logger.i('🧪 Notificación de prueba mostrada');
    } catch (e) {
      logger.e('❌ Error mostrando notificación de prueba: $e');
      throw Exception('Failed to show test notification: $e');
    }
  }

  @override
  Future<List<int>> testScheduledNotifications() async {
    try {
      logger.i('🧪 Iniciando test completo de notificaciones programadas...');

      final List<int> notificationIds = [];
      final now = DateTime.now();

      // 1. Mostrar notificación inmediata
      await showTestNotification();
      logger.i('✅ Notificación inmediata mostrada');

      // 2. Programar notificación a 1 minuto
      final oneMinuteId = await scheduleNotification(
          now.add(const Duration(minutes: 1)),
          '⏰ Test 1 minuto',
          'Esta notificación fue programada hace 1 minuto - Test exitoso!');
      notificationIds.add(oneMinuteId);
      logger.i('📅 Notificación programada para 1 minuto - ID: $oneMinuteId');

      // 3. Programar notificación a 2 minutos
      final twoMinutesId = await scheduleNotification(
          now.add(const Duration(minutes: 2)),
          '⏰ Test 2 minutos',
          'Esta notificación fue programada hace 2 minutos - Test exitoso!');
      notificationIds.add(twoMinutesId);
      logger.i('📅 Notificación programada para 2 minutos - ID: $twoMinutesId');

      // 4. Programar notificación a 10 minutos
      final tenMinutesId = await scheduleNotification(
          now.add(const Duration(minutes: 10)),
          '⏰ Test 10 minutos',
          'Esta notificación fue programada hace 10 minutos - Test exitoso!');
      notificationIds.add(tenMinutesId);
      logger
          .i('📅 Notificación programada para 10 minutos - ID: $tenMinutesId');

      // 5. Programar notificación a 1 hora
      final oneHourId = await scheduleNotification(
          now.add(const Duration(hours: 1)),
          '⏰ Test 1 hora',
          'Esta notificación fue programada hace 1 hora - Test exitoso!');
      notificationIds.add(oneHourId);
      logger.i('📅 Notificación programada para 1 hora - ID: $oneHourId');

      // 6. Programar notificación a 24 horas
      final twentyFourHoursId = await scheduleNotification(
          now.add(const Duration(hours: 24)),
          '⏰ Test 24 horas',
          'Esta notificación fue programada hace 24 horas - Test exitoso!');
      notificationIds.add(twentyFourHoursId);
      logger.i(
          '📅 Notificación programada para 24 horas - ID: $twentyFourHoursId');

      // Mostrar resumen del test
      logger.i('🎯 Test de notificaciones programadas completado:');
      logger.i('   ✅ Notificación inmediata: Mostrada');
      logger.i('   📅 1 minuto: ID $oneMinuteId');
      logger.i('   📅 2 minutos: ID $twoMinutesId');
      logger.i('   📅 10 minutos: ID $tenMinutesId');
      logger.i('   📅 1 hora: ID $oneHourId');
      logger.i('   📅 24 horas: ID $twentyFourHoursId');
      logger.i(
          '   📊 Total notificaciones programadas: ${notificationIds.length}');

      // Mostrar notificaciones pendientes
      final pendingNotifications = await getPendingNotifications();
      logger.i(
          '📋 Notificaciones pendientes después del test: ${pendingNotifications.length}');

      return notificationIds;
    } catch (e) {
      logger.e('❌ Error en test de notificaciones programadas: $e');
      throw Exception('Failed to execute scheduled notifications test: $e');
    }
  }

  @override
  void updateNavigationCallbacks({
    Function(String?)? onPropertyUpdate,
    Function(String?)? onPropertyDetail,
    Function()? onHome,
  }) {
    if (onPropertyUpdate != null) _onPropertyUpdateCallback = onPropertyUpdate;
    if (onPropertyDetail != null) _onPropertyDetailCallback = onPropertyDetail;
    if (onHome != null) _onHomeCallback = onHome;

    logger.i('🔄 Callbacks de navegación actualizados');
  }
}
