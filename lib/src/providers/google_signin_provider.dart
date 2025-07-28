import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/social_login_result.dart';
import '../exceptions/social_login_exceptions.dart';

/// Google Sign-In provider implementation
class GoogleSignInProvider {
  bool _isInitialized = false;
  GoogleSignInAccount? _currentUser;
  
  /// Initialize Google Sign-In with custom configuration
  Future<void> initialize({
    List<String>? scopes,
    String? hostedDomain,
    String? clientId,
    String? serverClientId,
  }) async {
    if (_isInitialized) return;
    
    await GoogleSignIn.instance.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );
    
    // Listen to authentication events to track current user
    GoogleSignIn.instance.authenticationEvents.listen((event) {
      switch (event) {
        case GoogleSignInAuthenticationEventSignIn():
          _currentUser = event.user;
          break;
        case GoogleSignInAuthenticationEventSignOut():
          _currentUser = null;
          break;
      }
    });
    
    _isInitialized = true;
  }

  /// Check if Google Sign-In is supported on current platform
  bool get isSupported {
    return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
  }

  /// Sign in with Google
  Future<SocialLoginResult> signIn({
    bool signIntoFirebase = true,
    List<String>? scopes,
    String? hostedDomain,
    String? clientId,
    String? serverClientId,
  }) async {
    try {
      if (!isSupported) {
        throw const SocialLoginPlatformNotSupportedException('google');
      }

      // Initialize if not already done
      if (!_isInitialized) {
        await initialize(
          scopes: scopes,
          hostedDomain: hostedDomain,
          clientId: clientId,
          serverClientId: serverClientId,
        );
      }

      // Perform Google Sign-In using the new API
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
      
      if (googleUser == null) {
        throw const SocialLoginCancelledException('google');
      }

      // Update current user state
      _currentUser = googleUser;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        throw const SocialLoginUnknownException('google', 'Failed to get authentication tokens');
      }

      // Create Firebase credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      User? firebaseUser;
      
      // Sign into Firebase if requested
      if (signIntoFirebase) {
        try {
          // Check if Firebase is initialized
          if (Firebase.apps.isEmpty) {
            throw const SocialLoginFirebaseNotInitializedException();
          }
          
          final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          firebaseUser = userCredential.user;
        } catch (e) {
          if (e is SocialLoginFirebaseNotInitializedException) rethrow;
          throw SocialLoginUnknownException('google', e);
        }
      }

      return SocialLoginResult(
        name: googleUser.displayName,
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
        accessToken: null, // Access token is handled differently in new API
        credential: credential,
        provider: 'google',
        firebaseUser: firebaseUser,
        rawData: {
          'id': googleUser.id,
          'idToken': googleAuth.idToken,
        },
      );
    } on SocialLoginException {
      rethrow;
    } catch (e) {
      throw SocialLoginUnknownException('google', e);
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
      _currentUser = null;
    } catch (e) {
      throw SocialLoginUnknownException('google', e);
    }
  }

  /// Disconnect Google account
  Future<void> disconnect() async {
    try {
      await GoogleSignIn.instance.disconnect();
      _currentUser = null;
    } catch (e) {
      throw SocialLoginUnknownException('google', e);
    }
  }

  /// Check if user is currently signed in
  bool get isSignedIn {
    return _currentUser != null;
  }

  /// Get the current signed-in user
  GoogleSignInAccount? get currentUser => _currentUser;
}