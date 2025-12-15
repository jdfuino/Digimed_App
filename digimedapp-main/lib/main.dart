import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digimed/app/data/http/grapgh_ql_digimed.dart';
import 'package:digimed/app/data/http/http.dart';
import 'package:digimed/app/data/providers/firebase/firebase_api.dart';
import 'package:digimed/app/domain/globals/session_service.dart';
import 'package:digimed/app/inject_repositories.dart';
import 'package:digimed/app/presentation/global/controllers/session_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:digimed/app/data/providers/remote/internet_checker.dart';
import 'package:digimed/app/my_app.dart';

import 'app/domain/globals/logger.dart';

// Definición única del manejador de fondo
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // IMPORTANTE: Inicializar Firebase antes de hacer cualquier otra cosa
    await Firebase.initializeApp(
      options: (Platform.isIOS || Platform.isMacOS)
          ? const FirebaseOptions(
        apiKey: 'AIzaSyABCS2571K-PBYzw3Ldj2dU3ZCo3iEItP8',
        appId: '1:142891599860:ios:899e31d30a5c2ad9d89ba1',
        messagingSenderId: '142891599860',
        projectId: 'kasapp-b75f3',
        storageBucket: 'kasapp-b75f3.firebasestorage.app',
      )
          : const FirebaseOptions(
        apiKey: 'AIzaSyBxCCYzqDwKDJFSSlug3X9g6j3GsJ6DkCY',
        appId: '1:142891599860:android:ec53f697409414f1d89ba1',
        messagingSenderId: '142891599860',
        projectId: 'kasapp-b75f3',
        storageBucket: 'kasapp-b75f3.firebasestorage.app',
      ),
    );

    // Solución para evitar notificaciones duplicadas:
    // Solo mostrar nuestra propia notificación si el mensaje es de tipo datos
    // o si estamos en iOS (iOS no muestra automáticamente las notificaciones como Android)
    if (Platform.isAndroid && message.notification != null) {
      // En Android, si el mensaje ya tiene una notificación, Firebase la muestra automáticamente
      // No es necesario crear otra notificación local
      return;
    }

    // En iOS siempre necesitamos mostrar la notificación local
    // ya que las notificaciones en background no se muestran automáticamente

    // Inicializar Flutter Local Notifications
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // Configuración para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Crear canal de alta prioridad para Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max, // Usar MAX para garantizar que lleguen
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // Crear notificación local solo si hay contenido para mostrar
    final String? title = message.notification?.title ??
        (message.data['title'] as String?);
    final String? body = message.notification?.body ??
        (message.data['body'] as String?) ??
        (message.data['message'] as String?);

    // Solo mostrar notificación si hay contenido válido
    if (title == null || title.isEmpty || body == null || body.isEmpty) {
      return; // No mostrar notificaciones vacías
    }

    // Crear detalles específicos por plataforma
    NotificationDetails platformChannelSpecifics;

    if (Platform.isAndroid) {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@drawable/ic_notification',
        ticker: title,
      );

      platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    } else {
      // iOS
      const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      platformChannelSpecifics = const NotificationDetails(iOS: iosPlatformChannelSpecifics);
    }

    // Mostrar la notificación con ID único basado en el messageId para evitar duplicados
    await flutterLocalNotificationsPlugin.show(
      message.messageId?.hashCode ?? message.hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  } catch (e) {
    // Capturar errores silenciosamente
  }
}

// Para manejar las interacciones con notificaciones locales en segundo plano
@pragma('vm:entry-point')
void backgroundNotificationResponseHandler(
    NotificationResponse notificationResponse) {
  // No podemos navegar directamente desde aquí porque estamos en un aislado (isolate) diferente
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // config acc to platform
  final FirebaseOptions firebaseOptions = (Platform.isIOS || Platform.isMacOS)
      ? const FirebaseOptions(
          apiKey: 'AIzaSyBWzLnP5r0bbyk9Yj2Ca1k0TokU89mdDqE',
          appId: '1:130351280458:ios:4c5d9b3ad8db8cd30351b3',
          messagingSenderId: '130351280458',
          projectId: 'digimed-ae1d4',
          storageBucket: 'digimed-ae1d4.appspot.com',
        )
      : const FirebaseOptions(
          apiKey: 'AIzaSyDAtlBo5nY5e-TxLH0-K9V5ii5SZCpMARw',
          appId: '1:130351280458:android:7d86a3357e1773970351b3',
          messagingSenderId: '130351280458',
          projectId: 'digimed-ae1d4',
          storageBucket: 'digimed-ae1d4.appspot.com',
        );

  await Firebase.initializeApp(options: firebaseOptions);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Crear instancia única de FirebaseMessaging
  final firebaseMessaging = FirebaseMessaging.instance;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final http = Http(
    client: Client(),
    baseUrl: 'https://hook.eu2.make.com/',
    apiKey: '4248991ee7e5702debde74e854effa57',
  );

  final HttpLink httpLink = HttpLink(
    //'http://172.16.0.171:4000/query'
    //'http://172.16.0.153:4000/query'
    'https://digimed.priver.app/query',
    // 'https://devdigimed.priver.app/query',
  );

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );

  final GraphQLDigimed graphQLDigimed = GraphQLDigimed(
    client: client,
    link:
        //'http://172.16.0.171:4000/query'
        //'http://172.16.0.153:4000/query'
        'https://digimed.priver.app/query',
        // 'https://devdigimed.priver.app/query',
  );

  final NavigationService navigationService = NavigationService();
  await injectRepositories(
      connectivity: Connectivity(),
      http: http,
      secureStorage: const FlutterSecureStorage(),
      internetChecker: InternetChecker(),
      imagePicker: ImagePicker(),
      imageCropper: ImageCropper(),
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
      firebaseMessaging: firebaseMessaging,
      navigationService: navigationService,
      graphQLDigimed: graphQLDigimed);

  logger.i('Initializing FCM Repository...');
  await Repositories.fcm.initialize(
    onTokenRefresh: (token) {
      logger.i('FCM Token refreshed: $token');
    },
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionController>(
            create: (_) => SessionController(
                authenticationRepository: Repositories.authentication)),
      ],
      child: const MyApp(),
    ),
  );
}
