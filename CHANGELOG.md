## 1.0.0

* **Initial Release** 🎉
  * Unified interface for Google Sign-In and Facebook Login
  * Optional Firebase integration with automatic initialization
  * Comprehensive error handling with specific exception types
  * Customizable UI components (SocialLoginButton, SocialLoginButtonRow, SocialLoginButtonColumn)
  * Platform-aware authentication (Android, iOS, Web, macOS support)
  * Production-ready with extensive documentation and examples
  * Zero-boilerplate setup with automatic dependency management
  * Support for custom scopes, permissions, and configuration options
  * Singleton pattern for consistent state management
  * Full test coverage with unit tests for all components

### Features

* **Google Sign-In**
  * Custom scopes support
  * Hosted domain restriction
  * Custom client ID configuration
  * Automatic platform detection

* **Facebook Login**
  * Custom permissions support
  * Multiple login behaviors (dialog, web, etc.)
  * Comprehensive user data retrieval

* **Firebase Integration**
  * Optional Firebase Auth integration
  * Automatic Firebase initialization
  * Support for credential-only mode (no Firebase sign-in)

* **UI Components**
  * Pre-styled Google and Facebook login buttons
  * Fully customizable button appearance
  * Button row and column layouts
  * Loading states and custom loading widgets

* **Error Handling**
  * SocialLoginCancelledException
  * SocialLoginNetworkException
  * SocialLoginPlatformNotSupportedException
  * SocialLoginPermissionDeniedException
  * SocialLoginFirebaseNotInitializedException
  * SocialLoginUnknownException
  * SocialLoginConfigurationException

* **Developer Experience**
  * Comprehensive documentation
  * Example implementations
  * Type-safe API with null safety
  * Extensive unit test coverage
  * Clean architecture with separation of concerns
