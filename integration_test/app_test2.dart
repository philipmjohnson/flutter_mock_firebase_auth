import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
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
  group('Sample Integration Test 2', () {
    patrolWidgetTest('Access Profile Screen w/o login', (PatrolTester $) async {
      await Firebase.initializeApp();
      setFirebaseUiIsTestMode(true);
      // 1. Set up Mock authentication.
      FirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
      AuthRepository mockAuthRepository = AuthRepository(mockFirebaseAuth);
      mockFirebaseAuth.createUserWithEmailAndPassword(
          email: testEmail, password: testPassword);
      // 2. Start up the app, overriding providers to use mock authentication.
      await $.pumpWidgetAndSettle(ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
          authRepositoryProvider.overrideWithValue(mockAuthRepository)
        ],
        child: MyApp(),
      ));
      // There is a signed in user, so the Profile page should appear.
      expect($(#profileScreen).exists, true, reason: 'Not at Profile screen');
    });
  });
}
