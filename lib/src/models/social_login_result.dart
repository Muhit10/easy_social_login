import 'package:firebase_auth/firebase_auth.dart';
import 'social_login_user.dart';

/// Result object returned by social login operations
/// Contains user information and authentication credentials
class SocialLoginResult {
  /// User's display name
  final String? name;
  
  /// User's email address
  final String? email;
  
  /// URL to user's profile photo
  final String? photoUrl;
  
  /// OAuth access token for API calls
  final String? accessToken;
  
  /// Firebase authentication credential (if Firebase integration is enabled)
  final AuthCredential? credential;
  
  /// Provider name ('google' or 'facebook')
  final String provider;
  
  /// Firebase User object (if signed into Firebase)
  final User? firebaseUser;
  
  /// Raw provider data for advanced use cases
  final Map<String, dynamic>? rawData;
  
  /// User information from the social login provider
  final SocialLoginUser? user;

  const SocialLoginResult({
    this.name,
    this.email,
    this.photoUrl,
    this.accessToken,
    this.credential,
    required this.provider,
    this.firebaseUser,
    this.rawData,
    this.user,
  });

  /// Creates a copy of this result with updated values
  SocialLoginResult copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? accessToken,
    AuthCredential? credential,
    String? provider,
    User? firebaseUser,
    Map<String, dynamic>? rawData,
  }) {
    return SocialLoginResult(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      accessToken: accessToken ?? this.accessToken,
      credential: credential ?? this.credential,
      provider: provider ?? this.provider,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      rawData: rawData ?? this.rawData,
    );
  }

  /// Converts the result to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'accessToken': accessToken,
      'provider': provider,
      'firebaseUser': firebaseUser?.uid,
      'rawData': rawData,
    };
  }

  @override
  String toString() {
    return 'SocialLoginResult(name: $name, email: $email, provider: $provider)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SocialLoginResult &&
        other.name == name &&
        other.email == email &&
        other.provider == provider;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ provider.hashCode;
  }
}