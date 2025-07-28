import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/social_login_result.dart';
import 'exceptions/social_login_exceptions.dart';
import 'providers/google_signin_provider.dart';
import 'providers/facebook_signin_provider.dart';

/// Main class for Easy Social Login package
/// 
/// Provides a unified interface for social media authentication including
/// Google Sign-In and Facebook Login with optional Firebase integration.
/// 
/// Example usage:
/// ```dart
/// final socialLogin = EasySocialLogin();
/// 
/// // Check platform support
/// if (socialLogin.isGoogleSupported) {
///   final result = await socialLogin.signInWithGoogle();
/// }
/// 
/// if (socialLogin.isFacebookSupported) {
///   final result = await socialLogin.signInWithFacebook();
/// }
/// ```
class EasySocialLogin {
  static final EasySocialLogin _instance = EasySocialLogin._internal();
  
  factory EasySocialLogin() {
    return _instance;
  }
  
  EasySocialLogin._internal();

  // Lazy initialization of providers
  GoogleSignInProvider? _googleProvider;
  FacebookSignInProvider? _facebookProvider;

  /// Enable debug mode for detailed logging
  static bool enableDebugMode = false;

  /// Get Google Sign-In provider instance
  GoogleSignInProvider get _google {
    _googleProvider ??= GoogleSignInProvider();
    return _googleProvider!;
  }

  /// Get Facebook Login provider instance
  FacebookSignInProvider get _facebook {
    _facebookProvider ??= FacebookSignInProvider();
    return _facebookProvider!;
  }

  /// Check if Google Sign-In is supported on current platform
  bool get isGoogleSupported {
    if (kIsWeb) return true;
    if (Platform.isAndroid || Platform.isIOS) return true;
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) return true;
    return false;
  }

  /// Check if Facebook Login is supported on current platform
  bool get isFacebookSupported {
    if (kIsWeb) return true;
    if (Platform.isAndroid || Platform.isIOS) return true;
    // Facebook Login has limited support on desktop platforms
    return false;
  }

  /// Sign in with Google
  /// 
  /// Parameters:
  /// - [signIntoFirebase]: Whether to also sign into Firebase (default: false)
  /// - [scopes]: Additional scopes to request (default: ['email', 'profile'])
  /// 
  /// Returns [SocialLoginResult] containing user information and credentials
  /// 
  /// Throws:
  /// - [SocialLoginPlatformNotSupportedException] if platform is not supported
  /// - [SocialLoginCancelledException] if user cancels the sign-in
  /// - [SocialLoginNetworkException] if network error occurs
  /// - [SocialLoginFirebaseNotInitializedException] if Firebase is not initialized
  /// - [SocialLoginException] for other errors
  Future<SocialLoginResult> signInWithGoogle({
    bool signIntoFirebase = false,
    List<String> scopes = const ['email', 'profile'],
  }) async {
    if (!isGoogleSupported) {
      throw SocialLoginPlatformNotSupportedException(
        'Google Sign-In is not supported on this platform',
      );
    }

    if (signIntoFirebase) {
      await _ensureFirebaseInitialized();
    }

    if (enableDebugMode) {
      print('EasySocialLogin: Starting Google Sign-In...');
    }

    return await _google.signIn(
      signIntoFirebase: signIntoFirebase,
      scopes: scopes,
    );
  }

  /// Sign in with Facebook
  /// 
  /// Parameters:
  /// - [signIntoFirebase]: Whether to also sign into Firebase (default: false)
  /// - [permissions]: Permissions to request (default: ['email', 'public_profile'])
  /// 
  /// Returns [SocialLoginResult] containing user information and credentials
  /// 
  /// Throws:
  /// - [SocialLoginPlatformNotSupportedException] if platform is not supported
  /// - [SocialLoginCancelledException] if user cancels the login
  /// - [SocialLoginNetworkException] if network error occurs
  /// - [SocialLoginFirebaseNotInitializedException] if Firebase is not initialized
  /// - [SocialLoginException] for other errors
  Future<SocialLoginResult> signInWithFacebook({
    bool signIntoFirebase = false,
    List<String> permissions = const ['email', 'public_profile'],
  }) async {
    if (!isFacebookSupported) {
      throw SocialLoginPlatformNotSupportedException(
        'Facebook Login is not supported on this platform',
      );
    }

    if (signIntoFirebase) {
      await _ensureFirebaseInitialized();
    }

    if (enableDebugMode) {
      print('EasySocialLogin: Starting Facebook Login...');
    }

    return await _facebook.signIn(
      signIntoFirebase: signIntoFirebase,
      permissions: permissions,
    );
  }

  /// Sign out from all providers
  /// 
  /// This will sign out from Google, Facebook, and Firebase (if applicable)
  Future<void> signOut() async {
    if (enableDebugMode) {
      print('EasySocialLogin: Signing out from all providers...');
    }

    final futures = <Future>[];

    // Sign out from Google if provider exists
    if (_googleProvider != null) {
      futures.add(_google.signOut());
    }

    // Sign out from Facebook if provider exists
    if (_facebookProvider != null) {
      futures.add(_facebook.signOut());
    }

    // Wait for all sign-out operations to complete
    await Future.wait(futures);

    if (enableDebugMode) {
      print('EasySocialLogin: Successfully signed out from all providers');
    }
  }

  /// Disconnect/revoke access from all providers
  /// 
  /// This will revoke access tokens and disconnect the app from user accounts
  Future<void> disconnect() async {
    if (enableDebugMode) {
      print('EasySocialLogin: Disconnecting from all providers...');
    }

    final futures = <Future>[];

    // Disconnect from Google if provider exists
    if (_googleProvider != null) {
      futures.add(_google.disconnect());
    }

    // Disconnect from Facebook if provider exists
    if (_facebookProvider != null) {
      futures.add(_facebook.disconnect());
    }

    // Wait for all disconnect operations to complete
    await Future.wait(futures);

    if (enableDebugMode) {
      print('EasySocialLogin: Successfully disconnected from all providers');
    }
  }

  /// Ensure Firebase is initialized before using Firebase features
  Future<void> _ensureFirebaseInitialized() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      if (e.toString().contains('already initialized')) {
        // Firebase is already initialized, which is fine
        return;
      }
      throw SocialLoginFirebaseNotInitializedException(
        'Firebase must be initialized before using Firebase integration. '
        'Call Firebase.initializeApp() in your main() function.',
      );
    }
  }

  /// Get current user information from Google (if signed in)
  Future<SocialLoginResult?> getCurrentGoogleUser() async {
    if (!isGoogleSupported || _googleProvider == null) {
      return null;
    }
    return await _google.getCurrentUser();
  }

  /// Get current user information from Facebook (if signed in)
  Future<SocialLoginResult?> getCurrentFacebookUser() async {
    if (!isFacebookSupported || _facebookProvider == null) {
      return null;
    }
    return await _facebook.getCurrentUser();
  }

  /// Check if user is currently signed in with Google
  Future<bool> isSignedInWithGoogle() async {
    if (!isGoogleSupported || _googleProvider == null) {
      return false;
    }
    return await _google.isSignedIn();
  }

  /// Check if user is currently signed in with Facebook
  Future<bool> isSignedInWithFacebook() async {
    if (!isFacebookSupported || _facebookProvider == null) {
      return false;
    }
    return await _facebook.isSignedIn();
  }
}