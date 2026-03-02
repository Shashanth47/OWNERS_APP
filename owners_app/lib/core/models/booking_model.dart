import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/booking_status.dart';
import '../enums/payment_status.dart';
import 'time_slot_model.dart';

class BookingModel extends Equatable {
  final String id;
  final String pitchId;
  final String userId;
  final String customerName;
  final String customerPhone;
  final DateTime bookingDate;
  final TimeSlot timeSlot;
  final int durationHours;
  final BookingStatus status;
  final double totalAmount;
  final PaymentStatus paymentStatus;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingModel({
    required this.id,
    required this.pitchId,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.bookingDate,
    required this.timeSlot,
    required this.durationHours,
    this.status = BookingStatus.pending,
    required this.totalAmount,
    this.paymentStatus = PaymentStatus.pending,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pitchId': pitchId,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'startTime': Timestamp.fromDate(timeSlot.startTime),
      'endTime': Timestamp.fromDate(timeSlot.endTime),
      'durationHours': durationHours,
      'status': status.toJson(),
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus.toJson(),
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      pitchId: json['pitchId'] as String,
      userId: json['userId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      bookingDate: (json['bookingDate'] as Timestamp).toDate(),
      timeSlot: TimeSlot(
        startTime: (json['startTime'] as Timestamp).toDate(),
        endTime: (json['endTime'] as Timestamp).toDate(),
      ),
      durationHours: json['durationHours'] as int,
      status: BookingStatus.fromJson(json['status'] as String? ?? 'pending'),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentStatus: PaymentStatus.fromJson(json['paymentStatus'] as String? ?? 'pending'),
      notes: json['notes'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory BookingModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel.fromJson(data);
  }

  // Copy with updated fields
  BookingModel copyWith({
    String? id,
    String? pitchId,
    String? userId,
    String? customerName,
    String? customerPhone,
    DateTime? bookingDate,
    TimeSlot? timeSlot,
    int? durationHours,
    BookingStatus? status,
    double? totalAmount,
    PaymentStatus? paymentStatus,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      pitchId: pitchId ?? this.pitchId,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot,
      durationHours: durationHours ?? this.durationHours,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        pitchId,
        userId,
        customerName,
        customerPhone,
        bookingDate,
        timeSlot,
        durationHours,
        status,
        totalAmount,
        paymentStatus,
        notes,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'BookingModel(id: $id, customerName: $customerName, date: $bookingDate, status: $status)';
  }
}
