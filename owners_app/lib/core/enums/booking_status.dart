enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed;

  String toJson() => name;

  static BookingStatus fromJson(String json) {
    return BookingStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => BookingStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }
}
