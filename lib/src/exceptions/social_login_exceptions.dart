/// Custom exceptions for social login operations
abstract class SocialLoginException implements Exception {
  final String message;
  final String provider;
  final dynamic originalError;

  const SocialLoginException(this.message, this.provider, [this.originalError]);

  @override
  String toString() => 'SocialLoginException($provider): $message';
}

/// Thrown when user cancels the authentication flow
class SocialLoginCancelledException extends SocialLoginException {
  const SocialLoginCancelledException(String provider)
      : super('User cancelled the authentication flow', provider);
}

/// Thrown when there's a network connectivity issue
class SocialLoginNetworkException extends SocialLoginException {
  const SocialLoginNetworkException(String provider, [dynamic originalError])
      : super('Network error occurred during authentication', provider, originalError);
}

/// Thrown when the provider is not supported on current platform
class SocialLoginPlatformNotSupportedException extends SocialLoginException {
  const SocialLoginPlatformNotSupportedException(String provider)
      : super('Provider not supported on current platform', provider);
}

/// Thrown when required permissions are denied
class SocialLoginPermissionDeniedException extends SocialLoginException {
  const SocialLoginPermissionDeniedException(String provider)
      : super('Required permissions were denied', provider);
}

/// Thrown when Firebase is not initialized but Firebase integration is requested
class SocialLoginFirebaseNotInitializedException extends SocialLoginException {
  const SocialLoginFirebaseNotInitializedException()
      : super('Firebase is not initialized. Call Firebase.initializeApp() first', 'firebase');
}

/// Thrown when an unknown error occurs during authentication
class SocialLoginUnknownException extends SocialLoginException {
  const SocialLoginUnknownException(String provider, [dynamic originalError])
      : super('An unknown error occurred during authentication', provider, originalError);
}

/// Thrown when the authentication configuration is invalid
class SocialLoginConfigurationException extends SocialLoginException {
  const SocialLoginConfigurationException(String provider, String details)
      : super('Configuration error: $details', provider);
}