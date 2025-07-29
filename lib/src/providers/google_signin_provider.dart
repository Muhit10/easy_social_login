import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../enums/social_login_type.dart';
import '../exceptions/social_login_exceptions.dart';
import '../models/social_login_result.dart';
import '../models/social_login_user.dart';
import 'base_provider.dart';

class GoogleSignInProvider extends SocialLoginProvider {
  GoogleSignInProvider() : super(SocialLoginType.google) {
    _googleSignIn = GoogleSignIn.instance;
  }
  
  static bool _isInitialized = false;
  GoogleSignInAccount? _currentUser;
  bool _signIntoFirebase = false;
  late GoogleSignIn _googleSignIn;
  
  Future<void> initialize({
    String? clientId,
    List<String>? scopes,
    String? serverClientId,
    String? hostedDomain,
  }) async {
    if (_isInitialized) return;
    
    try {
      // GoogleSignIn.instance is already configured through platform setup
      // Store configuration for later use if needed
      _isInitialized = true;
    } catch (e) {
      throw SocialLoginConfigurationException(
        'google',
        'Failed to initialize Google Sign-In: $e',
      );
    }
  }

  /// Check if Google Sign-In is supported on this platform
  @override
  bool get isSupported {
    // Google Sign-In is supported on Android and iOS
    return true;
  }

  /// Signs in the user with Google
  @override
  Future<SocialLoginResult> signIn({bool signIntoFirebase = false}) async {
    if (!isSupported) {
      throw SocialLoginConfigurationException('google', 'Google Sign-In is not supported on this platform');
    }

    try {
      _signIntoFirebase = signIntoFirebase;
      
      // Try to authenticate the user
      GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      
      if (googleUser == null) {
        throw SocialLoginCancelledException('google');
      }
      
      // Store the current user
      _currentUser = googleUser;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        throw SocialLoginUnknownException('google', 'Failed to get ID token from Google');
      }
      
      // Firebase integration if enabled
      AuthCredential? firebaseCredential;
      User? firebaseUser;
      
      if (signIntoFirebase) {
        try {
          firebaseCredential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
          );
          
          final userCredential = await FirebaseAuth.instance.signInWithCredential(firebaseCredential);
          firebaseUser = userCredential.user;
        } catch (e) {
          throw SocialLoginUnknownException('google', 'Firebase authentication failed: $e');
        }
      }

      // Create user object
      final user = SocialLoginUser(
        id: googleUser.id,
        name: googleUser.displayName ?? '',
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
      );

      final result = SocialLoginResult(
        user: user,
        name: googleUser.displayName,
        email: googleUser.email,
        photoUrl: googleUser.photoUrl,
        accessToken: googleAuth.idToken ?? '',
        credential: firebaseCredential,
        provider: 'google',
        firebaseUser: firebaseUser,
        rawData: {
          'idToken': googleAuth.idToken ?? '',
        },
      );

      return result;
    } catch (e) {
      if (e is SocialLoginException) {
        rethrow;
      }
      throw SocialLoginUnknownException('google', 'Google sign-in failed: $e');
    }
  }

  /// Sign out from Google
  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      
      // Sign out from Firebase if enabled
      if (_signIntoFirebase && FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      throw SocialLoginUnknownException('google', e);
    }
  }

  /// Disconnect from Google (revoke access)
  Future<void> disconnect() async {
    await _googleSignIn.disconnect();
    _currentUser = null;
  }

  /// Whether the user is currently signed in
  @override
  bool get isSignedIn {
    return _currentUser != null;
  }

  /// Get current user
  GoogleSignInAccount? get currentUser => _currentUser;
}