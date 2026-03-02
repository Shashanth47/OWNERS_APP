import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a document
  Future<void> createDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).set(data);
    } catch (e) {
      throw Exception('Failed to create document: $e');
    }
  }

  // Read a single document
  Future<DocumentSnapshot> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  // Read a collection
  Future<QuerySnapshot> getCollection({
    required String collection,
    Query Function(Query query)? queryBuilder,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      return await query.get();
    } catch (e) {
      throw Exception('Failed to get collection: $e');
    }
  }

  // Update a document
  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  // Delete a document
  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Listen to a document
  Stream<DocumentSnapshot> listenToDocument({
    required String collection,
    required String docId,
  }) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }

  // Listen to a collection
  Stream<QuerySnapshot> listenToCollection({
    required String collection,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = _firestore.collection(collection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }

  // Batch write
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        final type = operation['type'] as String;
        final collection = operation['collection'] as String;
        final docId = operation['docId'] as String;
        final ref = _firestore.collection(collection).doc(docId);

        switch (type) {
          case 'set':
            batch.set(ref, operation['data'] as Map<String, dynamic>);
            break;
          case 'update':
            batch.update(ref, operation['data'] as Map<String, dynamic>);
            break;
          case 'delete':
            batch.delete(ref);
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to perform batch write: $e');
    }
  }

  // Transaction
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler,
  ) async {
    try {
      return await _firestore.runTransaction(transactionHandler);
    } catch (e) {
      throw Exception('Transaction failed: $e');
    }
  }
}
