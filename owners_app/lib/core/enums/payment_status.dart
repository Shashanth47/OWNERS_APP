enum PaymentStatus {
  pending,
  paid,
  refunded;

  String toJson() => name;

  static PaymentStatus fromJson(String json) {
    return PaymentStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => PaymentStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }
}
