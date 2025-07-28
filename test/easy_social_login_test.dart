import 'package:flutter_test/flutter_test.dart';
import 'package:easy_social_login/easy_social_login.dart';

void main() {
  group('EasySocialLogin', () {
    late EasySocialLogin easySocialLogin;

    setUp(() {
      easySocialLogin = EasySocialLogin();
    });

    test('should be a singleton', () {
      final instance1 = EasySocialLogin();
      final instance2 = EasySocialLogin();
      expect(instance1, equals(instance2));
    });

    test('should check platform support correctly', () {
      // These tests will depend on the platform the tests are running on
      expect(easySocialLogin.isGoogleSupported, isA<bool>());
      expect(easySocialLogin.isFacebookSupported, isA<bool>());
    });

    test('should initialize Firebase correctly', () async {
      // This test would need Firebase to be properly configured
      // In a real test environment, you'd mock Firebase
      expect(easySocialLogin.isFirebaseInitialized, isA<bool>());
    });
  });

  group('SocialLoginResult', () {
    test('should create result with required fields', () {
      const result = SocialLoginResult(
        provider: 'google',
        name: 'Test User',
        email: 'test@example.com',
      );

      expect(result.provider, equals('google'));
      expect(result.name, equals('Test User'));
      expect(result.email, equals('test@example.com'));
    });

    test('should convert to JSON correctly', () {
      const result = SocialLoginResult(
        provider: 'facebook',
        name: 'Test User',
        email: 'test@example.com',
        accessToken: 'test_token',
      );

      final json = result.toJson();
      expect(json['provider'], equals('facebook'));
      expect(json['name'], equals('Test User'));
      expect(json['email'], equals('test@example.com'));
      expect(json['accessToken'], equals('test_token'));
    });

    test('should implement equality correctly', () {
      const result1 = SocialLoginResult(
        provider: 'google',
        name: 'Test User',
        email: 'test@example.com',
      );

      const result2 = SocialLoginResult(
        provider: 'google',
        name: 'Test User',
        email: 'test@example.com',
      );

      const result3 = SocialLoginResult(
        provider: 'facebook',
        name: 'Test User',
        email: 'test@example.com',
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });

    test('should copy with new values', () {
      const original = SocialLoginResult(
        provider: 'google',
        name: 'Test User',
        email: 'test@example.com',
      );

      final copied = original.copyWith(
        name: 'New Name',
        provider: 'facebook',
      );

      expect(copied.name, equals('New Name'));
      expect(copied.provider, equals('facebook'));
      expect(copied.email, equals('test@example.com')); // Should remain unchanged
    });
  });

  group('SocialLoginExceptions', () {
    test('should create cancellation exception', () {
      const exception = SocialLoginCancelledException('google');
      expect(exception.provider, equals('google'));
      expect(exception.message, contains('cancelled'));
    });

    test('should create network exception', () {
      const exception = SocialLoginNetworkException('facebook');
      expect(exception.provider, equals('facebook'));
      expect(exception.message, contains('Network error'));
    });

    test('should create platform not supported exception', () {
      const exception = SocialLoginPlatformNotSupportedException('google');
      expect(exception.provider, equals('google'));
      expect(exception.message, contains('not supported'));
    });

    test('should create permission denied exception', () {
      const exception = SocialLoginPermissionDeniedException('facebook');
      expect(exception.provider, equals('facebook'));
      expect(exception.message, contains('permissions were denied'));
    });

    test('should create Firebase not initialized exception', () {
      const exception = SocialLoginFirebaseNotInitializedException();
      expect(exception.provider, equals('firebase'));
      expect(exception.message, contains('not initialized'));
    });

    test('should create unknown exception', () {
      const exception = SocialLoginUnknownException('google', 'Test error');
      expect(exception.provider, equals('google'));
      expect(exception.originalError, equals('Test error'));
    });

    test('should create configuration exception', () {
      const exception = SocialLoginConfigurationException('google', 'Invalid client ID');
      expect(exception.provider, equals('google'));
      expect(exception.message, contains('Invalid client ID'));
    });
  });
}
