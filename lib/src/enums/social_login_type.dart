/// Enum representing different social login providers
enum SocialLoginType {
  /// Google Sign-In
  google,
  
  /// Facebook Login
  facebook,
  
  /// Apple Sign In
  apple,
}

/// Extension to get string representation of social login types
extension SocialLoginTypeExtension on SocialLoginType {
  /// Get the string name of the provider
  String get name {
    switch (this) {
      case SocialLoginType.google:
        return 'google';
      case SocialLoginType.facebook:
        return 'facebook';
      case SocialLoginType.apple:
        return 'apple';
    }
  }
}