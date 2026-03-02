# Namma Turf - Owners App

## Overview
The Owners App for Namma Turf platform allows turf facility owners to manage their pitches, bookings, and customer interactions. This app shares the same Firebase project and database with the Managers App, ensuring data consistency across platforms.

## Firebase Configuration
- **Firebase Project**: namma-turf
- **Shared Database**: Uses the same Firestore database as managers_app
- **Authentication**: Firebase Auth with Google Sign-In support
- **Real-time Updates**: Firestore real-time listeners for instant data synchronization

## Features Implemented

### ✅ Complete CRUD Operations

#### 1. **User Management**
- Create new users (Sign up with email/password, Google, Phone)
- Read user profiles
- Update user information
- Delete user accounts
- Real-time user data synchronization

#### 2. **Turf Pitch Management**
- Create new pitches with details (name, type, price, amenities)
- Read all pitches or pitches by owner
- Update pitch information
- Delete pitches
- Toggle pitch active/inactive status
- Real-time pitch updates
- Filter: Active/Inactive pitches

#### 3. **Booking Management**
- Create new bookings with slot validation
- Read bookings by pitch, user, date, or multiple pitches
- Update booking details
- Cancel/Confirm/Complete bookings
- Delete bookings
- Payment status management
- Real-time booking updates
- Check slot availability before booking
- Calculate revenue (total and pending)

### Architecture

```
lib/
├── core/
│   ├── enums/
│   │   ├── user_role.dart          # User roles (admin, owner, customer)
│   │   ├── booking_status.dart     # Booking states
│   │   └── payment_status.dart     # Payment states
│   ├── models/
│   │   ├── user_model.dart         # User data model
│   │   ├── turf_pitch_model.dart   # Pitch data model
│   │   ├── booking_model.dart      # Booking data model
│   │   └── time_slot_model.dart    # Time slot model
│   ├── services/
│   │   ├── firestore_service.dart  # Generic Firestore operations
│   │   └── auth_service.dart       # Authentication service
│   ├── repositories/
│   │   ├── user_repository.dart    # User CRUD operations
│   │   ├── turf_pitch_repository.dart  # Pitch CRUD operations
│   │   └── booking_repository.dart # Booking CRUD operations
│   ├── providers/
│   │   ├── auth_provider.dart      # Auth state management
│   │   ├── turf_provider.dart      # Pitch state management
│   │   └── booking_provider.dart   # Booking state management
│   └── theme/
│       └── app_theme.dart          # App theme configuration
├── firebase_options.dart           # Firebase configuration
└── main.dart                       # App entry point
```

## Database Schema

### Collections

#### 1. **users**
```dart
{
  uid: String,
  email: String,
  phoneNumber: String?,
  displayName: String?,
  photoUrl: String?,
  role: String, // 'admin', 'owner', 'customer'
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

#### 2. **turfPitches**
```dart
{
  id: String,
  name: String,
  type: String, // '5v5', '7v7', '11v11'
  managerId: String, // Owner's user ID
  isActive: Boolean,
  pricePerHour: Number,
  description: String?,
  amenities: List<String>?,
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

#### 3. **bookings**
```dart
{
  id: String,
  pitchId: String,
  userId: String,
  customerName: String,
  customerPhone: String,
  bookingDate: Timestamp,
  startTime: Timestamp,
  endTime: Timestamp,
  durationHours: Number,
  status: String, // 'pending', 'confirmed', 'cancelled', 'completed'
  totalAmount: Number,
  paymentStatus: String, // 'pending', 'paid', 'refunded'
  notes: String?,
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

## Firestore Security Rules
The app uses comprehensive security rules that:
- Allow authenticated users to manage their own data
- Allow owners to manage only their pitches
- Allow pitch owners to manage bookings for their pitches
- Prevent unauthorized access to sensitive operations

## Key Features

### Real-time Synchronization
- All data updates are reflected in real-time across all connected devices
- Uses Firestore snapshot listeners for instant updates

### Slot Availability Checking
- Prevents double-booking by checking slot availability before confirming
- Considers only confirmed and pending bookings when checking availability

### Owner-Specific Features
- View all bookings across multiple owned pitches
- Calculate total revenue and pending payments
- Manage pitch availability status
- Real-time dashboard updates

### State Management
- Provider pattern for clean state management
- Separation of concerns (Repositories → Providers → UI)
- Error handling and loading states

## Setup and Installation

### 1. Install Dependencies
```bash
cd owners_app
flutter pub get
```

### 2. Firebase Configuration
The app is already configured to use the same Firebase project as managers_app:
- Project ID: `namma-turf`
- No additional Firebase setup needed

### 3. Run the App
```bash
flutter run
```

## Usage Examples

### Sign In
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
await authProvider.signInWithGoogle();
```

### Create a Pitch
```dart
final turfProvider = Provider.of<TurfProvider>(context, listen: false);
await turfProvider.addPitch(
  name: 'Main Pitch',
  type: '7v7',
  ownerId: currentUserId,
  pricePerHour: 1500.0,
  description: 'Professional turf with lights',
  amenities: ['Parking', 'Changing Room', 'Water'],
);
```

### Create a Booking
```dart
final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
final booking = BookingModel(
  id: '',
  pitchId: selectedPitchId,
  userId: currentUserId,
  customerName: 'John Doe',
  customerPhone: '+91 9876543210',
  bookingDate: DateTime.now(),
  timeSlot: TimeSlot(
    startTime: DateTime.now().add(Duration(hours: 2)),
    endTime: DateTime.now().add(Duration(hours: 4)),
  ),
  durationHours: 2,
  totalAmount: 3000.0,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
await bookingProvider.createBooking(booking);
```

### Listen to Real-time Updates
```dart
// Listen to owner's pitches
turfProvider.listenToPitchesByOwner(ownerId);

// Listen to bookings for specific pitches
bookingProvider.listenToBookingsByPitches(pitchIds);
```

## Shared Database Benefits
- **Data Consistency**: Both apps see the same data in real-time
- **Single Source of Truth**: All bookings and pitches are managed centrally
- **Cross-App Functionality**: Managers and Owners can collaborate seamlessly
- **Cost Efficient**: Single Firebase project for multiple apps

## Dependencies
- `firebase_core`: ^3.8.1
- `firebase_auth`: ^5.3.4
- `cloud_firestore`: ^5.5.2
- `google_sign_in`: ^6.2.2
- `provider`: ^6.1.5+1
- `uuid`: ^4.5.1
- `equatable`: ^2.0.7
- `google_fonts`: ^6.3.2
- `intl`: ^0.20.2

## Next Steps
1. Build out the UI screens for pitch management
2. Add booking calendar view
3. Implement revenue analytics
4. Add notifications for new bookings
5. Implement image upload for pitches

## Notes
- The app uses `managerId` field in the database (not `ownerId`) to maintain compatibility with the managers_app
- Both apps can access and modify the same data
- User roles are managed through the `role` field in the user document
- All CRUD operations include proper error handling and validation
