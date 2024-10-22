# flutter_mock_firebase_auth

## TO DO

* Create signin page. 
* Create profile page.
* Create router.
* Create riverpod provider for firebase auth.
* Test registration and login using regular firebase auth.
* Create integration test with overrides for firebase auth.

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
