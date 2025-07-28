import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/social_login_result.dart';
import '../exceptions/social_login_exceptions.dart';

/// Facebook Login provider implementation
class FacebookSignInProvider {
  /// Check if Facebook Login is supported on current platform
  bool get isSupported {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Sign in with Facebook
  Future<SocialLoginResult> signIn({
    bool signIntoFirebase = true,
    List<String>? permissions,
    LoginBehavior? loginBehavior,
  }) async {
    try {
      if (!isSupported) {
        throw const SocialLoginPlatformNotSupportedException('facebook');
      }

      // Perform Facebook Login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: permissions ?? ['email', 'public_profile'],
        loginBehavior: loginBehavior ?? LoginBehavior.dialogOnly,
      );

      // Handle different login statuses
      switch (result.status) {
        case LoginStatus.success:
          break;
        case LoginStatus.cancelled:
          throw const SocialLoginCancelledException('facebook');
        case LoginStatus.failed:
          throw SocialLoginUnknownException('facebook', result.message);
        case LoginStatus.operationInProgress:
          throw const SocialLoginUnknownException('facebook', 'Operation already in progress');
      }

      final AccessToken? accessToken = result.accessToken;
      if (accessToken == null) {
        throw const SocialLoginUnknownException('facebook', 'Failed to get access token');
      }

      // Get user data
      final Map<String, dynamic> userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200).height(200)",
      );

      // Create Firebase credential
      final credential = FacebookAuthProvider.credential(accessToken.tokenString);

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
          throw SocialLoginUnknownException('facebook', e.toString());
        }
      }

      return SocialLoginResult(
        name: userData['name'],
        email: userData['email'],
        photoUrl: userData['picture']?['data']?['url'],
        accessToken: accessToken.tokenString,
        credential: credential,
        provider: 'facebook',
        firebaseUser: firebaseUser,
        rawData: {
          'id': userData['id'],
          'accessToken': accessToken.toJson(),
          'userData': userData,
        },
      );
    } on SocialLoginException {
      rethrow;
    } catch (e) {
      throw SocialLoginUnknownException('facebook', e.toString());
    }
  }

  /// Sign out from Facebook
  Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      throw SocialLoginUnknownException('facebook', e.toString());
    }
  }

  /// Check if user is currently signed in
  Future<bool> get isSignedIn async {
    try {
      final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      return accessToken != null;
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
      if (await isSignedIn) {
        return await FacebookAuth.instance.getUserData(fields: fields);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}