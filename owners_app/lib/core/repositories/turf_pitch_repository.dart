import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/turf_pitch_model.dart';
import '../services/firestore_service.dart';

class TurfPitchRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final String collection = 'turfPitches';
  final Uuid _uuid = const Uuid();

  // Create a new pitch
  Future<TurfPitchModel> createPitch(TurfPitchModel pitch) async {
    try {
      final String id = pitch.id.isEmpty ? _uuid.v4() : pitch.id;
      final now = DateTime.now();

      final newPitch = pitch.copyWith(
        id: id,
        createdAt: now,
        updatedAt: now,
      );

      await _firestoreService.createDocument(
        collection: collection,
        docId: id,
        data: newPitch.toJson(),
      );

      return newPitch;
    } catch (e) {
      throw Exception('Failed to create pitch: $e');
    }
  }

  // Get pitch by ID
  Future<TurfPitchModel?> getPitchById(String id) async {
    try {
      final doc = await _firestoreService.getDocument(
        collection: collection,
        docId: id,
      );

      if (doc.exists) {
        return TurfPitchModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get pitch: $e');
    }
  }

  // Get all pitches
  Future<List<TurfPitchModel>> getAllPitches() async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
      );

      return querySnapshot.docs
          .map((doc) => TurfPitchModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all pitches: $e');
    }
  }

  // Get pitches by owner/manager
  Future<List<TurfPitchModel>> getPitchesByManager(String managerId) async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
        queryBuilder: (query) => query.where('managerId', isEqualTo: managerId),
      );

      return querySnapshot.docs
          .map((doc) => TurfPitchModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pitches by manager: $e');
    }
  }

  // Get active pitches
  Future<List<TurfPitchModel>> getActivePitches() async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
        queryBuilder: (query) => query.where('isActive', isEqualTo: true),
      );

      return querySnapshot.docs
          .map((doc) => TurfPitchModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get active pitches: $e');
    }
  }

  // Update pitch
  Future<void> updatePitch(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestoreService.updateDocument(
        collection: collection,
        docId: id,
        data: data,
      );
    } catch (e) {
      throw Exception('Failed to update pitch: $e');
    }
  }

  // Delete pitch
  Future<void> deletePitch(String id) async {
    try {
      await _firestoreService.deleteDocument(
        collection: collection,
        docId: id,
      );
    } catch (e) {
      throw Exception('Failed to delete pitch: $e');
    }
  }

  // Listen to pitches by owner/manager
  Stream<List<TurfPitchModel>> listenToPitchesByManager(String managerId) {
    return _firestoreService.listenToCollection(
      collection: collection,
      queryBuilder: (query) => query.where('managerId', isEqualTo: managerId),
    ).map((snapshot) {
      return snapshot.docs
          .map((doc) => TurfPitchModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  // Listen to all active pitches
  Stream<List<TurfPitchModel>> listenToActivePitches() {
    return _firestoreService.listenToCollection(
      collection: collection,
      queryBuilder: (query) => query.where('isActive', isEqualTo: true),
    ).map((snapshot) {
      return snapshot.docs
          .map((doc) => TurfPitchModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }
}
