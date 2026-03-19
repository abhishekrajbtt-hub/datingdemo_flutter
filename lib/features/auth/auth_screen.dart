import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isSignUp = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  bool _isGoogleLoading = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final authService = context.read<AuthService>();
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Enter a valid email.');
      return;
    }

    setState(() => _isSendingOtp = true);
    try {
      await authService.sendEmailOtp(
        email: email,
        isSignUp: _isSignUp,
      );
      if (!mounted) return;
      setState(() => _otpSent = true);
      _showMessage('OTP sent to $email');
    } catch (e) {
      _showMessage('Could not send OTP: $e');
    } finally {
      if (mounted) {
        setState(() => _isSendingOtp = false);
      }
    }
  }

  Future<void> _verifyOtp() async {
    final authService = context.read<AuthService>();
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    if (otp.length < 4) {
      _showMessage('Enter a valid OTP.');
      return;
    }

    setState(() => _isVerifyingOtp = true);
    try {
      final verified = await authService.verifyEmailOtp(
        email: email,
        code: otp,
        isSignUp: _isSignUp,
      );
      if (!mounted) return;
      if (verified) {
        _showMessage('Email OTP verified. Continue with profile setup next.');
      } else {
        _showMessage('Invalid OTP.');
      }
    } catch (e) {
      _showMessage('Could not verify OTP: $e');
    } finally {
      if (mounted) {
        setState(() => _isVerifyingOtp = false);
      }
    }
  }

  Future<void> _googleSignIn() async {
    final authService = context.read<AuthService>();
    setState(() => _isGoogleLoading = true);
    try {
      await authService.signInWithGoogle();
    } catch (e) {
      _showMessage('Google sign-in failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DatingDemo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(value: false, label: Text('Login')),
                ButtonSegment<bool>(value: true, label: Text('Sign up')),
              ],
              selected: {_isSignUp},
              onSelectionChanged: (selection) {
                setState(() {
                  _isSignUp = selection.first;
                  _otpSent = false;
                  _otpController.clear();
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _isSendingOtp ? null : _sendOtp,
              child: _isSendingOtp
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_otpSent ? 'Resend OTP' : 'Send OTP'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: (_isVerifyingOtp || !_otpSent) ? null : _verifyOtp,
              child: _isVerifyingOtp
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Verify OTP'),
            ),
            const Divider(height: 32),
            FilledButton.icon(
              onPressed: _isGoogleLoading ? null : _googleSignIn,
              icon: _isGoogleLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.g_mobiledata),
              label: const Text('Continue with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
