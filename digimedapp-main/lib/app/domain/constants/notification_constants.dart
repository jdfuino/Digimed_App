enum NotificationCategory {
  generalMessage('general_message'),
  healthAlert('health_alert'),
  examResult('exam_result'),
  reminder('reminder'),
  medicalInfo('medical_info'),
  success('success'),
  error('error'),
  promotions('promotions');

  final String value;
  const NotificationCategory(this.value);

  static NotificationCategory fromString(String value) {
    return NotificationCategory.values.firstWhere(
          (e) => e.value == value,
      orElse: () => NotificationCategory.promotions,
    );
  }
}

enum NotificationPriority {
  high('high'),
  normal('normal');

  final String value;
  const NotificationPriority(this.value);
}