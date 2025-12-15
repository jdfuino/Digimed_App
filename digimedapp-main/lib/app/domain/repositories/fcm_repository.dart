import 'package:digimed/app/domain/either/either.dart';
import 'package:digimed/app/domain/failures/http_request/http_request_failure.dart';
import 'package:digimed/app/domain/models/user/user.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


abstract class FCMRepository {
  /// Inicializa el servicio FCM con los callbacks de navegación
  /// Configura notificaciones locales y listeners de mensajes
  /// Debe llamarse al inicio de la aplicación
  Future<void> initialize({
    Function(String)? onTokenRefresh,
    Function(String?)? onPropertyUpdate,
    Function(String?)? onPropertyDetail,
    Function()? onHome,
  });

  /// Obtiene y gestiona el token FCM del dispositivo
  /// Sincroniza entre almacenamiento local y base de datos
  /// Retorna el token actual o un error específico
  Future<Either<HttpRequestFailure, String>> initializeAndManageToken(User user);

  /// Obtiene el token FCM almacenado localmente
  /// Retorna null si no existe token guardado
  Future<String?> getLocalToken();

  /// Guarda el token FCM en almacenamiento seguro local
  /// Usado para comparaciones y recuperación offline
  Future<void> saveLocalToken(String token);

  /// Obtiene el token FCM desde la base de datos
  /// Retorna null si el usuario no está autenticado o no tiene token
  Future<String?> getDBToken();

  /// Actualiza el token FCM en la base de datos del usuario
  /// Sincroniza el token local con el servidor
  Future<Either<HttpRequestFailure, bool>> updateDBToken(String token);

  /// Limpia completamente el token FCM del dispositivo y BD
  /// Usado durante logout o desinstalación
  Future<Either<HttpRequestFailure, bool>> clearToken();

  /// Suscribe el dispositivo a un topic específico de notificaciones
  /// Permite recibir mensajes broadcast a grupos de usuarios
  Future<Either<HttpRequestFailure, bool>> subscribeToTopic(String topic);

  /// Desuscribe el dispositivo de un topic de notificaciones
  /// Deja de recibir mensajes del topic especificado
  Future<Either<HttpRequestFailure, bool>> unsubscribeFromTopic(String topic);

  /// Programa una notificación local para una fecha específica
  /// Retorna el ID de la notificación para poder cancelarla después
  Future<int> scheduleNotification(DateTime scheduledDate, String title, String body);

  /// Sistema de recordatorios automáticos para propiedades (semana 2 y 3)
  /// Programa notificaciones basadas en la fecha de creación
  Future<List<int?>> schedulePropertyReminders(String propertyId, DateTime creationDate);

  /// Reprograma los recordatorios de una propiedad desde nueva fecha
  /// Cancela los anteriores y programa nuevos desde updateDate
  Future<void> reschedulePropertyReminders(String propertyId, DateTime updateDate);

  /// Cancela todos los recordatorios pendientes de una propiedad
  /// Elimina notificaciones programadas y marca como cancelado en BD
  Future<void> cancelPropertyReminders(int? notificationId1, int? notificationId2);

  /// Obtiene lista de todas las notificaciones pendientes programadas
  /// Útil para debugging y gestión de notificaciones
  Future<List<PendingNotificationRequest>> getPendingNotifications();

  /// Cancela todas las notificaciones programadas del dispositivo
  /// Limpieza completa del sistema de notificaciones locales
  Future<void> cancelAllScheduledNotifications();

  /// Cancela una notificación específica por su ID
  /// Remueve notificaciones individuales del sistema
  Future<void> cancelScheduledNotification(int notificationId);

  /// Muestra una notificación de prueba inmediata
  /// Para testing y verificación del sistema de notificaciones
  Future<void> showTestNotification();

  /// Test completo de notificaciones programadas
  /// Muestra una notificación inmediata y programa notificaciones a intervalos específicos
  /// (1min, 2min, 10min, 1h, 24h) para verificar el sistema completo
  Future<List<int>> testScheduledNotifications();

  /// Actualiza los callbacks de navegación dinámicamente
  /// Permite cambiar el comportamiento de tap en notificaciones
  void updateNavigationCallbacks({
    Function(String?)? onPropertyUpdate,
    Function(String?)? onPropertyDetail,
    Function()? onHome,
  });
}