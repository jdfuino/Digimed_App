//enum for status of treatment

enum TreatmentStatus {
  pendingToStart('PENDING_INITIATION'),
  inProgress('PROGRESS'),
  completed('FINISHED'),
  paused('PAUSED');

  final String value;
  const TreatmentStatus(this.value);

  static TreatmentStatus fromString(String value) {
    return TreatmentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TreatmentStatus.pendingToStart,
    );
  }
}