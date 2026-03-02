import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../enums/user_role.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  User? _firebaseUser;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  User? get firebaseUser => _firebaseUser;

  AuthProvider() {
    _initAuthListener();
  }

  // Initialize auth state listener
  void _initAuthListener() {
    _authService.authStateChanges.listen((User? user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // Load user data from Firestore
  Future<void> _loadUserData(String uid) async {
    try {
      _currentUser = await _authService.getUserDocument(uid);
    } catch (e) {
      _errorMessage = 'Failed to load user data: $e';
    }
  }

  // Sign up with email and password
  Future<bool> signUpWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
    UserRole role = UserRole.owner,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signUpWithEmailPassword(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signInWithEmailPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle({UserRole role = UserRole.owner}) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signInWithGoogle(role: role);

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify phone number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: (verificationId) {
          _setLoading(false);
          onCodeSent(verificationId);
        },
        verificationFailed: (error) {
          _setError(error);
          _setLoading(false);
          onVerificationFailed(error);
        },
        verificationCompleted: (credential) async {
          // Auto-sign in if verification is completed automatically
          await _authService.signInWithPhoneCredential(
            verificationId: '',
            smsCode: '',
          );
          _setLoading(false);
        },
      );
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Sign in with phone credential
  Future<bool> signInWithPhoneCredential({
    required String verificationId,
    required String smsCode,
    UserRole role = UserRole.owner,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signInWithPhoneCredential(
        verificationId: verificationId,
        smsCode: smsCode,
        role: role,
      );

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.signOut();
      _currentUser = null;
      _firebaseUser = null;

    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.sendPasswordResetEmail(email: email);

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );

      // Reload user data
      if (_firebaseUser != null) {
        await _loadUserData(_firebaseUser!.uid);
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
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
    super.dispose();
  }
}
