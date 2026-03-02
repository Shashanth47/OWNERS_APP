import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final DateTime startTime;
  final DateTime endTime;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  // Calculate duration in hours
  double get durationInHours {
    return endTime.difference(startTime).inMinutes / 60;
  }

  // Check if this slot overlaps with another
  bool overlapsWith(TimeSlot other) {
    return startTime.isBefore(other.endTime) && endTime.isAfter(other.startTime);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
    };
  }

  // Create from JSON
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
    );
  }

  // Create a copy with updated fields
  TimeSlot copyWith({
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return TimeSlot(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  List<Object?> get props => [startTime, endTime];

  @override
  String toString() {
    return 'TimeSlot(startTime: $startTime, endTime: $endTime)';
  }
}
