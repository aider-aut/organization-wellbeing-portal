# Organization Wellbeing Chatapp for Aider

## First use

### Android
* Login to Firebase console
* For android, you need to add your own machine's SHA certificate:
 
  1. Run in terminal:  
      ```
      keytool -list -v -keystore "C:\Users\<put your username>\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
      ```

  2. Copy SHA-1  
  3. Go to Firebase Console > Project Settings > SHA certificate fingerprints > Add fingerprint

* download google-services.json
* place it under **android/app** directory

### iOS
* Login to Firebase console and download GoogleService-info.plist
* place it under **ios/Runner**


## Useful Commands

To run the app:
```
flutter run
```

To clean build:
```
flutter clean
```

To install dependencies:
```
flutter pub get
```


