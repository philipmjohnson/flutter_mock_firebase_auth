# flutter_mock_firebase_auth

This app illustrates how to implement an integration test based on:
* [riverpod](https://pub.dev/packages/flutter_riverpod) (to enable overriding of FirebaseAuth and AuthRepository instances with mocks during testing).
* [firebase_ui_auth](https://pub.dev/packages/firebase_ui_auth) (to implement the signin and profile screens)
* [firebase_auth_mocks](https://pub.dev/packages/firebase_auth_mocks) (to mock the FirebaseAuth and AuthRepository instances).
* [patrol_finders](https://pub.dev/packages/patrol_finders) (to simplify tests to check what screen is displayed during the integration test.

## Installation

First, go to the Firebase console and:

* Create a new project, perhaps called "flutter-mock-firebase-auth". You can disable Google Analytics, you won't need them for this app.

* Enable Firebase Authentication, along with the Email/Password Authentication Sign-in provider in the Firebase Console (Authentication > Sign-in method > Email/Password > Edit > Enable > Save)

* You do NOT need to create a database; this example app only uses Firebase Authentication.

Then, in the terminal:

* Run `firebase login` so you have access to the Firebase project you have created.

* Run `flutterfire configure` and follow all the steps. Note you should say "no" to the first prompt in order to allow you to connect the app to  your newly created Firebase project.

Finally, invoke:

```
pub get
```

and your favorite flavor of

```
flutter run
```

What should appear is the SignIn screen:

<img width="300px" src="signin-screen.png">

Click to register a new user. Once you've gone through that process, you should see the  Profile screen:

<img width="300px" src="profile-screen.png">

When you can register and signin and see the Profile screen, you have verified that the app is working correctly. 

This app contains only a SignIn and Profile screen, because the goal of this app is to illustrate how to mock Firebase Authentication. The goal is to illustrate how to do integration testing such that we can mock the signin process and get to the Profile screen without actually accessing the Firebase Authentication server.

## Run the integration test

To run the sample integration test, invoke:
```
flutter test integration_test/app_test.dart
```

We would like it to produce output similar to:
```
00:17 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart              
Ru00:39 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart               
00:43 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart           4.1s
Xcode build done.                                           26.2s
00:46 +1: All tests passed!       
```

But it does not. Instead, it produces (in part) this:

```
flutter test integration_test/app_test.dart
00:06 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart              Ru00:27 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart               
00:30 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart           3.7s
Xcode build done.                                           24.3s
00:33 +0: Sample Integration Test Access Profile Screen                                                                          
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following TestFailure was thrown running a test:
Expected: <true>
  Actual: <false>
Not at Profile screen
```

To understand this output, here is the integration test code:

```dart
void main() {
  String testEmail = 'bob@example.com';
  String testPassword = 'foobarbaz';
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Sample Integration Test', () {
    patrolWidgetTest('Access Profile Screen', (PatrolTester $) async {
      await Firebase.initializeApp();
      setFirebaseUiIsTestMode(true);
      // Set up Mock authentication.
      final user = MockUser(isAnonymous: false, email: testEmail);
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
      // Fill out the email and password fields and submit.
      await $(EmailInput).$(TextFormField).enterText(testEmail);
      await $(PasswordInput).$(TextFormField).enterText(testPassword);
      await $(EmailForm).$(OutlinedButton).tap();
      // After signing in, should go to Profile screen.
      expect($(#profileScreen).exists, true, reason: 'Not at Profile screen');
    });
  });
}
```

The essential problem is this:

* The mock authentication repo is defined with a testUser, but there is not a password defined for that user. That is why the test fails when the form is filled out and submitted with the testEmail and testPassword.
* If I try to define a password for the user (such as with the createUserWithEmailAndPassword method), then I get a Null pointer check. This seems due to the fact that the authentication provider thinks that a user is logged in, but the system is displaying the SignIn page. 