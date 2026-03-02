import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/booking_model.dart';
import '../repositories/booking_repository.dart';
import '../enums/booking_status.dart';
import '../enums/payment_status.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _bookingRepository = BookingRepository();
  
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<List<BookingModel>>? _bookingsSubscription;

  // Getters
  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get bookings by status
  List<BookingModel> getBookingsByStatus(BookingStatus status) {
    return _bookings.where((booking) => booking.status == status).toList();
  }

  // Get bookings by payment status
  List<BookingModel> getBookingsByPaymentStatus(PaymentStatus status) {
    return _bookings.where((booking) => booking.paymentStatus == status).toList();
  }

  // Get bookings for a specific date
  List<BookingModel> getBookingsForDate(DateTime date) {
    return _bookings.where((booking) {
      return booking.bookingDate.year == date.year &&
          booking.bookingDate.month == date.month &&
          booking.bookingDate.day == date.day;
    }).toList();
  }

  // Get upcoming bookings
  List<BookingModel> getUpcomingBookings() {
    final now = DateTime.now();
    return _bookings.where((booking) {
      return booking.bookingDate.isAfter(now) && 
             (booking.status == BookingStatus.confirmed || 
              booking.status == BookingStatus.pending);
    }).toList();
  }

  // Get today's bookings
  List<BookingModel> getTodaysBookings() {
    return getBookingsForDate(DateTime.now());
  }

  // Load all bookings
  Future<void> loadAllBookings() async {
    try {
      _setLoading(true);
      _clearError();

      _bookings = await _bookingRepository.getAllBookings();

    } catch (e) {
      _setError('Failed to load bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load bookings by pitch
  Future<void> loadBookingsByPitch(String pitchId) async {
    try {
      _setLoading(true);
      _clearError();

      _bookings = await _bookingRepository.getBookingsByPitch(pitchId);

    } catch (e) {
      _setError('Failed to load bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load bookings by user
  Future<void> loadBookingsByUser(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      _bookings = await _bookingRepository.getBookingsByUser(userId);

    } catch (e) {
      _setError('Failed to load bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load bookings by date
  Future<void> loadBookingsByDate(DateTime date) async {
    try {
      _setLoading(true);
      _clearError();

      _bookings = await _bookingRepository.getBookingsByDate(date);

    } catch (e) {
      _setError('Failed to load bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load bookings for multiple pitches (owner's pitches)
  Future<void> loadBookingsByPitches(List<String> pitchIds) async {
    try {
      _setLoading(true);
      _clearError();

      _bookings = await _bookingRepository.getBookingsByPitches(pitchIds);

    } catch (e) {
      _setError('Failed to load bookings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Listen to bookings by pitch (real-time)
  void listenToBookingsByPitch(String pitchId) {
    _bookingsSubscription?.cancel();
    _bookingsSubscription = _bookingRepository
        .listenToBookingsByPitch(pitchId)
        .listen(
      (bookings) {
        _bookings = bookings;
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to listen to bookings: $error');
      },
    );
  }

  // Listen to bookings by user (real-time)
  void listenToBookingsByUser(String userId) {
    _bookingsSubscription?.cancel();
    _bookingsSubscription = _bookingRepository
        .listenToBookingsByUser(userId)
        .listen(
      (bookings) {
        _bookings = bookings;
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to listen to bookings: $error');
      },
    );
  }

  // Listen to bookings for multiple pitches (real-time)
  void listenToBookingsByPitches(List<String> pitchIds) {
    _bookingsSubscription?.cancel();
    _bookingsSubscription = _bookingRepository
        .listenToBookingsByPitches(pitchIds)
        .listen(
      (bookings) {
        _bookings = bookings;
        notifyListeners();
      },
      onError: (error) {
        _setError('Failed to listen to bookings: $error');
      },
    );
  }

  // Create a new booking
  Future<BookingModel?> createBooking(BookingModel booking) async {
    try {
      _setLoading(true);
      _clearError();

      // Check if slot is available
      final isAvailable = await _bookingRepository.isSlotAvailable(
        pitchId: booking.pitchId,
        date: booking.bookingDate,
        timeSlot: booking.timeSlot,
      );

      if (!isAvailable) {
        _setError('This time slot is not available');
        return null;
      }

      final newBooking = await _bookingRepository.createBooking(booking);
      
      // Add to local list if not using real-time listener
      if (_bookingsSubscription == null) {
        _bookings.add(newBooking);
        notifyListeners();
      }

      return newBooking;
    } catch (e) {
      _setError('Failed to create booking: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update booking
  Future<bool> updateBooking(String id, Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _clearError();

      await _bookingRepository.updateBooking(id, data);

      // Update local list if not using real-time listener
      if (_bookingsSubscription == null) {
        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          // Reload the booking
          final updatedBooking = await _bookingRepository.getBookingById(id);
          if (updatedBooking != null) {
            _bookings[index] = updatedBooking;
            notifyListeners();
          }
        }
      }

      return true;
    } catch (e) {
      _setError('Failed to update booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Confirm booking
  Future<bool> confirmBooking(String id) async {
    return await updateBooking(id, {'status': BookingStatus.confirmed.toJson()});
  }

  // Cancel booking
  Future<bool> cancelBooking(String id) async {
    try {
      _setLoading(true);
      _clearError();

      await _bookingRepository.cancelBooking(id);

      // Update local list if not using real-time listener
      if (_bookingsSubscription == null) {
        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          final updatedBooking = await _bookingRepository.getBookingById(id);
          if (updatedBooking != null) {
            _bookings[index] = updatedBooking;
            notifyListeners();
          }
        }
      }

      return true;
    } catch (e) {
      _setError('Failed to cancel booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Complete booking
  Future<bool> completeBooking(String id) async {
    return await updateBooking(id, {'status': BookingStatus.completed.toJson()});
  }

  // Update payment status
  Future<bool> updatePaymentStatus(String id, PaymentStatus status) async {
    return await updateBooking(id, {'paymentStatus': status.toJson()});
  }

  // Delete booking
  Future<bool> deleteBooking(String id) async {
    try {
      _setLoading(true);
      _clearError();

      await _bookingRepository.deleteBooking(id);

      // Remove from local list if not using real-time listener
      if (_bookingsSubscription == null) {
        _bookings.removeWhere((b) => b.id == id);
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError('Failed to delete booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get booking by ID
  BookingModel? getBookingById(String id) {
    try {
      return _bookings.firstWhere((booking) => booking.id == id);
    } catch (e) {
      return null;
    }
  }

  // Calculate total revenue
  double getTotalRevenue() {
    return _bookings
        .where((booking) => 
            booking.status == BookingStatus.completed && 
            booking.paymentStatus == PaymentStatus.paid)
        .fold(0.0, (sum, booking) => sum + booking.totalAmount);
  }

  // Calculate pending revenue
  double getPendingRevenue() {
    return _bookings
        .where((booking) => 
            (booking.status == BookingStatus.confirmed || 
             booking.status == BookingStatus.pending) &&
            booking.paymentStatus == PaymentStatus.pending)
        .fold(0.0, (sum, booking) => sum + booking.totalAmount);
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    _bookingsSubscription?.cancel();
    super.dispose();
  }
}
