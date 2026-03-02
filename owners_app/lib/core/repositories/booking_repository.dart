import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/booking_model.dart';
import '../models/time_slot_model.dart';
import '../services/firestore_service.dart';

class BookingRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final String collection = 'bookings';
  final Uuid _uuid = const Uuid();

  // Create a new booking
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      final String id = booking.id.isEmpty ? _uuid.v4() : booking.id;
      final now = DateTime.now();

      final newBooking = booking.copyWith(
        id: id,
        createdAt: now,
        updatedAt: now,
      );

      await _firestoreService.createDocument(
        collection: collection,
        docId: id,
        data: newBooking.toJson(),
      );

      return newBooking;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  // Get booking by ID
  Future<BookingModel?> getBookingById(String id) async {
    try {
      final doc = await _firestoreService.getDocument(
        collection: collection,
        docId: id,
      );

      if (doc.exists) {
        return BookingModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  // Get all bookings
  Future<List<BookingModel>> getAllBookings() async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
      );

      return querySnapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all bookings: $e');
    }
  }

  // Get bookings by pitch
  Future<List<BookingModel>> getBookingsByPitch(String pitchId) async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
        queryBuilder: (query) => query.where('pitchId', isEqualTo: pitchId),
      );

      return querySnapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get bookings by pitch: $e');
    }
  }

  // Get bookings by user
  Future<List<BookingModel>> getBookingsByUser(String userId) async {
    try {
      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
        queryBuilder: (query) => query
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true),
      );

      return querySnapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get bookings by user: $e');
    }
  }

  // Get bookings by date
  Future<List<BookingModel>> getBookingsByDate(DateTime date) async {
    try {
      // Get start and end of day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
        queryBuilder: (query) => query
            .where('bookingDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('bookingDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay)),
      );

      return querySnapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get bookings by date: $e');
    }
  }

  // Get bookings by pitch and date
  Future<List<BookingModel>> getBookingsByPitchAndDate(
    String pitchId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
        queryBuilder: (query) => query
            .where('pitchId', isEqualTo: pitchId)
            .where('bookingDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('bookingDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay)),
      );

      return querySnapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get bookings by pitch and date: $e');
    }
  }

  // Check if slot is available
  Future<bool> isSlotAvailable({
    required String pitchId,
    required DateTime date,
    required TimeSlot timeSlot,
    String? excludeBookingId,
  }) async {
    try {
      final bookings = await getBookingsByPitchAndDate(pitchId, date);

      for (final booking in bookings) {
        // Skip the booking being updated
        if (excludeBookingId != null && booking.id == excludeBookingId) {
          continue;
        }

        // Only check confirmed and pending bookings
        if (booking.status.name == 'confirmed' || booking.status.name == 'pending') {
          if (timeSlot.overlapsWith(booking.timeSlot)) {
            return false;
          }
        }
      }

      return true;
    } catch (e) {
      throw Exception('Failed to check slot availability: $e');
    }
  }

  // Update booking
  Future<void> updateBooking(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestoreService.updateDocument(
        collection: collection,
        docId: id,
        data: data,
      );
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  // Cancel booking
  Future<void> cancelBooking(String id) async {
    try {
      await updateBooking(id, {'status': 'cancelled'});
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  // Delete booking
  Future<void> deleteBooking(String id) async {
    try {
      await _firestoreService.deleteDocument(
        collection: collection,
        docId: id,
      );
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }

  // Listen to bookings by pitch
  Stream<List<BookingModel>> listenToBookingsByPitch(String pitchId) {
    return _firestoreService.listenToCollection(
      collection: collection,
      queryBuilder: (query) => query
          .where('pitchId', isEqualTo: pitchId)
          .orderBy('bookingDate', descending: false),
    ).map((snapshot) {
      return snapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  // Listen to bookings by user
  Stream<List<BookingModel>> listenToBookingsByUser(String userId) {
    return _firestoreService.listenToCollection(
      collection: collection,
      queryBuilder: (query) => query
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true),
    ).map((snapshot) {
      return snapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  // Get bookings for multiple pitches (useful for owners with multiple pitches)
  Future<List<BookingModel>> getBookingsByPitches(List<String> pitchIds) async {
    try {
      if (pitchIds.isEmpty) return [];

      final querySnapshot = await _firestoreService.getCollection(
        collection: collection,
        queryBuilder: (query) => query
            .where('pitchId', whereIn: pitchIds)
            .orderBy('bookingDate', descending: true),
      );

      return querySnapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get bookings by pitches: $e');
    }
  }

  // Listen to bookings for multiple pitches
  Stream<List<BookingModel>> listenToBookingsByPitches(List<String> pitchIds) {
    if (pitchIds.isEmpty) {
      return Stream.value([]);
    }

    return _firestoreService.listenToCollection(
      collection: collection,
      queryBuilder: (query) => query
          .where('pitchId', whereIn: pitchIds)
          .orderBy('bookingDate', descending: true),
    ).map((snapshot) {
      return snapshot.docs
          .map((doc) => BookingModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }
}
