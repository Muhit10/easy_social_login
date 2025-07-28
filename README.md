# Easy Social Login

[![pub package](https://img.shields.io/pub/v/easy_social_login.svg)](https://pub.dev/packages/easy_social_login)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)

A comprehensive Flutter package that makes social media authentication extremely easy. Provides seamless integration with Google, Facebook and other social providers along with responsive UI components.

## Features

### **Authentication Providers**
- ✅ **Google Sign-In** - Latest API support with singleton pattern
- ✅ **Facebook Login** - Complete integration with Graph API
- ✅ **Firebase Integration** - Automatic Firebase Auth integration
- 🔄 **More providers coming soon** (Apple, Twitter, GitHub)

### **UI Components**
- 📱 **Responsive Design** - Mobile, Tablet, Desktop adaptive
- 🎯 **Pre-built Buttons** - Ready-to-use social login buttons
- 🎨 **Customizable** - Colors, sizes, shapes, text all customizable
- 🌙 **Dark/Light Theme** - Automatic theme adaptation
- 📐 **Flexible Layouts** - Row, Column, Grid layouts

### **Developer Experience**
- 🚀 **Easy Setup** - Minimal configuration required
- 📚 **Type Safety** - Full Dart null safety support
- 🔄 **State Management** - Built-in loading and error states
- 🧪 **Well Tested** - Comprehensive test coverage
- 📖 **Rich Documentation** - Detailed examples and guides

### **Platform Support**
- 📱 **Android** - Native integration
- 🍎 **iOS** - Native integration  
- 🌐 **Web** - Full web support
- 🖥️ **Desktop** - Windows, macOS, Linux (limited)

## Installation

### 1. Add dependency
```yaml
dependencies:
  easy_social_login: ^1.0.0
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
```

### 2. Install packages
```bash
flutter pub get
```

### 3. Platform Setup

#### **Android Setup**

**android/app/build.gradle:**
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

**android/app/src/main/AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### **iOS Setup**

**ios/Runner/Info.plist:**
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

#### **Web Setup**

**web/index.html:**
```html
<script src="https://apis.google.com/js/platform.js" async defer></script>
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
```

## Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:easy_social_login/easy_social_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final EasySocialLogin _socialLogin = EasySocialLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google Sign-In Button
              SocialLoginButton.google(
                onPressed: _handleGoogleSignIn,
                text: 'Sign in with Google',
              ),
              
              SizedBox(height: 16),
              
              // Facebook Login Button
              SocialLoginButton.facebook(
                onPressed: _handleFacebookSignIn,
                text: 'Continue with Facebook',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final result = await _socialLogin.signInWithGoogle(
        signIntoFirebase: true,
      );
      
      print('User: ${result.name}');
      print('Email: ${result.email}');
      print('Firebase UID: ${result.firebaseUser?.uid}');
      
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _handleFacebookSignIn() async {
    try {
      final result = await _socialLogin.signInWithFacebook(
        signIntoFirebase: true,
      );
      
      print('User: ${result.name}');
      print('Email: ${result.email}');
      
    } catch (e) {
      print('Error: $e');
    }
  }
}
```

## UI Customization

### Responsive Layout

```dart
// Mobile Layout
SocialLoginButtonColumn(
  spacing: 16,
  buttons: [
    SocialLoginButton.google(
      width: double.infinity,
      height: 50,
    ),
    SocialLoginButton.facebook(
      width: double.infinity,
      height: 50,
    ),
  ],
)

// Desktop Layout
SocialLoginButtonRow(
  spacing: 16,
  buttons: [
    SocialLoginButton.google(width: 200),
    SocialLoginButton.facebook(width: 200),
  ],
)
```

### Custom Button Styling

```dart
SocialLoginButton.google(
  height: 56,
  width: double.infinity,
  backgroundColor: Colors.white,
  textColor: Colors.black87,
  borderRadius: BorderRadius.circular(12),
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  padding: EdgeInsets.symmetric(horizontal: 24),
  elevation: 4,
)
```

### Dark Theme Support

```dart
SocialLoginButton.google(
  backgroundColor: Color(0xFF2D2D2D),
  textColor: Colors.white,
  border: BorderSide(color: Color(0xFF404040)),
)
```

## Advanced Configuration

### Firebase Setup

```dart
// Initialize Firebase first
await Firebase.initializeApp();

// Configure social login
final socialLogin = EasySocialLogin();

// Sign in with automatic Firebase integration
final result = await socialLogin.signInWithGoogle(
  signIntoFirebase: true,
  serverClientId: 'YOUR_SERVER_CLIENT_ID', // For backend integration
);
```

### Error Handling

```dart
try {
  final result = await _socialLogin.signInWithGoogle();
} on SocialLoginCancelledException {
  // User cancelled the sign-in
  print('Sign-in cancelled by user');
} on SocialLoginNetworkException catch (e) {
  // Network error
  print('Network error: ${e.message}');
} on SocialLoginPlatformNotSupportedException {
  // Platform not supported
  print('Platform not supported');
} on SocialLoginException catch (e) {
  // General error
  print('Sign-in failed: ${e.message}');
}
```

### Loading States

```dart
bool _isLoading = false;

SocialLoginButton.google(
  isLoading: _isLoading,
  loadingWidget: CircularProgressIndicator(
    strokeWidth: 2,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
  ),
  onPressed: () async {
    setState(() => _isLoading = true);
    
    try {
      await _socialLogin.signInWithGoogle();
    } finally {
      setState(() => _isLoading = false);
    }
  },
)
```

## Platform-Specific Features

### Android

```dart
// Check if Google Play Services available
if (_socialLogin.isGoogleSupported) {
  // Show Google Sign-In button
}
```

### iOS

```dart
// Handle iOS-specific configurations
// Automatic handling of iOS keychain and biometric authentication
```

### Web

```dart
// Web-specific popup handling
// Automatic CORS and domain verification
```

## Security Best Practices

### 1. Server-Side Verification

```dart
final result = await _socialLogin.signInWithGoogle(
  serverClientId: 'YOUR_SERVER_CLIENT_ID',
);

// Send result.serverAuthCode to your backend for verification
```

### 2. Token Management

```dart
// Access tokens are automatically managed
// Refresh tokens handled internally
// Secure storage implementation
```

### 3. Privacy Compliance

```dart
// GDPR compliant
// User consent handling
// Data minimization principles
```

## Testing

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_social_login/easy_social_login.dart';

void main() {
  group('EasySocialLogin Tests', () {
    test('should initialize correctly', () {
      final socialLogin = EasySocialLogin();
      expect(socialLogin, isNotNull);
    });
  });
}
```

### Widget Tests

```dart
testWidgets('SocialLoginButton should render correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SocialLoginButton.google(
        onPressed: () {},
      ),
    ),
  );
  
  expect(find.text('Sign in with Google'), findsOneWidget);
});
```

## Performance

- ⚡ **Fast initialization** - Lazy loading of providers
- 🔄 **Efficient caching** - Token and user data caching
- 📱 **Memory optimized** - Minimal memory footprint
- 🚀 **Quick response** - Optimized API calls

## Internationalization

```dart
SocialLoginButton.google(
  text: 'Sign in with Google', // English
  // text: 'Googleでサインイン', // Japanese
  // text: 'Iniciar sesión con Google', // Spanish
  // text: 'Se connecter avec Google', // French
)
```

## Migration Guide

### From other packages

```dart
// Old way (google_sign_in)
GoogleSignIn _googleSignIn = GoogleSignIn();
GoogleSignInAccount? account = await _googleSignIn.signIn();

// New way (easy_social_login)
EasySocialLogin _socialLogin = EasySocialLogin();
SocialLoginResult result = await _socialLogin.signInWithGoogle();
```

## Troubleshooting

### Common Issues

**1. Google Sign-In not working on Android:**
```bash
# Check SHA-1 fingerprint
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey
```

**2. Facebook Login issues:**
```dart
// Ensure Facebook App ID is correctly configured
// Check Facebook Developer Console settings
```

**3. Web platform issues:**
```html
<!-- Ensure correct client ID in web/index.html -->
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID">
```

## Roadmap

- [ ] Apple Sign-In integration
- [ ] Twitter/X authentication
- [ ] GitHub OAuth
- [ ] LinkedIn integration
- [ ] Microsoft Azure AD
- [ ] Custom OAuth providers
- [ ] Biometric authentication
- [ ] Multi-factor authentication

## Contributing

We welcome community contributions! 

### Development Setup

```bash
# Clone the repository
git clone https://github.com/Muhit10/easy_social_login.git

# Install dependencies
cd easy_social_login
flutter pub get

# Run example
cd example
flutter run
```

### Contribution Guidelines

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Update documentation
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Google Sign-In team for the authentication APIs
- Facebook developers for the Login SDK
- Firebase team for the backend services

## Support

- 📧 **Email:** support@easysociallogin.dev
- 🐛 **Issues:** [GitHub Issues](https://github.com/Muhit10/easy_social_login/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/Muhit10/easy_social_login/discussions)
- 📚 **Documentation:** [Wiki](https://github.com/Muhit10/easy_social_login/wiki)

---

**Made with ❤️ by Flutter developers, for Flutter developers**

[![GitHub stars](https://img.shields.io/github/stars/Muhit10/easy_social_login.svg?style=social&label=Star)](https://github.com/Muhit10/easy_social_login)
[![GitHub forks](https://img.shields.io/github/forks/Muhit10/easy_social_login.svg?style=social&label=Fork)](https://github.com/Muhit10/easy_social_login/fork)