// Export public API
export 'src/models/social_login_result.dart';
export 'src/exceptions/social_login_exceptions.dart';
export 'src/widgets/social_login_button.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'src/models/social_login_result.dart';
import 'src/exceptions/social_login_exceptions.dart';
import 'src/providers/google_signin_provider.dart';
import 'src/providers/facebook_signin_provider.dart';

/// Main class for easy social login functionality
/// 
/// Provides a unified interface for Google and Facebook authentication
/// with optional Firebase integration and comprehensive error handling.
class EasySocialLogin {
  static final EasySocialLogin _instance = EasySocialLogin._internal();
  factory EasySocialLogin() => _instance;
  EasySocialLogin._internal();

  final GoogleSignInProvider _googleProvider = GoogleSignInProvider();
  final FacebookSignInProvider _facebookProvider = FacebookSignInProvider();

  bool _firebaseInitialized = false;

  /// Initialize Firebase if not already done
  /// 
  /// This is automatically called when Firebase integration is requested,
  /// but can be called manually for better control.
  Future<void> initializeFirebase() async {
    if (!_firebaseInitialized && Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      _firebaseInitialized = true;
    }
  }

  /// Sign in with Google
  /// 
  /// [signIntoFirebase] - Whether to sign into Firebase after Google authentication
  /// [scopes] - List of OAuth scopes to request
  /// [hostedDomain] - Restrict sign-in to users from a specific domain
  /// [clientId] - Custom OAuth client ID
  /// [serverClientId] - Server client ID for backend authentication
  /// 
  /// Returns [SocialLoginResult] with user information and credentials
  /// 
  /// Throws [SocialLoginException] on authentication errors
  Future<SocialLoginResult> signInWithGoogle({
    bool signIntoFirebase = true,
    List<String>? scopes,
    String? hostedDomain,
    String? clientId,
    String? serverClientId,
  }) async {
    if (signIntoFirebase) {
      await initializeFirebase();
    }

    // Initialize Google provider if not already done
    await _googleProvider.initialize(
      scopes: scopes,
      hostedDomain: hostedDomain,
      clientId: clientId,
      serverClientId: serverClientId,
    );

    return await _googleProvider.signIn();
  }

  /// Sign in with Facebook
  /// 
  /// [signIntoFirebase] - Whether to sign into Firebase after Facebook authentication
  /// [permissions] - List of Facebook permissions to request
  /// [loginBehavior] - Facebook login behavior (dialog, web, etc.)
  /// 
  /// Returns [SocialLoginResult] with user information and credentials
  /// 
  /// Throws [SocialLoginException] on authentication errors
  Future<SocialLoginResult> signInWithFacebook({
    bool signIntoFirebase = true,
    List<String>? permissions,
    LoginBehavior? loginBehavior,
  }) async {
    if (signIntoFirebase) {
      await initializeFirebase();
    }

    return await _facebookProvider.signIn(
      signIntoFirebase: signIntoFirebase,
      permissions: permissions,
      loginBehavior: loginBehavior,
    );
  }

  /// Sign out from all providers
  /// 
  /// This will sign out from Google, Facebook, and Firebase (if applicable)
  Future<void> signOut() async {
    final List<Future<void>> signOutFutures = [];

    // Sign out from Firebase
    if (_firebaseInitialized || Firebase.apps.isNotEmpty) {
      signOutFutures.add(FirebaseAuth.instance.signOut());
    }

    // Sign out from Google
    signOutFutures.add(_googleProvider.signOut());

    // Sign out from Facebook
    signOutFutures.add(_facebookProvider.signOut());

    // Wait for all sign-out operations to complete
    await Future.wait(signOutFutures);
  }

  /// Sign out from Google only
  Future<void> signOutGoogle() async {
    await _googleProvider.signOut();
  }

  /// Sign out from Facebook only
  Future<void> signOutFacebook() async {
    await _facebookProvider.signOut();
  }

  /// Sign out from Firebase only
  Future<void> signOutFirebase() async {
    if (_firebaseInitialized || Firebase.apps.isNotEmpty) {
      await FirebaseAuth.instance.signOut();
    }
  }

  /// Disconnect Google account (revokes access)
  /// Note: This functionality is not available in Google Sign-In v7
  @Deprecated('Google Sign-In v7 no longer supports disconnect functionality')
  Future<void> disconnectGoogle() async {
    // Google Sign-In v7 removed the disconnect functionality
    // Use signOutGoogle() instead
    await _googleProvider.signOut();
  }

  /// Check if Google is supported on current platform
  bool get isGoogleSupported => _googleProvider.isSupported;

  /// Check if Facebook is supported on current platform
  bool get isFacebookSupported => _facebookProvider.isSupported;

  /// Check if user is signed in with Google
  bool get isGoogleSignedIn => _googleProvider.isSignedIn;

  /// Check if user is signed in with Facebook
  Future<bool> get isFacebookSignedIn => _facebookProvider.isSignedIn;

  /// Get current Google user
  GoogleSignInAccount? get currentGoogleUser => _googleProvider.currentUser;

  /// Get current Facebook access token
  Future<AccessToken?> get currentFacebookAccessToken => _facebookProvider.currentAccessToken;

  /// Get current Facebook user data
  Future<Map<String, dynamic>?> getCurrentFacebookUserData({
    String fields = "name,email,picture.width(200).height(200)",
  }) => _facebookProvider.getCurrentUserData(fields: fields);

  /// Get current Firebase user
  User? get currentFirebaseUser {
    if (_firebaseInitialized || Firebase.apps.isNotEmpty) {
      return FirebaseAuth.instance.currentUser;
    }
    return null;
  }

  /// Check if Firebase is initialized
  bool get isFirebaseInitialized => _firebaseInitialized || Firebase.apps.isNotEmpty;

  /// Initialize Google Sign-In with custom configuration
  Future<void> initializeGoogle({
    List<String>? scopes,
    String? hostedDomain,
    String? clientId,
    String? serverClientId,
  }) async {
    await _googleProvider.initialize(
      scopes: scopes,
      hostedDomain: hostedDomain,
      clientId: clientId,
      serverClientId: serverClientId,
    );
  }
}
