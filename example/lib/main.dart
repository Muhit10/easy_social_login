import 'package:flutter/material.dart';
import 'package:easy_social_login/easy_social_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Social Login Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final EasySocialLogin _socialLogin = EasySocialLogin();
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  SocialLoginResult? _lastResult;
  String? _errorMessage;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _socialLogin.signInWithGoogle(
        signIntoFirebase: true,
      );
      
      setState(() {
        _lastResult = result;
      });
      
      _showSuccessDialog(result);
    } on SocialLoginCancelledException {
      setState(() {
        _errorMessage = 'Google sign-in was cancelled';
      });
    } on SocialLoginNetworkException catch (e) {
      setState(() {
        _errorMessage = 'Network error: ${e.message}';
      });
    } on SocialLoginPlatformNotSupportedException {
      setState(() {
        _errorMessage = 'Google Sign-In is not supported on this platform';
      });
    } on SocialLoginException catch (e) {
      setState(() {
        _errorMessage = 'Google sign-in failed: ${e.message}';
      });
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() {
      _isFacebookLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _socialLogin.signInWithFacebook(
        signIntoFirebase: true,
      );
      
      setState(() {
        _lastResult = result;
      });
      
      _showSuccessDialog(result);
    } on SocialLoginCancelledException {
      setState(() {
        _errorMessage = 'Facebook login was cancelled';
      });
    } on SocialLoginNetworkException catch (e) {
      setState(() {
        _errorMessage = 'Network error: ${e.message}';
      });
    } on SocialLoginPlatformNotSupportedException {
      setState(() {
        _errorMessage = 'Facebook Login is not supported on this platform';
      });
    } on SocialLoginException catch (e) {
      setState(() {
        _errorMessage = 'Facebook login failed: ${e.message}';
      });
    } finally {
      setState(() {
        _isFacebookLoading = false;
      });
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await _socialLogin.signOut();
      setState(() {
        _lastResult = null;
        _errorMessage = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed out from all providers'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign out failed: $e';
      });
    }
  }

  void _showSuccessDialog(SocialLoginResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Welcome, ${result.name ?? 'User'}!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.photoUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(result.photoUrl!),
                ),
              ),
            const SizedBox(height: 16),
            Text('Provider: ${result.provider}'),
            if (result.email != null) Text('Email: ${result.email}'),
            if (result.firebaseUser != null) 
              Text('Firebase UID: ${result.firebaseUser!.uid}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Easy Social Login Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.login,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 32),
            const Text(
              'Welcome to Easy Social Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sign in with your preferred social provider',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // Social Login Buttons
            SocialLoginButtonColumn(
              spacing: 16,
              buttons: [
                SocialLoginButton.google(
                  onPressed: _socialLogin.isGoogleSupported ? _handleGoogleSignIn : null,
                  isLoading: _isGoogleLoading,
                  text: _socialLogin.isGoogleSupported 
                    ? 'Sign in with Google' 
                    : 'Google not supported',
                ),
                SocialLoginButton.facebook(
                  onPressed: _socialLogin.isFacebookSupported ? _handleFacebookSignIn : null,
                  isLoading: _isFacebookLoading,
                  text: _socialLogin.isFacebookSupported 
                    ? 'Continue with Facebook' 
                    : 'Facebook not supported',
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            
            // User Info
            if (_lastResult != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Signed in successfully!',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Provider: ${_lastResult!.provider}'),
                    if (_lastResult!.name != null) 
                      Text('Name: ${_lastResult!.name}'),
                    if (_lastResult!.email != null) 
                      Text('Email: ${_lastResult!.email}'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleSignOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            
            // Platform Support Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Platform Support',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _socialLogin.isGoogleSupported 
                            ? Icons.check_circle 
                            : Icons.cancel,
                          color: _socialLogin.isGoogleSupported 
                            ? Colors.green 
                            : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text('Google Sign-In'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _socialLogin.isFacebookSupported 
                            ? Icons.check_circle 
                            : Icons.cancel,
                          color: _socialLogin.isFacebookSupported 
                            ? Colors.green 
                            : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text('Facebook Login'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}