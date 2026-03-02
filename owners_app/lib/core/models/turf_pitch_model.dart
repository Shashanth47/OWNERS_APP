import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TurfPitchModel extends Equatable {
  final String id;
  final String name;
  final String type; // 5v5, 7v7, 11v11
  final String managerId; // Changed from ownerId to match database schema
  final bool isActive;
  final double pricePerHour;
  final String? description;
  final List<String>? amenities;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TurfPitchModel({
    required this.id,
    required this.name,
    required this.type,
    required this.managerId,
    this.isActive = true,
    required this.pricePerHour,
    this.description,
    this.amenities,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'managerId': managerId,
      'isActive': isActive,
      'pricePerHour': pricePerHour,
      'description': description,
      'amenities': amenities,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory TurfPitchModel.fromJson(Map<String, dynamic> json) {
    return TurfPitchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      managerId: json['managerId'] as String,
      isActive: json['isActive'] as bool? ?? true,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      description: json['description'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory TurfPitchModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TurfPitchModel.fromJson(data);
  }

  // Copy with updated fields
  TurfPitchModel copyWith({
    String? id,
    String? name,
    String? type,
    String? managerId,
    bool? isActive,
    double? pricePerHour,
    String? description,
    List<String>? amenities,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TurfPitchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      managerId: managerId ?? this.managerId,
      isActive: isActive ?? this.isActive,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        managerId,
        isActive,
        pricePerHour,
        description,
        amenities,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'TurfPitchModel(id: $id, name: $name, type: $type, pricePerHour: $pricePerHour)';
  }
}
