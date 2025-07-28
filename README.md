# Easy Social Login 🚀

[![pub package](https://img.shields.io/pub/v/easy_social_login.svg)](https://pub.dev/packages/easy_social_login)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=flat&logo=firebase)](https://firebase.google.com)

A comprehensive Flutter package that simplifies social media authentication with **Google Sign-In** and **Facebook Login**. Features responsive UI components, Firebase integration, and robust error handling.

## ✨ Features

### 🔐 Authentication Providers
- **Google Sign-In** - Complete integration with Google authentication
- **Facebook Login** - Full Facebook authentication support
- **Firebase Integration** - Optional Firebase Auth integration
- **Platform Support** - iOS, Android, Web, macOS, Windows, Linux

### 🎨 UI Components
- **Responsive Design** - Adaptive layouts for all screen sizes
- **Customizable Buttons** - Pre-built social login buttons
- **Material 3 Support** - Modern Material Design components
- **Dark/Light Theme** - Automatic theme adaptation
- **Loading States** - Built-in loading indicators

### 🛡️ Security & Error Handling
- **Comprehensive Error Types** - Specific exception handling
- **Network Error Recovery** - Automatic retry mechanisms
- **Platform Validation** - Runtime platform support checking
- **Secure Token Management** - Safe credential handling

### 🌍 Developer Experience
- **Simple API** - Intuitive method signatures
- **TypeScript-like** - Strong typing with null safety
- **Extensive Documentation** - Complete API reference
- **Example App** - Working demonstration

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  easy_social_login: ^1.0.0
  firebase_core: ^2.24.2  # Required for Firebase integration
  firebase_auth: ^4.15.3  # Required for Firebase integration
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Basic Setup

```dart
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton.google(
              onPressed: _handleGoogleSignIn,
            ),
            SizedBox(height: 16),
            SocialLoginButton.facebook(
              onPressed: _handleFacebookSignIn,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final result = await _socialLogin.signInWithGoogle();
      print('Welcome ${result.name}!');
    } catch (e) {
      print('Sign-in failed: $e');
    }
  }

  Future<void> _handleFacebookSignIn() async {
    try {
      final result = await _socialLogin.signInWithFacebook();
      print('Welcome ${result.name}!');
    } catch (e) {
      print('Login failed: $e');
    }
  }
}
```

### 2. Firebase Integration

```dart
// Initialize Firebase first
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Sign in with Firebase integration
final result = await _socialLogin.signInWithGoogle(
  signIntoFirebase: true,
);

// Access Firebase user
if (result.firebaseUser != null) {
  print('Firebase UID: ${result.firebaseUser!.uid}');
}
```

## 🎨 UI Customization

### Custom Button Styling

```dart
SocialLoginButton(
  text: 'Sign in with Google',
  icon: Icons.login,
  backgroundColor: Colors.blue,
  textColor: Colors.white,
  borderRadius: 12,
  height: 50,
  width: 300,
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  onPressed: _handleGoogleSignIn,
)
```

### Responsive Layouts

```dart
// Vertical layout
SocialLoginButtonColumn(
  spacing: 16,
  buttons: [
    SocialLoginButton.google(onPressed: _handleGoogleSignIn),
    SocialLoginButton.facebook(onPressed: _handleFacebookSignIn),
  ],
)

// Horizontal layout
SocialLoginButtonRow(
  spacing: 16,
  buttons: [
    SocialLoginButton.google(onPressed: _handleGoogleSignIn),
    SocialLoginButton.facebook(onPressed: _handleFacebookSignIn),
  ],
)
```

### Adaptive Design

```dart
Widget buildResponsiveLogin(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  
  if (screenWidth > 600) {
    // Desktop/Tablet - Horizontal layout
    return SocialLoginButtonRow(
      spacing: 20,
      buttons: _buildButtons(),
    );
  } else {
    // Mobile - Vertical layout
    return SocialLoginButtonColumn(
      spacing: 16,
      buttons: _buildButtons(),
    );
  }
}
```

## 🔧 Advanced Configuration

### Google Sign-In Configuration

```dart
final result = await _socialLogin.signInWithGoogle(
  signIntoFirebase: true,
  scopes: ['email', 'profile'],
);
```

### Facebook Login Configuration

```dart
final result = await _socialLogin.signInWithFacebook(
  signIntoFirebase: true,
  permissions: ['email', 'public_profile'],
);
```

### Error Handling

```dart
try {
  final result = await _socialLogin.signInWithGoogle();
  // Handle success
} on SocialLoginCancelledException {
  // User cancelled the sign-in
} on SocialLoginNetworkException catch (e) {
  // Network error occurred
  print('Network error: ${e.message}');
} on SocialLoginPlatformNotSupportedException {
  // Platform not supported
} on SocialLoginException catch (e) {
  // General social login error
  print('Login failed: ${e.message}');
}
```

## 📱 Platform Setup

### Android Setup

1. **Google Sign-In**: Add your `google-services.json` to `android/app/`
2. **Facebook Login**: Add to `android/app/src/main/res/values/strings.xml`:

```xml
<string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
<string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
```

### iOS Setup

1. **Google Sign-In**: Add your `GoogleService-Info.plist` to `ios/Runner/`
2. **Facebook Login**: Add to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>facebook</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbYOUR_FACEBOOK_APP_ID</string>
    </array>
  </dict>
</array>
```

### Web Setup

1. **Google Sign-In**: Add to `web/index.html`:

```html
<meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID">
```

2. **Facebook Login**: Add Facebook SDK script to `web/index.html`

## 🧪 Testing

```dart
void main() {
  group('Easy Social Login Tests', () {
    late EasySocialLogin socialLogin;

    setUp(() {
      socialLogin = EasySocialLogin();
    });

    test('should check platform support', () {
      expect(socialLogin.isGoogleSupported, isA<bool>());
      expect(socialLogin.isFacebookSupported, isA<bool>());
    });
  });
}
```

## 🚀 Performance

- **Lazy Loading**: Providers are initialized only when needed
- **Memory Efficient**: Minimal memory footprint
- **Fast Authentication**: Optimized for quick sign-in flows
- **Caching**: Intelligent credential caching

## 🌍 Internationalization

```dart
SocialLoginButton.google(
  text: AppLocalizations.of(context).signInWithGoogle,
  onPressed: _handleGoogleSignIn,
)
```

## 📊 Migration Guide

### From google_sign_in package

```dart
// Before
final GoogleSignInAccount? account = await GoogleSignIn().signIn();

// After
final SocialLoginResult result = await EasySocialLogin().signInWithGoogle();
```

### From flutter_facebook_auth package

```dart
// Before
final LoginResult result = await FacebookAuth.instance.login();

// After
final SocialLoginResult result = await EasySocialLogin().signInWithFacebook();
```

## 🐛 Troubleshooting

### Common Issues

**Google Sign-In not working on Android:**
- Ensure `google-services.json` is properly configured
- Check SHA-1 fingerprints in Firebase Console
- Verify package name matches Firebase project

**Facebook Login failing:**
- Confirm Facebook App ID is correct
- Check app is in development/live mode
- Verify bundle ID/package name in Facebook Developer Console

**Firebase integration issues:**
- Ensure Firebase is initialized before using social login
- Check Firebase project configuration
- Verify authentication providers are enabled

### Debug Mode

```dart
// Enable debug logging
EasySocialLogin.enableDebugMode = true;
```

## 🗺️ Roadmap

- [ ] **Apple Sign-In** support
- [ ] **Twitter/X** authentication
- [ ] **LinkedIn** login integration
- [ ] **Microsoft** account support
- [ ] **Biometric** authentication
- [ ] **Multi-factor** authentication
- [ ] **Custom OAuth** providers
- [ ] **Analytics** integration

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/Muhit10/easy_social_login.git

# Install dependencies
cd easy_social_login
flutter pub get

# Run example app
cd example
flutter run

# Run tests
flutter test
```

### Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Add tests for new features
- Update documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Google Sign-In](https://pub.dev/packages/google_sign_in) team
- [Flutter Facebook Auth](https://pub.dev/packages/flutter_facebook_auth) team
- [Firebase](https://firebase.google.com) team
- Flutter community for feedback and contributions

## 📞 Support

- **Documentation**: [API Reference](https://pub.dev/documentation/easy_social_login/latest/)
- **Issues**: [GitHub Issues](https://github.com/Muhit10/easy_social_login/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Muhit10/easy_social_login/discussions)
- **Email**: [muhit.flutter@gmail.com](mailto:muhit.flutter@gmail.com)

---

**Made with ❤️ by [Muhit](https://github.com/Muhit10)**

*If this package helped you, please ⭐ star the repo and share it with others!*