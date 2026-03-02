import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final String collection = 'users';

  // Create or update user
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestoreService.createDocument(
        collection: collection,
        docId: user.uid,
        data: user.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestoreService.getDocument(
        collection: collection,
        docId: uid,
      );

      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
        queryBuilder: (query) => query.where('email', isEqualTo: email).limit(1),
      );

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromDocumentSnapshot(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  // Update user
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestoreService.updateDocument(
        collection: collection,
        docId: uid,
        data: data,
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _firestoreService.deleteDocument(
        collection: collection,
        docId: uid,
      );
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Listen to user changes
  Stream<UserModel?> listenToUser(String uid) {
    return _firestoreService.listenToDocument(
      collection: collection,
      docId: uid,
    ).map((doc) {
      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
      }
      return null;
    });
  }

  // Get all users (for admin purposes)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
      );

      return querySnapshot.docs
          .map((doc) => UserModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }
}
