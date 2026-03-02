import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/turf_provider.dart';
import 'core/providers/booking_provider.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the same project as managers_app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Firestore settings
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TurfProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const OwnersApp(),
    ),
  );
}

class OwnersApp extends StatelessWidget {
  const OwnersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namma Turf - Owners',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}

// Temporary home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namma Turf - Owners'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_soccer,
              size: 100,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Namma Turf',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Owners App',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),
            if (authProvider.isAuthenticated)
              Column(
                children: [
                  Text(
                    'Signed in as: ${authProvider.currentUser?.email ?? "Unknown"}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await authProvider.signOut();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signed out successfully')),
                        );
                      }
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Text('Firebase and Firestore are configured!'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final success = await authProvider.signInWithGoogle();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success ? 'Signed in successfully!' : 'Sign in failed',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign In with Google'),
                  ),
                ],
              ),
            const SizedBox(height: 48),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'All CRUD operations are implemented:\n'
                '✓ Firebase Authentication\n'
                '✓ User Management\n'
                '✓ Turf Pitch Management\n'
                '✓ Booking Management\n'
                '✓ Real-time Updates\n'
                '✓ Same database as Managers App',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
