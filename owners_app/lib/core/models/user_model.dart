import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../enums/user_role.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.role = UserRole.customer,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: UserRole.fromJson(json['role'] as String? ?? 'customer'),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  // Copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        phoneNumber,
        displayName,
        photoUrl,
        role,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName, role: $role)';
  }
}
