# flutter_mock_firebase_auth

This app illustrates how to implement an integration test based on:
* [riverpod](https://pub.dev/packages/flutter_riverpod)
* [firebase_ui_auth](https://pub.dev/packages/firebase_ui_auth)
* [firebase_auth_mocks](https://pub.dev/packages/firebase_auth_mocks)



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

This should produce output similar to:
```
00:17 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart              
Ru00:39 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart               
00:43 +0: ... /Users/philipjohnson/GitHub/philipmjohnson/flutter_mock_firebase_auth/integration_test/app_test.dart           4.1s
Xcode build done.                                           26.2s
00:46 +1: All tests passed!       
```