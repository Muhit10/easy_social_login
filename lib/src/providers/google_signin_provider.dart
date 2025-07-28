import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../exceptions/social_login_exceptions.dart';
import '../models/social_login_result.dart';

class GoogleSignInProvider {
  GoogleSignInAccount? _currentUser;
  bool _isInitialized = false;
  
  // Store scopes for later use in signIn
  List<String> _scopes = [];

  /// Initialize Google Sign-In with configuration
  Future<void> initialize({
    List<String>? scopes,
    String? hostedDomain,
    String? clientId,
    String? serverClientId,
  }) async {
    try {
      // Store scopes for later use in signIn
      _scopes = scopes ?? [];
      
      // Initialize GoogleSignIn instance
      await GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
        hostedDomain: hostedDomain,
      );
      
      _isInitialized = true;
    } catch (e) {
      throw SocialLoginConfigurationException(
        'google',
        'Failed to initialize Google Sign-In: $e',
      );
    }
  }

  /// Check if Google Sign-In is supported on this platform
  bool get isSupported {
    // In Google Sign-In v7, we assume it's supported if initialized
    return _isInitialized;
  }

  /// Sign in with Google
  Future<SocialLoginResult> signIn() async {
    if (!_isInitialized) {
      throw SocialLoginConfigurationException(
        'google',
        'Google Sign-In not initialized. Call initialize() first.',
      );
    }

    try {
      // Use authenticate method with scope hint
      final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate(
        scopeHint: _scopes,
      );
      
      _currentUser = account;

      // Get authentication details (now synchronous)
      final GoogleSignInAuthentication auth = account.authentication;

      // Create Firebase credential using only idToken
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );

      return SocialLoginResult(
        name: account.displayName ?? '',
        email: account.email,
        photoUrl: account.photoUrl,
        provider: 'google',
        credential: credential,
        rawData: {
          'id': account.id,
          'displayName': account.displayName,
          'email': account.email,
          'photoUrl': account.photoUrl,
        },
      );
    } on GoogleSignInException catch (e) {
      // Handle specific Google Sign-In exceptions
      switch (e.code.name) {
        case 'canceled':
          throw SocialLoginCancelledException('google');
        case 'unknown':
          throw SocialLoginUnknownException('google', e);
        default:
          throw SocialLoginUnknownException('google', e);
      }
    } catch (e) {
      throw SocialLoginUnknownException('google', e);
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    _currentUser = null;
  }

/// Get current user
  GoogleSignInAccount? get currentUser => _currentUser;

  /// Check if user is signed in
  bool get isSignedIn => _currentUser != null;
}