import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mock_firebase_auth/app.dart';
import 'package:flutter_mock_firebase_auth/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() {
  String testEmail = 'bob@example.com';
  String testPassword = 'foobarbaz';
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Sample Integration Test', () {
    patrolWidgetTest('Access Profile Screen', (PatrolTester $) async {
      await Firebase.initializeApp();
      setFirebaseUiIsTestMode(true);
      // 1. Set up Mock authentication.
      final user = MockUser(isAnonymous: false, email: testEmail);
      FirebaseAuth mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
      AuthRepository mockAuthRepository = AuthRepository(mockFirebaseAuth);
      // 2. Start up the app, overriding providers to use mock authentication.
      await $.pumpWidgetAndSettle(ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          authRepositoryProvider.overrideWithValue(mockAuthRepository)
        ],
        child: MyApp(),
      ));
      // 3. Verify that the app displays the signin screen.
      expect($(#signInScreen).exists, true, reason: 'Not at SignIn screen.');
      // 4. Verify that no user is signed in.
      User? loggedInUser = mockFirebaseAuth.currentUser;
      expect(loggedInUser, null, reason: 'A user is already signed in');
      // 5. Fill out the email and password fields and submit.
      await $(EmailInput).$(TextFormField).enterText(testEmail);
      await $(PasswordInput).$(TextFormField).enterText(testPassword);
      await $(EmailForm).$(OutlinedButton).tap();
      // 6. After successful signin, should go to Profile screen.
      // However, this fails because no password is defined for this user.
      expect($(#profileScreen).exists, true, reason: 'Not at Profile screen');
    });
  });
}
