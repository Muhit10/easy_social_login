import '../models/social_login_result.dart';
import '../enums/social_login_type.dart';

/// Abstract base class for social login providers
abstract class SocialLoginProvider {
  /// The type of this social login provider
  final SocialLoginType type;
  
  /// Constructor requiring the provider type
  const SocialLoginProvider(this.type);
  /// Whether this provider is supported on the current platform
  bool get isSupported;
  
  /// Whether the user is currently signed in with this provider
  bool get isSignedIn;
  
  /// Sign in with this provider
  /// 
  /// [signIntoFirebase] - Whether to also sign into Firebase with the credentials
  /// Returns a [SocialLoginResult] containing user data and credentials
  Future<SocialLoginResult> signIn({bool signIntoFirebase = false});
  
  /// Sign out from this provider
  Future<void> signOut();
}