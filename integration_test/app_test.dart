import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mock_firebase_auth/app.dart';
import 'package:flutter_mock_firebase_auth/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
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
      // Mock sign in with Google.
      final googleSignIn = MockGoogleSignIn();
      final signinAccount = await googleSignIn.signIn();
      final googleAuth = await signinAccount?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Sign in.
      final user = MockUser(
        isAnonymous: false,
        uid: 'someuid',
        email: testEmail,
        displayName: 'Bob',
      );
      FirebaseAuth mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
      AuthRepository mockAuthRepository = AuthRepository(mockFirebaseAuth);
      await $.pumpWidgetAndSettle(ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          authRepositoryProvider.overrideWithValue(mockAuthRepository)
        ],
        child: MyApp(),
      ));
      // Verify that we are at the signin screen.
      expect($(#signInScreen).exists, true, reason: 'Not at SignIn screen.');
      // Verify that no user is signed in.
      User? loggedInUser = mockFirebaseAuth.currentUser;
      expect(loggedInUser, null, reason: 'A user is already signed in');
      // Mock the sign in process.
      // final result = await mockFirebaseAuth.signInWithCredential(credential);
      // await user.updatePassword(testPassword);
      // expect(result.user?.displayName, 'Bob', reason: 'User not signed in');
      // Verify that we are at the profile screen.

      expect($(EmailInput), findsOneWidget, reason: 'Email input not found');
      expect($(PasswordInput), findsOneWidget,
          reason: 'Password input not found');
      await $(EmailInput)
          .$(TextFormField)
          .waitUntilVisible()
          .enterText(testEmail);
      await $(PasswordInput).$(TextFormField).enterText(testPassword);
      await $(ButtonStyleButton).tap();
      // expect($(#profileScreen).exists, true, reason: 'Not at Profile screen');
    });
  });
}
