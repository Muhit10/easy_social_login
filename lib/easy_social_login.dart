/// Easy Social Login - A comprehensive Flutter package for social media authentication
/// 
/// This library provides a unified interface for Google Sign-In and Facebook Login
/// with optional Firebase integration, responsive UI components, and robust error handling.
/// 
/// Features:
/// - Google Sign-In with Firebase integration
/// - Facebook Login with Firebase integration  
/// - Customizable UI components
/// - Comprehensive error handling
/// - Platform support detection
/// - Responsive design components
/// 
/// Example usage:
/// ```dart
/// final socialLogin = EasySocialLogin();
/// 
/// // Google Sign-In
/// final result = await socialLogin.signInWithGoogle(signIntoFirebase: true);
/// 
/// // Facebook Login
/// final result = await socialLogin.signInWithFacebook(signIntoFirebase: true);
/// ```
library easy_social_login;

// Core authentication class
export 'src/easy_social_login.dart';

// Models
export 'src/models/social_login_result.dart';

// Exceptions
export 'src/exceptions/social_login_exceptions.dart';

// UI Widgets
export 'src/widgets/social_login_button.dart';

// Providers (for advanced usage)
export 'src/providers/google_signin_provider.dart';
export 'src/providers/facebook_signin_provider.dart';