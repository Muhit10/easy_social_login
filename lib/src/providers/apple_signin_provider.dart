import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'base_provider.dart';
import '../models/social_login_result.dart';
import '../models/social_login_user.dart';
import '../exceptions/social_login_exceptions.dart';
import '../enums/social_login_type.dart';

/// Apple Sign-In provider implementation
class AppleSignInProvider extends SocialLoginProvider {
  /// Creates an Apple Sign-In provider
  const AppleSignInProvider() : super(SocialLoginType.apple);


  /// Sign in with Apple
  @override
  Future<SocialLoginResult> signIn({bool signIntoFirebase = false}) async {
    try {
      // Check if Apple Sign In is available on this device
      if (!await SignInWithApple.isAvailable()) {
        throw SocialLoginPlatformNotSupportedException(
          'Apple Sign In is not available on this device',
        );
      }

      // Check Firebase initialization if needed
      if (signIntoFirebase && Firebase.apps.isEmpty) {
        throw const SocialLoginFirebaseNotInitializedException();
      }

      // Request Apple Sign In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      User? firebaseUser;
      AuthCredential? firebaseCredential;

      // Sign into Firebase if requested
      if (signIntoFirebase) {
        try {
          firebaseCredential = OAuthProvider('apple.com').credential(
            idToken: credential.identityToken,
            accessToken: credential.authorizationCode,
          );
          
          final userCredential = await FirebaseAuth.instance
              .signInWithCredential(firebaseCredential);
          firebaseUser = userCredential.user;
        } catch (e) {
          // Firebase sign-in failed, but we can still return Apple user data
        }
      }

      // Create SocialLoginUser from Apple data
      final fullName = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
      final socialUser = SocialLoginUser(
        id: credential.userIdentifier ?? '',
        name: fullName,
        email: credential.email,
        photoUrl: null, // Apple doesn't provide profile photos
        additionalData: {
          'accessToken': credential.authorizationCode,
          'identityToken': credential.identityToken,
        },
      );

      return SocialLoginResult(
        name: fullName,
        email: credential.email,
        photoUrl: null,
        accessToken: credential.authorizationCode,
        credential: firebaseCredential,
        provider: SocialLoginType.apple.name,
        firebaseUser: firebaseUser,
        user: socialUser,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const SocialLoginCancelledException('apple');
      }
      throw SocialLoginUnknownException('apple', 'Apple Sign In failed: ${e.toString()}');
    } on SocialLoginException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('canceled')) {
        throw const SocialLoginCancelledException('apple');
      }
      throw SocialLoginUnknownException('apple', 'Apple Sign In failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    // Apple doesn't provide a sign out method
    // The app should handle this by clearing local session data
  }

  @override
  bool get isSignedIn {
    // Apple doesn't provide a way to check if user is signed in
    // The app should track this state locally
    return false;
  }

  @override
  bool get isSupported {
    // Note: SignInWithApple.isAvailable() is async, so we return true
    // and let the actual sign-in method handle availability checks
    return true;
  }

}