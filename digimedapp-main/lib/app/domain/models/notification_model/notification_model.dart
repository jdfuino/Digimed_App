import 'package:digimed/app/domain/constants/notification_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';


part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
@JsonSerializable(createFactory: false)
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    required String title,
    required String body,
    @Default({}) Map<String, dynamic> data,
    required NotificationCategory category,
    @Default(false) bool read,
    String? imageUrl,
    DateTime? readAt,
    String? notificationType,
    String? targetType,
    String? targetValue,
    String? status,
    DateTime? deliveredAt,
    DateTime? notificationCreatedAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Detectar si viene del GraphQL (id como int) o de otras fuentes
    if (json['id'] is int) {
      // Viene del GraphQL, usar la lógica de fromGraphQLData
      return NotificationModel(
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        data: (json['data'] as Map<String, dynamic>?) ?? {},
        category: NotificationCategory.fromString(json['category'] as String),
        read: json['read'] as bool? ?? false,
        imageUrl: null, // No viene en el GraphQL
        readAt: null, // No viene en el GraphQL
        notificationType: null,
        targetType: null,
        targetValue: null,
        status: null,
        deliveredAt: null,
        notificationCreatedAt: null,
      );
    } else {
      // Para otros casos, usar construcción manual también
      return NotificationModel(
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        data: (json['data'] as Map<String, dynamic>?) ?? {},
        category: NotificationCategory.fromString(json['category'] as String),
        read: json['read'] as bool? ?? false,
        imageUrl: json['imageUrl'] as String?,
        readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
        notificationType: json['notificationType'] as String?,
        targetType: json['targetType'] as String?,
        targetValue: json['targetValue'] as String?,
        status: json['status'] as String?,
        deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
        notificationCreatedAt: json['notificationCreatedAt'] != null ? DateTime.parse(json['notificationCreatedAt']) : null,
      );
    }
  }

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      id: 55,
      title: message.notification?.title ?? 'Nueva notificación',
      body: message.notification?.body ?? '',
      data: message.data,
      category: NotificationCategory.fromString(message.data['category'] ?? 'promotions'),
      imageUrl: message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl,
      // Los campos del inbox no están disponibles en RemoteMessage
      notificationType: null,
      targetType: null,
      targetValue: null,
      status: null,
      deliveredAt: null,
      notificationCreatedAt: null,
    );
  }

  // Nuevo factory constructor para datos del inbox
  factory NotificationModel.fromInboxData(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'] as int,
      title: data['title'] as String,
      body: data['body'] as String,
      data: (data['data'] as Map<String, dynamic>?) ?? {},
      category: NotificationCategory.fromString(data['category'] as String),
      read: data['is_read'] as bool? ?? false,
      imageUrl: data['image_url'] as String?,
      readAt: data['read_at'] != null
          ? DateTime.parse(data['read_at'] as String)
          : null,
      notificationType: data['notification_type'] as String?,
      targetType: data['target_type'] as String?,
      targetValue: data['target_value'] as String?,
      status: data['status'] as String?,
      deliveredAt: data['delivered_at'] != null
          ? DateTime.parse(data['delivered_at'] as String)
          : null,
      notificationCreatedAt: data['notification_created_at'] != null
          ? DateTime.parse(data['notification_created_at'] as String)
          : null,
    );
  }

  // Factory constructor para notificaciones del GraphQL
  factory NotificationModel.fromGraphQLData(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'] as int, // El servidor envía id como int
      title: data['title'] as String,
      body: data['body'] as String,
      data: (data['data'] as Map<String, dynamic>?) ?? {},
      category: NotificationCategory.fromString(data['category'] as String),
      read: data['read'] as bool? ?? false,
      imageUrl: null, // No viene en el GraphQL
      readAt: null, // No viene en el GraphQL
      notificationType: null,
      targetType: null,
      targetValue: null,
      status: null,
      deliveredAt: null,
      notificationCreatedAt: null,
    );
  }

  // Helper method para extraer property_id del campo data
  static String? _extractPropertyId(Map<String, dynamic>? data) {
    if (data == null) return null;
    return data['property_id'] as String?;
  }
}