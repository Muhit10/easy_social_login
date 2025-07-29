import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'base_provider.dart';
import '../models/social_login_result.dart';
import '../exceptions/social_login_exceptions.dart';
import '../models/social_login_user.dart';
import '../enums/social_login_type.dart';

/// Facebook Login provider implementation
class FacebookSignInProvider extends SocialLoginProvider {
  /// Creates a Facebook Sign-In provider
  const FacebookSignInProvider() : super(SocialLoginType.facebook);
  /// Check if Facebook Login is supported on current platform
  @override
  bool get isSupported {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Sign in with Facebook
  @override
  Future<SocialLoginResult> signIn({bool signIntoFirebase = false}) async {
    try {
      if (!isSupported) {
        throw const SocialLoginPlatformNotSupportedException('facebook');
      }

      // Perform Facebook Login
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        if (accessToken == null) {
          throw const SocialLoginConfigurationException('facebook', 'Failed to get access token');
        }

        // Create Firebase credential
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);

        // Get user data
        final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200).height(200)",
        );

        User? firebaseUser;
        
        // Try Firebase authentication if requested and available
        if (signIntoFirebase) {
          try {
            // Check if Firebase is initialized
            if (Firebase.apps.isNotEmpty) {
              final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
              firebaseUser = userCredential.user;
            }
          } catch (e) {
            // Firebase auth failed, continue without it
            firebaseUser = null;
          }
        }

        // Create SocialLoginUser from Facebook data
        final socialUser = SocialLoginUser(
          id: userData['id'],
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          photoUrl: userData['picture']?['data']?['url'],
          additionalData: {
            'accessToken': accessToken.tokenString,
          },
        );

        return SocialLoginResult(
          user: socialUser,
          firebaseUser: firebaseUser,
          credential: credential,
          provider: SocialLoginType.facebook.name,
        );
      } else if (result.status == LoginStatus.cancelled) {
        throw const SocialLoginCancelledException('facebook');
      } else {
        throw SocialLoginUnknownException('facebook', result.message ?? 'Login failed');
      }
    } on SocialLoginException {
      rethrow;
    } catch (e) {
      throw SocialLoginUnknownException('facebook', e.toString());
    }
  }

  /// Sign out from Facebook
  @override
  Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      throw SocialLoginUnknownException('facebook', e.toString());
    }
  }

  /// Check if user is currently signed in
  @override
  bool get isSignedIn {
    try {
      // Note: This is a synchronous check, for async check use FacebookAuth.instance.accessToken
      return false; // Simplified for now, can be enhanced with cached state
    } catch (e) {
      return false;
    }
  }

  /// Get current access token
  Future<AccessToken?> get currentAccessToken async {
    try {
      return await FacebookAuth.instance.accessToken;
    } catch (e) {
      return null;
    }
  }

  /// Get current user data
  Future<Map<String, dynamic>?> getCurrentUserData({
    String fields = "name,email,picture.width(200).height(200)",
  }) async {
    try {
      if (isSignedIn) {
        return await FacebookAuth.instance.getUserData(fields: fields);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}