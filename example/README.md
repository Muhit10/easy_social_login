# Easy Social Login Example

This example demonstrates how to use the `easy_social_login` package to implement Google and Facebook authentication in your Flutter app.

## Features Demonstrated

- ✅ Google Sign-In with Firebase integration
- ✅ Facebook Login with Firebase integration  
- ✅ Custom UI components (`SocialLoginButton`)
- ✅ Comprehensive error handling
- ✅ Platform support detection
- ✅ Sign out functionality
- ✅ User information display

## Setup Instructions

### 1. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your Android/iOS app to the project
3. Download and place the configuration files:
   - `google-services.json` in `android/app/`
   - `GoogleService-Info.plist` in `ios/Runner/`

### 2. Google Sign-In Setup

#### Android
Add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

#### iOS
No additional setup required for Google Sign-In on iOS.

### 3. Facebook Login Setup

#### Android
Add to `android/app/src/main/res/values/strings.xml`:
```xml
<string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
<string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
```

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>
```

#### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>fblogin</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_FACEBOOK_APP_ID</string>
        </array>
    </dict>
</array>
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookDisplayName</key>
<string>YOUR_APP_NAME</string>
```

## Running the Example

1. Complete the setup instructions above
2. Run the example:
   ```bash
   cd example
   flutter pub get
   flutter run
   ```

## Code Overview

The example app demonstrates:

### Basic Usage
```dart
final socialLogin = EasySocialLogin();

// Google Sign-In
final result = await socialLogin.signInWithGoogle(
  signIntoFirebase: true,
);

// Facebook Login
final result = await socialLogin.signInWithFacebook(
  signIntoFirebase: true,
);
```

### UI Components
```dart
SocialLoginButtonColumn(
  spacing: 16,
  buttons: [
    SocialLoginButton.google(
      onPressed: _handleGoogleSignIn,
      isLoading: _isGoogleLoading,
    ),
    SocialLoginButton.facebook(
      onPressed: _handleFacebookSignIn,
      isLoading: _isFacebookLoading,
    ),
  ],
)
```

### Error Handling
```dart
try {
  final result = await socialLogin.signInWithGoogle();
} on SocialLoginCancelledException {
  // User cancelled the sign-in
} on SocialLoginNetworkException catch (e) {
  // Network error occurred
} on SocialLoginException catch (e) {
  // Other authentication error
}
```

## Features Showcased

1. **Platform Detection**: Shows which providers are supported on the current platform
2. **Loading States**: Demonstrates proper loading indicators during authentication
3. **Error Handling**: Comprehensive error handling with user-friendly messages
4. **User Information**: Displays user data after successful authentication
5. **Sign Out**: Shows how to sign out from all providers
6. **Custom UI**: Uses the built-in social login buttons with customization

## Learn More

- [easy_social_login Documentation](../README.md)
- [Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)
- [Google Sign-In Setup](https://pub.dev/packages/google_sign_in)
- [Facebook Login Setup](https://pub.dev/packages/flutter_facebook_auth)